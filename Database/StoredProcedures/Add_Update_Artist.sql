CREATE PROCEDURE [dbo].[Add_Update_Artist]
	@Artist_Id VARCHAR(50),
	@external_urls VARCHAR(MAX),
	@href VARCHAR(MAX),
	@name VARCHAR(MAX),
	@uri VARCHAR(MAX),
	@Run_ID VARCHAR(150)
AS

IF EXISTS (SELECT * FROM dbo.Artists WHERE Artist_id = @Artist_Id)
    BEGIN
        UPDATE dbo.Artists
		SET 
			external_urls = @external_urls,
			href = @href,
			name = @name,
			uri = @uri,
			Run_ID = @Run_ID
            WHERE Artist_Id = @Artist_id;
    END
ELSE
    BEGIN
		INSERT INTO [dbo].[Artists]
			([Artist_Id],
			[external_urls], 
			[href],
			[name],
			[uri],
			[RUN_ID])
		VALUES
			(@Artist_Id,
			@external_urls,
			@href,
			@name,
			@uri,
			@Run_ID);
    END
GO