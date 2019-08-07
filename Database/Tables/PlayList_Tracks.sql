CREATE TABLE [dbo].[PlayList_Tracks]
(
	[PlayList_Track_ID] INT IDENTITY(10000,1) NOT NULL PRIMARY KEY, 
    [track_id] VARCHAR(50) NOT NULL, 
    [PlayList_id] VARCHAR(50) NOT NULL
)
