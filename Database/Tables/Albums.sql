CREATE TABLE [dbo].[Albums]
(
	[Album_id] VARCHAR(50) NOT NULL PRIMARY KEY, 
    [album_type] VARCHAR(MAX) NOT NULL, 
    [Artist_id] VARCHAR(MAX) NOT NULL, 
    [external_urls] VARCHAR(MAX) NOT NULL, 
    [href] VARCHAR(MAX) NOT NULL, 
    [name] VARCHAR(MAX) NOT NULL, 
    [release_date] VARCHAR(MAX) NOT NULL, 
    [total_tracks] INT NOT NULL, 
    [uri] VARCHAR(MAX) NOT NULL,
	[RUN_ID] [VARCHAR](150) NULL
)
