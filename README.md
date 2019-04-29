# Spotify Project
There are two projects in this repo.  One is the database project used to dump Spotify data to a SQL database.  The second is a powershell project that contains the powershell scripts used to pull data from sptofiy and either dump it to a local file or a SQL database.

PowerShell Project:
The PowerShell project contains the follwoing powershell scripts:
 - Spotify_Dump_AllPlayLists.ps1 - This script will read all playlists in a users library and dump the play lists as well as the tracks in the play list to a CSV file.
	Usage:
	Spotify_Dump_AllPlayLists.ps1 <spotify user name> <spotify bearer token> <OPTIONAL file name> <ToDatabsae True/False> <DatabaseConnectionString>
	If you run Spotify_Dump_AllPlayLists.ps1 with no parameters it will re-direct you to the spotify developer URL to get a token.

 - Spotify_Dump_MySavedTracks.ps1 - This script will dump all tracks in your saved songs to a local play list.
    	Usage:
	Spotify_Dump_MySavedTracks.ps1 <spotify bearer token> <OPTIONAL file name>
	If you run Spotify_Dump_AllPlayLists.ps1 with no parameters it will re-direct you to the spotify developer URL to get a token.

Database Project
The database project contains the table defintion and stored procedure to add items to the table.  The database can be deployed using a DACPAC file.  See the document in the database project named HowToCreateTheSQLDatabase.docx.