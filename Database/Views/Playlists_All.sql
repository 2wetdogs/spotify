CREATE VIEW [dbo].[PlayLists_All]
AS
SELECT        dbo.Playlists.*, dbo.Spotify_Users.DisplayName,
			  dbo.Audio_Features.duration_ms,
			  dbo.Audio_Features.time_signature,
			  dbo.Audio_Features.danceability,
			  dbo.Audio_Features.energy,
			  dbo.Audio_Features.[key],
			  dbo.Audio_Features.loudness,
			  dbo.Audio_Features.mode,
			  dbo.Audio_Features.speechiness,
			  dbo.Audio_Features.acousticness,
			  dbo.Audio_Features.instrumentalness,
			  dbo.Audio_Features.liveness,
			  dbo.Audio_Features.valence,
			  dbo.Audio_Features.tempo
FROM            dbo.Playlists INNER JOIN
                   dbo.Spotify_Users ON dbo.Playlists.AddedBy_ID = dbo.Spotify_Users.Spotify_User_ID INNER JOIN
				      dbo.Audio_Features ON dbo.Playlists.track_id = dbo.Audio_Features.Track_id

