CREATE PROCEDURE [dbo].[Add_Update_Album]
(
    @Album_id VARCHAR(50),
	@album_type VARCHAR(MAX),
	@Artist_id VARCHAR(MAX),
	@external_urls VARCHAR(MAX),
	@href VARCHAR(MAX),
	@name VARCHAR(MAX),
	@release_date VARCHAR(MAX),
	@total_tracks INT,
	@uri VARCHAR(MAX),
	@Run_ID VARCHAR(150)
)
AS

IF EXISTS (SELECT * FROM dbo.Albums WHERE Album_id = @Album_id)
    BEGIN
        UPDATE dbo.Albums 
		SET 
			album_type = @album_type,
			Artist_id = @Artist_id,
			external_urls = @external_urls,
			href = @href,
			name = @name,
			release_date = @release_date,
			total_tracks = @total_tracks,
			uri = @uri,
			Run_ID = @Run_ID
            WHERE Album_id = @Album_id;
    END
ELSE
    BEGIN
        INSERT INTO dbo.Albums
		(Album_id,
		Artist_id,
		album_type,
		external_urls,
		href,
		name,
		release_date,
		total_tracks,
		uri,
		[RUN_ID]) 
            
		VALUES
		(@Album_id,
		@Artist_id,
		@album_type,
		@external_urls,
		@href,
		@name,
		@release_date,
		@total_tracks,
		@uri,
		@Run_ID)
    END