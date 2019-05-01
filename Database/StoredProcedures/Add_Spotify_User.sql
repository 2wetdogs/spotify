CREATE PROCEDURE [dbo].[Add_Spotify_User]
	@Spotify_User_ID VARCHAR(150),
	@DisplayName VARCHAR(MAX)
AS
SET NOCOUNT ON;

BEGIN
	IF NOT EXISTS (SELECT * FROM Spotify_Users WHERE Spotify_User_ID = @Spotify_User_ID)
	BEGIN
		INSERT INTO [dbo].[Spotify_Users] 
		([Spotify_User_ID],
		[DisplayName])
		VALUES
		(@Spotify_User_ID,
		@DisplayName)
	END
END