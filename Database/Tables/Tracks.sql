CREATE TABLE [dbo].[Tracks]
(
	[Track_id] VARCHAR(50) NOT NULL PRIMARY KEY,
    [Artist_id] VARCHAR(50) NOT NULL,
	[Album_id] VARCHAR(50) NOT NULL,
	[disc_number] INT NOT NULL, 
    [duration_ms] INT NOT NULL, 
    [external_urls] VARCHAR(MAX) NOT NULL, 
    [href] VARCHAR(MAX) NOT NULL, 
    [is_local] BIT NOT NULL, 
    [name] VARCHAR(MAX) NOT NULL, 
    [popularity] INT NOT NULL, 
    [track_number] INT NOT NULL, 
    [uri] VARCHAR(MAX) NOT NULL,
	[RUN_ID] [VARCHAR](150) NULL
  )
