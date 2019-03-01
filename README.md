# spotify
There are two files in this repo.  Their usage is documented below.

Spotify_Dump_AllPlayLists.ps1 - This script will read all playlists in a users library and dump the play lists as well as the tracks in the play list to a CSV file.
    Usage:
    Spotify_Dump_AllPlayLists.ps1 <spotify user name> <spotify bearer token> <OPTIONAL file name>
    If you run Spotify_Dump_AllPlayLists.ps1 with no parameters it will re-direct you to the spotify developer URL to get a token.

Spotify_Dump_MySavedTracks.ps1 - This script will dump all tracks in your saved songs to a local play list.
    Usage:
    Spotify_Dump_MySavedTracks.ps1 <spotify bearer token> <OPTIONAL file name>
    If you run Spotify_Dump_AllPlayLists.ps1 with no parameters it will re-direct you to the spotify developer URL to get a token.
