CREATE TABLE [dbo].[Audio_Features](
	[Audio_Feature_ID] [int] IDENTITY(10000,1) NOT NULL,
	[Track_id] [VARCHAR](MAX) NOT NULL,
	[duration_ms] INT NOT NULL,
	[time_signature] [INT] NOT NULL,
	[danceability] DECIMAL(18, 10) NULL,
	[energy] DECIMAL(18, 10) NULL,
	[key] INT NULL,
	[loudness] DECIMAL(18, 10) NULL,
	[mode] DECIMAL(18, 10) NULL,
	[speechiness] DECIMAL(18, 10) NULL,
	[acousticness] DECIMAL(18, 10) NULL,
	[instrumentalness] DECIMAL(18, 10) NULL,
	[liveness] DECIMAL(18, 10) NULL,
	[valence] DECIMAL(18, 10) NULL,
	[tempo] DECIMAL(18, 10) NULL,
	[RUN_ID] [VARCHAR](150) NULL,
	[Added_To_Table_Date_Time] [VARCHAR](MAX) NULL)
	