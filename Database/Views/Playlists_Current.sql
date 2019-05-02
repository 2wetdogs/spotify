CREATE VIEW [dbo].[Playlists_Current]
AS
SELECT *
FROM dbo.Playlists 
WHERE 
	RUN_ID IN (SELECT MAX(RUN_ID) FROM dbo.Playlists)
