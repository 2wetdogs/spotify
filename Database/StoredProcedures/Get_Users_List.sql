﻿CREATE PROCEDURE [dbo].[Get_Users_List]
AS
SET NOCOUNT ON;

SELECT DISTINCT (AddedBy_ID) FROM dbo.Playlists
GO