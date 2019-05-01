
#user: Spotify UserName
#token: Spotify authentication token
#filename: The name of the file you want to dump the playlists to.
#SendToDatabase: Tells the script to send a copy to a database as specificed in the DatabaseConnectionString parameter
#DatabaseConnectionString: connection string to connect to the sql database.   Server=<servername\instance>;<Database=<databasename>;Integrated Secuirty=True

param(
    [string]$user,    
    [string]$token,
    [string]$fileName = "AllTracks.csv",
	[bool]$SendToDatabase= $false,
	[string]$DatabaseConnectionString = "Server=localhost\SQLEXPRESS;Database=Spotify;Integrated Security=True"
)

#Create an unique id based on time for each instance of the script
$RunID = (get-date).ToUniversalTime().ToString("yyyyMMddHHmmss")

#Recursive Function - Get List of play lists 50 at a time by default. (This is a spotify max limit at this time too), Recursion is used to loop trough x number of playlists if x is greater than 50 remaining. 
function Get_Full_List_of_Spotify_PlayLists([array]$Spotify_Playlists,[string]$user,[string]$token,[int]$playListCount=0,[int]$offset = 0,[int]$limit = 50){
    
	#Spotify URI for get playlists.
	$url = "https://api.spotify.com/v1/users/$user/playlists?limit=$limit&offset=$offset"
    #Creating header for call.
	$headers = @{"Authorization" = "Bearer " + $token}

    Try{
        $results = Invoke-RestMethod -Uri $url -Headers $headers
    }
    Catch{
        write-host $_
        #Token is incorrect or expired.  This opens a chrome browser to the URL where you can get a token.
		Start-Process chrome.exe https://developer.spotify.com/console/get-playlists/
        exit
    }

	#Gets Count of play lists
    $playListCount = $results.total
   
	#Loops through the results of the API call and adds it to an array.
    foreach ($PlayList in $results.items){
        $Spotify_Playlists += $PlayList
    }

	#Checking to see if there will be more than 50 left to process after this batch.  If there is then call this funciton again with new offset and limit parameters.
    if (($offset + $limit) -lt $playListCount){
        #Checking to see if there are less than 50 left, and if so set limit to that number
		if(($playListCount - ($offset + $limit)) -lt 50){
            $limit = ($playListCount - ($offset + $limit))
        } 
		#Adds 50 to the offset
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
    "`"TrackNumber`",`"PlayListTrackNumber`",`"TrackName`",`"ArtistName`",`"PlayListName`",`"PlayListID`",`"AddedBy`",`"AddedBy_DisplayName`",`"TrackExternalURL`",`"TrackSpotifyAPI`",`"TrackAddedAt`"" | Out-File -Encoding Ascii .\$fileName



	$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
	$SqlConnection.ConnectionString = $DatabaseConnectionString
	write-host "Opening SQL Connection..."
	$SqlConnection.Open()
	write-host "SQL Connection Open"

	#Creating SQL Connections
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
    $SqlCommand.Parameters.AddwithValue("@AddedBy",'') | Out-Null
    $SqlCommand.Parameters.AddwithValue("@AddedBy_DisplayName",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@TrackExternalURL",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@TrackSpotifyAPI",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@TrackAddedDate",'') | Out-Null

    
	#Loop through the playlists and add them the file or database.
    foreach ($PlayList in $Spotify_PlayList_List){
        Write-Host "Begin:" (Get-Date).ToString() -ForegroundColor Green
        $PlayListCount += 1
        Write-Host $PlayListCount ":" $PlayList.name ":" $PlayList.id
        #$playListId = "6jo1v0EeQc4flcNW7DZ4ad"
        $trackList = @()
        $trackList =  Get_Full_List_of_Spotify_PlayList_Tracks $PlayList.id $token
        $playListTrackCount = 0

		#Looping through tracks in playlists.
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
			$SqlCommand.Parameters["@PlayList_Number"].Value = 1
			
			$SqlCommand.Parameters["@PlayListID"].Value = $PlayList.id
            $SqlCommand.Parameters["@AddedBy"].Value = $track.added_by.id
            $SqlCommand.Parameters["@AddedBy_DisplayName"].Value = "FF"
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
			
			$SqlCommand.Parameters["@RUN_ID"].Value = 1
			$SqlCommand.Parameters["@Added_To_Table_Date_Time"].Value = Get-Date
	
			

			#If send to database is true then write to database.
			if($SendToDatabase-eq $true){
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