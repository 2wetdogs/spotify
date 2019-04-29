CREATE TABLE [dbo].[Playlists]
(
[Playlist_ID] INT IDENTITY(10000,1) PRIMARY KEY, 
    [TrackNumber] INT NOT NULL, 
	[PlaylistTrackNumber] INT NOT NULL, 
    [TrackName] VARCHAR(MAX) NULL, 
    [ArtistName] VARCHAR(MAX) NULL, 
    [PlayListName] VARCHAR(MAX) NULL,   
	[PlayListID] VARCHAR(MAX) NULL, 
    [TrackExternalURL] VARCHAR(MAX) NULL, 
    [TrackSpotifyAPI] VARCHAR(MAX) NULL, 
    [TrackAddedDate] VARCHAR(MAX) NULL,


)
