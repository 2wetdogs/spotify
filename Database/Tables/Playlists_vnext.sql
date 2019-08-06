CREATE TABLE [PlayLists_vnext](
	[Playlist_id] VARCHAR(50) NOT NULL,
	[collaborative] BIT NOT NULL,
	[description] VARCHAR(MAX) NOT NULL,
	[external_urls] VARCHAR(MAX) NOT NULL,
	[href] [VARCHAR](MAX) NOT NULL,
	[name] [VARCHAR](MAX) NOT NULL,
	[owner_id] [VARCHAR](MAX) NOT NULL,
	[public] BIT NOT NULL
)
