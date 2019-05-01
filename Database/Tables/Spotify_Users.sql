CREATE TABLE [dbo].[Spotify_Users]
(
	[Spotify_User_ID] VARCHAR(150) NOT NULL,
    [DisplayName] VARCHAR(MAX) NULL, 
    CONSTRAINT [PK_Spotify_Users] PRIMARY KEY ([Spotify_User_ID]),
)

