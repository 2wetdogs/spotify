
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
$Run_ID = (get-date).ToUniversalTime().ToString("yyyyMMddHHmmss")

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
    $Spotify_PlayList_List = @()
    $Spotify_PlayList_List =  Get_Full_List_of_Spotify_PlayLists $Spotify_PlayList_List $user $token
    $PlayListCount = 0
    $trackCount = 0
    "`"TrackNumber`",`"PlayListTrackNumber`",`"TrackName`",`"Track_id`",`"ArtistName`",`"PlayListName`",`"PlayListID`",`"AddedBy_ID`",`"TrackExternalURL`",`"TrackSpotifyAPI`",`"TrackAddedAt`"" | Out-File -Encoding Ascii .\$fileName



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
	$SqlConnection.ConnectionString = "Server=localhost\SQLEXPRESS;Database=Spotify;Integrated Security=True"
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
	$SqlConnection.ConnectionString = "Server=localhost\SQLEXPRESS;Database=Spotify;Integrated Security=True"
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

DumpAppTracks
Get_Spotify_Users

if($SendToDatabase-eq $true){
	Get_Track_Audio_Features
}