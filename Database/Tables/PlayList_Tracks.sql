CREATE TABLE [dbo].[PlayList_Tracks]
(
	[PlayList_Track_ID] INT IDENTITY(10000,1) NOT NULL PRIMARY KEY, 
    [track_id] VARCHAR(50) NOT NULL, 
    [PlayList_id] VARCHAR(50) NOT NULL,
	[Added_at] VARCHAR(50) NOT NULL,
	[Added_by_id] VARCHAR(50) NOT NULL,
	[RUN_ID] [VARCHAR](150) NOT NULL
)
