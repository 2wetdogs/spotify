CREATE PROCEDURE [dbo].[Add_Update_Playlist]
(
    @Playlist_id VARCHAR(50),
	@collaborative BIT,
	@description VARCHAR(MAX),
	@external_urls VARCHAR(MAX),
	@href VARCHAR(MAX),
	@name VARCHAR(MAX),
	@owner_id VARCHAR(50),
	@public BIT,
	@uri VARCHAR(MAX),
	@Run_ID VARCHAR(150)
)
AS

IF EXISTS (SELECT * FROM dbo.PlayLists_vnext WHERE Playlist_id = @Playlist_id)
    BEGIN
        UPDATE dbo.PlayLists_vnext
		SET 
			collaborative = @collaborative,
			description = @description,
			external_urls = @external_urls,
			href = @href,
			name = @name,
			owner_id = @owner_id,
			[public] = @public,
			Run_ID = @Run_ID
            WHERE Playlist_id = @Playlist_id;
    END
ELSE
    BEGIN
        INSERT INTO dbo.PlayLists_vnext
		(Playlist_id,
		collaborative,
		description,
		external_urls,
		href,
		name,
		owner_id,
		[public],
		[RUN_ID]) 
            
		VALUES
		(@Playlist_id,
		@collaborative,
		@description,
		@external_urls,
		@href,
		@name,
		@owner_id,
		@public,
		@Run_ID)
    END