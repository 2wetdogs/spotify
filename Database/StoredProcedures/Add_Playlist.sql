CREATE PROCEDURE [dbo].[Add_Playlist]
	@Playlist_ID INT OUTPUT,
	@TrackNumber INT,
	@PlaylistTrackNumber INT,
	@TrackName VARCHAR(MAX),
	@ArtistName VARCHAR(MAX),
	@PlayListName VARCHAR(MAX),
	@PlayListID VARCHAR(MAX), 
	@TrackExternalURL VARCHAR(MAX),
	@TrackSpotifyAPI VARCHAR(MAX),
	@TrackAddedDate VARCHAR(MAX)
AS
SET NOCOUNT ON;

INSERT INTO [dbo].[Playlists]
    ([TrackNumber], 
	[PlaylistTrackNumber],
    [TrackName], 
    [ArtistName], 
    [PlayListName],
	[PlayListID], 
    [TrackExternalURL], 
    [TrackSpotifyAPI],
    [TrackAddedDate])
VALUES
	(@TrackNumber,
	@PlaylistTrackNumber,
	@TrackName,
	@ArtistName,
	@PlayListName, 
	@PlayListID, 
	@TrackExternalURL,
	@TrackSpotifyAPI,
	@TrackAddedDate);

	SELECT @Playlist_ID = SCOPE_IDENTITY();
GO