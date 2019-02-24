param(
    [string]$user,    
    [string]$token,
    [string]$fileName = "AllTracks.csv"

)

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
    $masterTrackList = @()
    $trackCount = 0
    "`"TrackNumber`",`"PlayListTrackNumber`",`"TrackName`",`"ArtistName`",`"PlayListName`",`"PlayListID`",`"TrackExternalURL`",`"TrackSpotifyAPI`"" | Out-File -Encoding Ascii .\$fileName
    
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
            $playListTrackCount += 1
            #Write-Host $trackCount ":" $track.track.name ":" $track.track.artists.name
            "`"" + $trackCount.ToString() + "`",`"" + $playListTrackCount.ToString() + "`",`"" + $track.track.name + "`",`"" + $track.track.artists.name + "`",`"" + $PlayList.name + "`",`"" + $PlayList.id + "`",`"" + $track.track.external_urls.spotify + "`",`"" + $track.track.href + "`""| Out-File -append .\$fileName
        }
        Write-Host "End:" (Get-Date).ToString()
    }    
}
DumpAppTracks