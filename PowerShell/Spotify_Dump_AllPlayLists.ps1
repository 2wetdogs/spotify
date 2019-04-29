param(
    [string]$user,    
    [string]$token,
    [string]$fileName = "AllTracks.csv",
	[bool]$ToDatabase = $false,
	[string]$DatabaseConnectionString = "Server=localhost\SQLEXPRESS;Database=Spotify;Integrated Security=True"
)

$RunID = (get-date).ToUniversalTime().ToString("yyyyMMddHHmmss")


function Get_Full_List_of_Spotify_PlayLists([array]$Spotify_Playlists,[string]$user,[string]$token,[int]$playListCount=0,[int]$offset = 0,[int]$limit = 50){
    $url = "https://api.spotify.com/v1/users/$user/playlists?limit=$limit&offset=$offset"
    $headers = @{"Authorization" = "Bearer " + $token}

    Try{
        $results = Invoke-RestMethod -Uri $url -Headers $headers
    }
    Catch{
        write-host $_
        Start-Process chrome.exe https://developer.spotify.com/console/get-playlists/
        exit
    }


    $playListCount = $results.total
   
    foreach ($PlayList in $results.items){
        $Spotify_Playlists += $PlayList
    }

    if (($offset + $limit) -lt $playListCount){
        if(($playListCount - ($offset + $limit)) -lt 50){
            $limit = ($playListCount - ($offset + $limit))
        } 
        $offset = $offset + 50
        Get_Full_List_of_Spotify_PlayLists $Spotify_Playlists $user $token $playListCount $offset $limit
    }
    else {
        Return $Spotify_Playlists    
    }
}

function Get_Full_List_of_Spotify_PlayList_Tracks([string]$playListId,[string]$token,$trackList = @(),[int]$trackCount=0,[int]$offset = 0,[int]$limit = 100){
    $url = "https://api.spotify.com/v1/playlists/$playListId/tracks?limit=$limit&offset=$offset"
    $headers = @{"Authorization" = "Bearer " + $token}
    $results = Invoke-RestMethod -Uri $url -Headers $headers
    $trackCount = $results.total  
    foreach ($track in $results.items){
        $trackList += $track
    }

    if (($offset + $limit) -lt $trackCount){
        if(($trackCount - ($offset + $limit)) -lt 100){
            $limit = ($trackCount - ($offset + $limit))
        } 
        $offset = $offset + 100
        Get_Full_List_of_Spotify_PlayList_Tracks $playListId $token $trackList $trackCount $offset $limit
    }
    else {
        Write-Host "Track Count:" $trackCount
        Return $trackList    
    }
}

function DumpAppTracks(){
    $Spotify_PlayList_List = @()
    $Spotify_PlayList_List =  Get_Full_List_of_Spotify_PlayLists $Spotify_PlayList_List $user $token
    $PlayListCount = 0
    $trackCount = 0
    "`"TrackNumber`",`"PlayListTrackNumber`",`"TrackName`",`"ArtistName`",`"PlayListName`",`"PlayListID`",`"TrackExternalURL`",`"TrackSpotifyAPI`",`"TrackAddedAt`"" | Out-File -Encoding Ascii .\$fileName



	$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
	$SqlConnection.ConnectionString = $DatabaseConnectionString
	write-host "Opening SQL Connection..."
	$SqlConnection.Open()
	write-host "SQL Connection Open"

	$SqlCommand = New-Object System.Data.SqlClient.SqlCommand
	$SqlCommand.CommandType = [System.Data.CommandType]'StoredProcedure'
	$SqlCommand.Connection = $SqlConnection
	$SqlCommand.CommandText = "[dbo].[Add_Playlist]"
	$SqlCommand.Parameters.Add("@Playlist_ID", 1) | Out-Null
	$SqlCommand.Parameters["@Playlist_ID"].Direction = [system.Data.ParameterDirection]::Output
	$SqlCommand.Parameters.AddwithValue("@TrackNumber",1) | Out-Null
	$SqlCommand.Parameters.AddwithValue("@PlaylistTrackNumber",1) | Out-Null
	$SqlCommand.Parameters.AddwithValue("@TrackName",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@ArtistName",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@PlayListName",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@PlayListID",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@TrackExternalURL",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@TrackSpotifyAPI",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@TrackAddedDate",'') | Out-Null

    
    foreach ($PlayList in $Spotify_PlayList_List){
        Write-Host "Begin:" (Get-Date).ToString() -ForegroundColor Green
        $PlayListCount += 1
        Write-Host $PlayListCount ":" $PlayList.name ":" $PlayList.id
        #$playListId = "6jo1v0EeQc4flcNW7DZ4ad"
        $trackList = @()
        $trackList =  Get_Full_List_of_Spotify_PlayList_Tracks $PlayList.id $token
        $playListTrackCount = 0
        foreach ($track in $trackList){
            $trackCount += 1
            $playListTrackCount++

			$SqlCommand.Parameters["@TrackNumber"].Value = $trackCount

			$SqlCommand.Parameters["@PlaylistTrackNumber"].Value = $playListTrackCount
			
			$SqlCommand.Parameters["@TrackName"].Value = $track.track.name
			if($track.track.artists.count -eq 1){
				$SqlCommand.Parameters["@ArtistName"].Value = $track.track.artists.name.ToString()
			}
			else{
				$Artists = ""
				foreach ($Artist in $track.track.artists){
					if($Artists -eq ""){
						$Artists = $Artist.name
					}
					else{
						$Artists = $Artists + "," + $Artist.name
					}
				}
				$SqlCommand.Parameters["@ArtistName"].Value = $Artists
				$SqlCommand.Parameters["@PlaylistTrackNumber"].Value = $playListTrackCount
			
			}
			$SqlCommand.Parameters["@PlayListName"].Value = $PlayList.name.ToString()
			$SqlCommand.Parameters["@PlayListID"].Value = $PlayList.id
			
			if($track.track.external_urls.spotify -ne $null){
				$SqlCommand.Parameters["@TrackExternalURL"].Value = $track.track.external_urls.spotify.ToString()
			}
			else{
				$SqlCommand.Parameters["@TrackExternalURL"].Value = ""
			}

			if($track.track.href -ne $null){
				$SqlCommand.Parameters["@TrackSpotifyAPI"].Value = $track.track.href.ToString()

			}
			else{
				$SqlCommand.Parameters["@TrackSpotifyAPI"].Value = ""

			}
			$SqlCommand.Parameters["@TrackAddedDate"].Value = $track.added_at
			
			if($ToDatabase -eq $true){
				$Computer_Result = $SqlCommand.ExecuteNonQuery();
				$Playlist_ID = $SqlCommand.Parameters["@Playlist_ID"].Value;
				write-host "Added Playlist:" $track.track.name "with a track ID of:" $Playlist_ID  ":" $playListTrackCount.ToString()
			}


            #Write-Host $trackCount ":" $track.track.name ":" $track.track.artists.name
            "`"" + $trackCount.ToString() + "`",`"" + $playListTrackCount.ToString() + "`",`"" + $track.track.name + "`",`"" + $track.track.artists.name + "`",`"" + $PlayList.name + "`",`"" + $PlayList.id + "`",`"" + $track.track.external_urls.spotify + "`",`"" + $track.track.href + "`",`"" + $track.added_at  + "`""| Out-File -append .\$fileName
        }
        Write-Host "End:" (Get-Date).ToString()
    }    
}
DumpAppTracks