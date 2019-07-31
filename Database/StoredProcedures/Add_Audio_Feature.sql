CREATE PROCEDURE [dbo].[Add_Audio_Feature]
	@Track_id VARCHAR(MAX),
	@duration_ms DECIMAL(18, 10),
	@time_signature INT,
	@danceability DECIMAL(18, 10),
	@energy DECIMAL(18, 10),
	@key INT,
	@loudness DECIMAL(18, 10),
	@mode DECIMAL(18, 10),
	@speechiness DECIMAL(18, 10),
	@acousticness DECIMAL(18, 10),
	@instrumentalness DECIMAL(18, 10),
	@liveness DECIMAL(18, 10),
	@valence DECIMAL(18, 10),
	@tempo DECIMAL(18, 10),
	@RUN_ID VARCHAR(150),
	@Added_To_Table_Date_Time VARCHAR(MAX)

	
AS
SET NOCOUNT ON;

BEGIN
	IF NOT EXISTS (SELECT * FROM Audio_Features WHERE Track_id = @Track_id)
	BEGIN
		INSERT INTO [dbo].[Audio_Features] 
	   ([Track_id],
		[duration_ms],
		[time_signature],
		[danceability],
		[energy],
		[key],
		[loudness],
		[mode],
		[speechiness],
		[acousticness],
		[instrumentalness],
		[liveness],
		[valence],
		[tempo],
		[RUN_ID],
		[Added_To_Table_Date_Time])
		VALUES
		(@Track_id,
		@duration_ms,
		@time_signature,
		@danceability,
		@energy,
		@key,
		@loudness,
		@mode,
		@speechiness,
		@acousticness,
		@instrumentalness,
		@liveness,
		@valence,
		@tempo,
		@RUN_ID,
		@Added_To_Table_Date_Time)
	END
END