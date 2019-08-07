CREATE PROCEDURE [dbo].[Add_Playlist_Track]
(
    @PlayList_id VARCHAR(50),
	@track_id VARCHAR(50)
)
AS

IF NOT EXISTS (SELECT * FROM dbo.PlayList_Tracks 
		   WHERE 
				PlayList_id = @PlayList_id AND
				@track_id = @track_id
				)
    BEGIN
        INSERT INTO dbo.PlayList_Tracks
		(PlayList_id,
		track_id) 
            
		VALUES
		(@PlayList_id,
		@track_id)
    END