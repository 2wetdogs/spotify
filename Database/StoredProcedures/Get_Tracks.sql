﻿CREATE PROCEDURE [dbo].[Get_Tracks]
AS
SET NOCOUNT ON;

SELECT DISTINCT (track_id) FROM dbo.Playlists WHERE track_id IS NOT NULL
GO