param(
    [string]$token,
    [string]$fileName = "Spotify-MySavedTracks.csv"
)

function Dump_MySpotifyTracks([string]$token,[int]$trackCount=0,[int]$trackNumber = 0,[int]$offset = 0,[int]$limit = 50){
    $url = "https://api.spotify.com/v1/me/tracks?limit=$limit&offset=$offset"
    write-host $url
    $headers = @{"Authorization" = "Bearer " + $token}
    Try{
        $results = Invoke-RestMethod -Uri $url -Headers $headers
    }
    Catch{
        write-host $_
        Start-Process chrome.exe https://developer.spotify.com/console/get-current-user-saved-tracks/
        exit
    }
    $trackCount = $results.total
    foreach ($Track in $results.items){
        $trackNumber += 1
        "`"" + $trackNumber.ToString() + "`",`"" + $Track.track.name + "`",`"" + $Track.track.name + "`",`"" + $Track.track.external_urls.spotify + "`",`"" + $Track.track.href  + "`",`"" + $Track.added_at + "`""| Out-File -append .\$fileName
    }

    if (($offset + $limit) -lt $trackCount){
        if(($trackCount - ($offset + $limit)) -lt 50){
            $limit = ($trackCount - ($offset + $limit))
        } 
        $offset = $offset + 50
        Dump_MySpotifyTracks $token $trackCount $trackNumber $offset $limit
    }
}
"`"TrackNumber`",`"TrackName`",`"ArtistName`",`"TrackExternalURL`",`"TrackSpotifyAPI`",`"AddedDate`"" | Out-File -Encoding Ascii .\$fileName

Dump_MySpotifyTracks $token