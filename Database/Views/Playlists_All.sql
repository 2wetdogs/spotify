CREATE VIEW [dbo].[PlayLists_All]
AS
SELECT        dbo.Playlists.*, dbo.Spotify_Users.DisplayName
FROM            dbo.Playlists INNER JOIN
                         dbo.Spotify_Users ON dbo.Playlists.AddedBy_ID = dbo.Spotify_Users.Spotify_User_ID

