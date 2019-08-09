CREATE TABLE [dbo].[Artists]
(
	[Artist_Id] VARCHAR(50) NOT NULL PRIMARY KEY, 
    [external_urls] VARCHAR(MAX) NOT NULL, 
    [href] VARCHAR(MAX) NOT NULL, 
    [name] VARCHAR(MAX) NOT NULL, 
    [uri] VARCHAR(MAX) NOT NULL,
	[RUN_ID] [VARCHAR](150) NULL
)
