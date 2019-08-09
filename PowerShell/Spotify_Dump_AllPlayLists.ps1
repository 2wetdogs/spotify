#user: Spotify UserName
#token: Spotify authentication token
#filename: The name of the file you want to dump the playlists to.
#SendToDatabase: Tells the script to send a copy to a database as specificed in the DatabaseConnectionString parameter
#DatabaseConnectionString: connection string to connect to the sql database.   Server=<servername\instance>;<Database=<databasename>;Integrated Secuirty=True

param(
    [string]$user,    
    [string]$token,
    [string]$fileName = "AllTracks.csv",
	[bool]$SendToDatabase = $false,
	[string]$DatabaseConnectionString = "Server=localhost\SQLEXPRESS;Database=Spotify;Integrated Security=True"
)

#Create an unique id based on time for each instance of the script
$Run_ID = (get-date).ToUniversalTime().ToString("yyyyMMddHHmmss")


function Add_Update_Track{
	param(
		[System.Data.SqlClient.SqlConnection]$SqlConnection,
		[string]$Track_id,
		[string]$Artist_id,
		[string]$Album_id,
		[int]$disc_number,
		[int]$duration_ms,
		[string]$external_urls,
		[string]$href,
		[bool]$is_local,
		[string]$name,
		[int]$popularity,
		[int]$track_number,
		[string]$uri
	)
	$SqlCommand = New-Object System.Data.SqlClient.SqlCommand
	$SqlCommand.CommandType = [System.Data.CommandType]'StoredProcedure'
	$SqlCommand.Connection = $SqlConnection
	$SqlCommand.CommandText = "[dbo].[Add_Update_Track]"
	$SqlCommand.Parameters.AddwithValue("@Track_id",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@Artist_id",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@Album_id",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@disc_number",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@duration_ms",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@external_urls",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@href",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@is_local",0) | Out-Null
	$SqlCommand.Parameters.AddwithValue("@name",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@popularity",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@track_number",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@uri",'') | Out-Null

	$SqlCommand.Parameters["@Track_id"].Value = $Track_id
	$SqlCommand.Parameters["@Artist_id"].Value = $Artist_id
	$SqlCommand.Parameters["@Album_id"].Value = $Album_id
	$SqlCommand.Parameters["@disc_number"].Value = $disc_number
	$SqlCommand.Parameters["@duration_ms"].Value = $duration_ms
	$SqlCommand.Parameters["@external_urls"].Value = $external_urls
	$SqlCommand.Parameters["@href"].Value = $href
	$SqlCommand.Parameters["@is_local"].Value = $is_local
	$SqlCommand.Parameters["@name"].Value = $name
	$SqlCommand.Parameters["@popularity"].Value = $popularity
	$SqlCommand.Parameters["@track_number"].Value = $track_number
	$SqlCommand.Parameters["@uri"].Value = $uri

	if($SendToDatabase-eq $true){
		$Computer_Result = $SqlCommand.ExecuteNonQuery();
	}
}

function Add_Update_Album(){
	param(
		[System.Data.SqlClient.SqlConnection]$SqlConnection,
		[string]$Album_id,
		[string]$album_type,
		[string]$Artist_id,
		[string]$external_urls,
		[string]$href,
		[string]$name,
		[string]$release_date,
		[string]$total_tracks,
		[string]$uri
	)
	$SqlCommand = New-Object System.Data.SqlClient.SqlCommand
	$SqlCommand.CommandType = [System.Data.CommandType]'StoredProcedure'
	$SqlCommand.Connection = $SqlConnection
	$SqlCommand.CommandText = "[dbo].[Add_Update_Album]"
	$SqlCommand.Parameters.AddwithValue("@Album_id",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@album_type",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@Artist_id",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@external_urls",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@href",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@name",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@release_date",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@total_tracks",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@uri",'') | Out-Null

	$SqlCommand.Parameters["@Album_id"].Value = $Album_id
	$SqlCommand.Parameters["@album_type"].Value = $album_type
	$SqlCommand.Parameters["@Artist_id"].Value = $Artist_id
	$SqlCommand.Parameters["@external_urls"].Value = $external_urls
	$SqlCommand.Parameters["@href"].Value = $href
	$SqlCommand.Parameters["@name"].Value = $name
	$SqlCommand.Parameters["@release_date"].Value = $release_date
	$SqlCommand.Parameters["@total_tracks"].Value = $total_tracks
	$SqlCommand.Parameters["@uri"].Value = $uri

	if($SendToDatabase-eq $true){
		$Computer_Result = $SqlCommand.ExecuteNonQuery();
	}
}

function Add_Update_Artist(){
	param(
		[System.Data.SqlClient.SqlConnection]$SqlConnection,
		[string]$Artist_id,
		[string]$external_urls,
		[string]$href,
		[string]$name,
		[string]$uri
	)
	$SqlCommand = New-Object System.Data.SqlClient.SqlCommand
	$SqlCommand.CommandType = [System.Data.CommandType]'StoredProcedure'
	$SqlCommand.Connection = $SqlConnection
	$SqlCommand.CommandText = "[dbo].[Add_Update_Artist]"
	$SqlCommand.Parameters.AddwithValue("@Artist_id",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@external_urls",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@href",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@name",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@uri",'') | Out-Null

	$SqlCommand.Parameters["@Artist_id"].Value = $Artist_id
	$SqlCommand.Parameters["@external_urls"].Value = $external_urls
	$SqlCommand.Parameters["@href"].Value = $href
	$SqlCommand.Parameters["@name"].Value = $name
	$SqlCommand.Parameters["@uri"].Value = $uri

	if($SendToDatabase-eq $true){
		$Computer_Result = $SqlCommand.ExecuteNonQuery();
	}
}

function Add_Playlist_Track(){
	param(
		[System.Data.SqlClient.SqlConnection]$SqlConnection,
		[string]$PlayList_id,
		[string]$track_id
	)
	$SqlCommand = New-Object System.Data.SqlClient.SqlCommand
	$SqlCommand.CommandType = [System.Data.CommandType]'StoredProcedure'
	$SqlCommand.Connection = $SqlConnection
	$SqlCommand.CommandText = "[dbo].[Add_Playlist_Track]"
	$SqlCommand.Parameters.AddwithValue("@PlayList_id",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@track_id",'') | Out-Null

	$SqlCommand.Parameters["@PlayList_id"].Value = $PlayList_id
	$SqlCommand.Parameters["@track_id"].Value = $track_id

	if($SendToDatabase-eq $true){
		$Computer_Result = $SqlCommand.ExecuteNonQuery();
	}
}

function Add_Update_Playlist(){
	param(
		[System.Data.SqlClient.SqlConnection]$SqlConnection,
		[string]$Playlist_id,
		[bool]$collaborative,
		[string]$description,
		[string]$external_urls,
		[string]$href,
		[string]$name,
		[string]$uri,
		[string]$owner_id,
		[string]$public
	)
	$SqlCommand = New-Object System.Data.SqlClient.SqlCommand
	$SqlCommand.CommandType = [System.Data.CommandType]'StoredProcedure'
	$SqlCommand.Connection = $SqlConnection
	$SqlCommand.CommandText = "[dbo].[Add_Update_Playlist]"
	$SqlCommand.Parameters.AddwithValue("@Playlist_id",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@collaborative",0) | Out-Null
	$SqlCommand.Parameters.AddwithValue("@description",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@external_urls",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@href",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@name",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@uri",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@owner_id",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@public",0) | Out-Null


	$SqlCommand.Parameters["@Playlist_id"].Value = $Playlist_id
	$SqlCommand.Parameters["@collaborative"].Value = 0
	$SqlCommand.Parameters["@external_urls"].Value = $description
	$SqlCommand.Parameters["@external_urls"].Value = $external_urls
	$SqlCommand.Parameters["@href"].Value = $href
	$SqlCommand.Parameters["@name"].Value = $name
	$SqlCommand.Parameters["@uri"].Value = $uri
	$SqlCommand.Parameters["@owner_id"].Value = $owner_id
	$SqlCommand.Parameters["@public"].Value = 0



	if($SendToDatabase-eq $true){
		$Computer_Result = $SqlCommand.ExecuteNonQuery();
	}
}

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
        write-host "Cought Error:" $_
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
	param(
		[System.Data.SqlClient.SqlConnection]$SqlConnection
	)
    $Spotify_PlayList_List = @()
    $Spotify_PlayList_List =  Get_Full_List_of_Spotify_PlayLists $Spotify_PlayList_List $user $token
    $PlayListCount = 0
    $trackCount = 0
    "`"TrackNumber`",`"PlayListTrackNumber`",`"TrackName`",`"Track_id`",`"ArtistName`",`"PlayListName`",`"PlayListID`",`"AddedBy_ID`",`"TrackExternalURL`",`"TrackSpotifyAPI`",`"TrackAddedAt`"" | Out-File -Encoding Ascii .\$fileName

	#Creating SQL Connections
	$SqlCommand = New-Object System.Data.SqlClient.SqlCommand
	$SqlCommand.CommandType = [System.Data.CommandType]'StoredProcedure'
	$SqlCommand.Connection = $SqlConnection
	$SqlCommand.CommandText = "[dbo].[Add_Playlist]"
	$SqlCommand.Parameters.Add("@Playlist_ID", 1) | Out-Null
	$SqlCommand.Parameters["@Playlist_ID"].Direction = [system.Data.ParameterDirection]::Output
	$SqlCommand.Parameters.AddwithValue("@PlayList_Number",1) | Out-Null
	$SqlCommand.Parameters.AddwithValue("@TrackNumber",1) | Out-Null
	$SqlCommand.Parameters.AddwithValue("@PlaylistTrackNumber",1) | Out-Null
	$SqlCommand.Parameters.AddwithValue("@TrackName",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@Track_id",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@ArtistName",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@PlayListName",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@PlayListID",'') | Out-Null
    $SqlCommand.Parameters.AddwithValue("@AddedBy_ID",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@TrackExternalURL",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@TrackSpotifyAPI",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@TrackAddedDate",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@RUN_ID",1) | Out-Null
	$SqlCommand.Parameters.AddwithValue("@Added_To_Table_Date_Time",'') | Out-Null

    $PlayListCount = 0

	#Loop through the playlists and add them the file or database.
    foreach ($PlayList in $Spotify_PlayList_List){

        Write-Host "Begin:" (Get-Date).ToString() -ForegroundColor Green
        $PlayListCount += 1
        Write-Host $PlayListCount ":" $PlayList.name ":" $PlayList.id
    	$SqlCommand.Parameters["@Playlist_Number"].Value = $PlayListCount
        $trackList = @()
        $trackList =  Get_Full_List_of_Spotify_PlayList_Tracks $PlayList.id $token
        $playListTrackCount = 0

		$Add_Update_PlayList_Params = @{
			SqlConnection = $SqlConnection
			Playlist_id = $PlayList.id
			collaborative = 0
			description = $PlayList.description
			external_urls = $PlayList.external_urls.spotify
			href = $PlayList.href
			name = $PlayList.name
			uri = $PlayList.uri
			owner_id = $PlayList.owner.id
			public = 0
	}
	Add_Update_PlayList @Add_Update_PlayList_Params

	
		#Looping through tracks in playlists.
        foreach ($track in $trackList){
			$trackCount += 1
            $playListTrackCount++
			$SqlCommand.Parameters["@TrackNumber"].Value = $trackCount
			$SqlCommand.Parameters["@PlaylistTrackNumber"].Value = $playListTrackCount
			$SqlCommand.Parameters["@TrackName"].Value = $track.track.name
			if($track.track.id -ne $null){
				$SqlCommand.Parameters["@Track_id"].Value = $track.track.id
			}	
			if($track.track.artists.count -eq 1){
				$SqlCommand.Parameters["@ArtistName"].Value = $track.track.artists.name.ToString()
				$Artist_Params = @{
					SqlConnection = $SqlConnection
					Artist_id = $track.track.artists.id
					extneral_urls = $track.track.artists.external_urls
					href = $track.track.artists.href
					name = $track.track.artists.name
					uri = $track.track.artists.uri
				}
				Add_Update_Artist @Artist_Params

				$Album_Params = @{
					SqlConnection = $SqlConnection
					Album_id = $track.track.album.id
					album_type = $track.track.album.album_type
					Artist_id = $track.track.artists.id
					external_urls = $track.track.album.external_urls
					href = $track.track.album.href
					name = $track.track.album.name
					release_date = $track.track.album.release_date
					total_tracks = $track.track.album.total_tracks
					uri = $track.track.album.uri
				}
				Add_Update_Album @Album_Params

				$Track_Params = @{
					SqlConnection = $SqlConnection
					Track_id = $track.track.id
					Artist_id = $track.track.artist.id
					Album_id = $track.track.album.id
					disc_number = $track.track.disc_number
					duration_ms = $track.track.duration_ms
					external_urls = $track.track.external_urls
					href = $track.track.href
					name = $track.track.name
					popularity = $track.track.popularity
					track_number = $track.track.track_number
					uri = $track.track.uri
				}
				Add_Update_Track @Track_Params

				$PlayList_Track_Params = @{
					SqlConnection = $SqlConnection
					Track_id = $track.track.id
					PlayList_id = $PlayList.id
				}
				Add_Playlist_Track @PlayList_Track_Params
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
			$SqlCommand.Parameters["@PlayListName"].Value = $PlayList.name
			
			$SqlCommand.Parameters["@PlayListID"].Value = $PlayList.id
            $SqlCommand.Parameters["@AddedBy_ID"].Value = $track.added_by.id
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
			
			$SqlCommand.Parameters["@RUN_ID"].Value = $Run_ID.ToString()
			$SqlCommand.Parameters["@Added_To_Table_Date_Time"].Value = (get-date).ToUniversalTime().ToString("MM/dd/yyyy dd:HH:mm:ss")
	
			

			#If send to database is true then write to database.
			if($SendToDatabase-eq $true){
				$Computer_Result = $SqlCommand.ExecuteNonQuery();
				$Playlist_ID = $SqlCommand.Parameters["@Playlist_ID"].Value;
			}
			write-host "Added Track to Playlist" $PlayList.name":" $track.track.name "with a track ID of:" $Playlist_ID  ":" $playListTrackCount.ToString()
            "`"" + $trackCount.ToString() + "`",`"" + $playListTrackCount.ToString() + "`",`"" + $track.track.name + "`",`"" + $track.track.artists.name + "`",`"" + $PlayList.name + "`",`"" + $PlayList.id + "`",`"" + $track.track.external_urls.spotify + "`",`"" + $track.track.href + "`",`"" + $track.added_at  + "`""| Out-File -append .\$fileName
        }
        Write-Host "End:" (Get-Date).ToString()
    }    
}

function Get_Spotify_User_Profile([string]$user,[string]$token,[string]$userid){
	#Spotify URI for get playlists.
	$url = "https://api.spotify.com/v1/users/$userid"
    #Creating header for call.
	$headers = @{"Authorization" = "Bearer " + $token}

    Try{
        $results = Invoke-RestMethod -Uri $url -Headers $headers
		return $results
    }
    Catch{
        write-host "Cought Error:" $_
        #Token is incorrect or expired.  This opens a chrome browser to the URL where you can get a token.
		Start-Process chrome.exe https://developer.spotify.com/console/get-playlists/
        exit
    }
}

function Get_Spotify_Users{
	$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
	$SqlConnection.ConnectionString = $DatabaseConnectionString
	$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
	$SqlCmd.CommandText = "Get_Users_List"
	$SqlCmd.Connection = $SqlConnection
	$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
	$SqlAdapter.SelectCommand = $SqlCmd
	$DataSet = New-Object System.Data.DataSet
	$SqlAdapter.Fill($DataSet)
	$SqlConnection.Close()

	$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
	$SqlConnection.ConnectionString = $DatabaseConnectionString

	if($SendToDatabase-eq $true){
		write-host "Opening SQL Connection..."
		$SqlConnection.Open()
		write-host "SQL Connection Open"
	}

	#Creating SQL Connections
	$SqlCommand = New-Object System.Data.SqlClient.SqlCommand
	$SqlCommand.CommandType = [System.Data.CommandType]'StoredProcedure'
	$SqlCommand.Connection = $SqlConnection
	$SqlCommand.CommandText = "[dbo].[Add_Spotify_User]"
	$SqlCommand.Parameters.AddwithValue("@Spotify_User_ID",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@DisplayName",'') | Out-Null
			
	foreach ($Row in  $DataSet.Tables[0].AddedBy_ID){
		if($Row -ne ""){
			$User = Get_Spotify_User_Profile $user $token $Row
			$SqlCommand.Parameters["@Spotify_User_ID"].Value = $User.id
			$SqlCommand.Parameters["@DisplayName"].Value = $User.display_name
			if($SendToDatabase-eq $true){
				$Computer_Result = $SqlCommand.ExecuteNonQuery();
			}
		}	
	}
}

function Get_Spotify_Audio_Features([string]$user,[string]$token,[string]$track_ids){
	#Spotify URI for get playlists.
	$url = "https://api.spotify.com/v1/audio-features?ids=$track_ids"
    #Creating header for call.
	$headers = @{"Authorization" = "Bearer " + $token}

    Try{
        $results = Invoke-RestMethod -Uri $url -Headers $headers
		return $results
    }
    Catch{
        write-host "Cought Error:" $_
        #Token is incorrect or expired.  This opens a chrome browser to the URL where you can get a token.
		Start-Process chrome.exe https://developer.spotify.com/console/get-playlists/
        exit
    }
}

function Get_Next_X_From_Dataset {
	Param(
		[System.Data.DataSet]$DataSet,
		[System.Data.SqlClient.SqlCommand]$SqlCommand,
		[int]$return_row_count = 100,
		[int]$table_index = 0,
		[int]$row_index = 0,
		[int]$start_index = 0
	)
	$ResultsCSV = ""
	$RowNumber = 0
	foreach ($Row in $DataSet.Tables[$table_index].Rows){
		if($RowNumber -ge $start_index -and $RowNumber -lt $start_index + 100){
			if($Row[$row_index] -ne [System.DBNull]::Value){
				if($ResultsCSV -eq ""){
					$ResultsCSV = $Row[$row_index]
				}
				else{
					$ResultsCSV = $ResultsCSV + "," + $Row[$row_index]
				}
			}			
		}
		$RowNumber ++
	}
	$REST_Results = $null
	$REST_Results = (Get_Spotify_Audio_Features -user $user -token $token -track_ids $ResultsCSV)

	foreach($TAF in $REST_Results.audio_features){
		Write-Host "Writing Audo_Features for Track ID:"  -NoNewline 
		Write-host $TAF.id -ForegroundColor Green
		$SqlCommand.Parameters["@track_id"].Value = $TAF.id
		$SqlCommand.Parameters["@duration_ms"].Value = $TAF.duration_ms
		$SqlCommand.Parameters["@time_signature"].Value = $TAF.time_signature
		$SqlCommand.Parameters["@danceability"].Value = $TAF.danceability
		$SqlCommand.Parameters["@energy"].Value = $TAF.energy
		$SqlCommand.Parameters["@key"].Value = $TAF.key
		$SqlCommand.Parameters["@loudness"].Value = $TAF.loudness
		$SqlCommand.Parameters["@mode"].Value = $TAF.mode
		$SqlCommand.Parameters["@speechiness"].Value = $TAF.speechiness
		$SqlCommand.Parameters["@acousticness"].Value = $TAF.acousticness
		$SqlCommand.Parameters["@instrumentalness"].Value = $TAF.instrumentalness
		$SqlCommand.Parameters["@liveness"].Value = $TAF.liveness
		$SqlCommand.Parameters["@valence"].Value = $TAF.valence
		$SqlCommand.Parameters["@tempo"].Value = $TAF.tempo
		$SqlCommand.Parameters["@RUN_ID"].Value = $Run_ID.ToString()
		$SqlCommand.Parameters["@Added_To_Table_Date_Time"].Value = (get-date).ToUniversalTime().ToString("MM/dd/yyyy dd:HH:mm:ss")
	
		if($SendToDatabase-eq $true){
			$Computer_Result = $SqlCommand.ExecuteNonQuery();
		}
	}

	if($start_index -lt ($DataSet.Tables[$table_index].Rows.Count - $return_row_count)){
		Get_Next_X_From_Dataset $DataSet -start_index ($start_index + $return_row_count) -SqlCommand $SqlCommand
	}
	else{
		$return_row_count = $DataSet.Tables[$table_index].Rows.Count - $start_index
		write-host "Wrote audio features for" $DataSet.Tables[$table_index].Rows.Count "tracks to the database." -ForegroundColor Green
	}
}

function Get_Track_Audio_Features{
	$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
	$SqlConnection.ConnectionString = $DatabaseConnectionString
	$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
	$SqlCmd.CommandText = "Get_Tracks"
	$SqlCmd.Connection = $SqlConnection
	$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
	$SqlAdapter.SelectCommand = $SqlCmd
	$DataSet = New-Object System.Data.DataSet
	$SqlAdapter.Fill($DataSet)
	$SqlConnection.Close()

	$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
	$SqlConnection.ConnectionString = $DatabaseConnectionString
	write-host "Opening SQL Connection..."
	$SqlConnection.Open()
	write-host "SQL Connection Open"

	#Creating SQL Connections
	$SqlCommand = New-Object System.Data.SqlClient.SqlCommand
	$SqlCommand.CommandType = [System.Data.CommandType]'StoredProcedure'
	$SqlCommand.Connection = $SqlConnection
	$SqlCommand.CommandText = "[dbo].[Add_Audio_Feature]"
	$SqlCommand.Parameters.AddwithValue("@Track_id",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@duration_ms",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@time_signature",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@danceability",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@energy",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@key",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@loudness",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@mode",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@speechiness",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@acousticness",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@instrumentalness",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@liveness",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@valence",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@tempo",'') | Out-Null
	$SqlCommand.Parameters.AddwithValue("@RUN_ID",1) | Out-Null
	$SqlCommand.Parameters.AddwithValue("@Added_To_Table_Date_Time",'') | Out-Null

	Get_Next_X_From_Dataset -DataSet $DataSet -SQLCommand $SqlCommand
}



####################################################
####                  MAIN						####
####################################################

#CONSTANTS
if($SendToDatabase){
	$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
	$SqlConnection.ConnectionString = $DatabaseConnectionString
	write-host "Opening SQL Connection..."
	$SqlConnection.Open()
	write-host "SQL Connection Open"
}
else{

}



DumpAppTracks -SqlConnection $SqlConnection
Get_Spotify_Users
if($SendToDatabase-eq $true){
	Get_Track_Audio_Features
}
