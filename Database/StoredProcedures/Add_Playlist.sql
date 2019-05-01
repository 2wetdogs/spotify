CREATE PROCEDURE [dbo].[Add_Playlist]
	@Playlist_ID INT OUTPUT,
	@Playlist_Number INT,
	@TrackNumber INT,
	@PlaylistTrackNumber INT,
	@TrackName VARCHAR(MAX),
	@ArtistName VARCHAR(MAX),
	@PlayListName VARCHAR(MAX),
	@PlayListID VARCHAR(MAX), 
	@AddedBy VARCHAR(MAX), 
	@AddedBy_DisplayName VARCHAR(MAX), 
	@TrackExternalURL VARCHAR(MAX),
	@TrackSpotifyAPI VARCHAR(MAX),
	@TrackAddedDate VARCHAR(MAX),
	@RUN_ID INT,
	@Added_To_Table_Date_Time VARCHAR(MAX)
AS
SET NOCOUNT ON;

INSERT INTO [dbo].[Playlists]
    ([Playlist_Number],
	[TrackNumber], 
	[PlaylistTrackNumber],
    [TrackName], 
    [ArtistName], 
    [PlayListName],
	[PlayListID], 
	[AddedBy], 
	[AddedBy_DisplayName], 
    [TrackExternalURL], 
    [TrackSpotifyAPI],
    [TrackAddedDate],
	[RUN_ID],
	[Added_To_Table_Date_Time])
VALUES
	(@Playlist_Number,
	@TrackNumber,
	@PlaylistTrackNumber,
	@TrackName,
	@ArtistName,
	@PlayListName, 
	@PlayListID, 
	@AddedBy, 
	@AddedBy_DisplayName, 
	@TrackExternalURL,
	@TrackSpotifyAPI,
	@TrackAddedDate,
	@RUN_ID,
	@Added_To_Table_Date_Time);

	SELECT @Playlist_ID = SCOPE_IDENTITY();
GO