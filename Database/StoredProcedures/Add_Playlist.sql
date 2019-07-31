CREATE PROCEDURE [dbo].[Add_Playlist]
	@Playlist_ID INT OUTPUT,
	@PlayList_Number INT,
	@TrackNumber INT,
	@PlaylistTrackNumber INT,
	@TrackName VARCHAR(MAX),
	@track_id VARCHAR(MAX),	
	@ArtistName VARCHAR(MAX),
	@PlayListName VARCHAR(MAX),
	@PlayListID VARCHAR(MAX), 
	@AddedBy_ID VARCHAR(MAX), 
	@TrackExternalURL VARCHAR(MAX),
	@TrackSpotifyAPI VARCHAR(MAX),
	@TrackAddedDate VARCHAR(MAX),
	@RUN_ID VARCHAR(150),
	@Added_To_Table_Date_Time VARCHAR(MAX)
AS
SET NOCOUNT ON;

INSERT INTO [dbo].[Playlists]
    ([PlayList_Number],
	[TrackNumber], 
	[PlaylistTrackNumber],
    [TrackName],
	[track_id],
    [ArtistName], 
    [PlayListName],
	[PlayListID], 
	[AddedBy_ID], 
	[TrackExternalURL], 
    [TrackSpotifyAPI],
    [TrackAddedDate],
	[RUN_ID],
	[Added_To_Table_Date_Time])
VALUES
	(@PlayList_Number,
	@TrackNumber,
	@PlaylistTrackNumber,
	@TrackName,
	@track_id,
	@ArtistName,
	@PlayListName, 
	@PlayListID, 
	@AddedBy_ID, 
	@TrackExternalURL,
	@TrackSpotifyAPI,
	@TrackAddedDate,
	@RUN_ID,
	@Added_To_Table_Date_Time);

	SELECT @Playlist_ID = SCOPE_IDENTITY();
GO