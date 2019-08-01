CREATE PROCEDURE [dbo].[Add_Update_Track]
	@Track_id VARCHAR(50),
	@Artist_id VARCHAR(50),
	@Album_id VARCHAR(50),
	@disc_number INT,
	@duration_ms INT,
	@external_urls VARCHAR(MAX),
	@href VARCHAR(MAX),
	@is_local BIT,
	@name VARCHAR(MAX),
	@popularity INT,
	@track_number INT,
	@uri VARCHAR(MAX)
AS

IF EXISTS (SELECT * FROM dbo.Tracks WHERE Track_id = @track_id)
    BEGIN
        UPDATE dbo.Tracks
		SET 
			Artist_id = @Artist_id,
			Album_id = @Album_id,
			disc_number = @disc_number,
			duration_ms = @duration_ms,
			external_urls = @external_urls,
			href = @href,
			is_local = @is_local,
			name = @name,
			popularity = @popularity,
			track_number = @track_number,
			uri = @uri
            WHERE Track_id = @Track_id;
    END
ELSE
    BEGIN
		INSERT INTO [dbo].[Tracks]
			([Track_id],
			[Artist_id], 
			[Album_id],
			[disc_number],
			[duration_ms],
			[external_urls],
			[href],
			[is_local],
			[name],
			[popularity],
			[track_number],
			[uri])
		VALUES
			(@Track_id,
			@Artist_id,
			@Album_id,
			@disc_number,
			@duration_ms,
			@external_urls,
			@href,
			@is_local,
			@name,
			@popularity,
			@track_number,
			@uri);
    END
GO