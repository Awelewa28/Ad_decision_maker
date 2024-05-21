SELECT * 
FROM Top_UK_YouTuber.dbo.youtube_data_from_python$

---Choosing neccesary columns needed for view and analysis-----
SELECT
	NOMBRE,
	[ALCANCE POTENCIAL],
	total_subscribers,
	total_videos,
	total_views
FROM
	Top_UK_YouTuber.dbo.youtube_data_from_python$

---Exctracting channel name from NOMBRE Column-----
SELECT
	CHARINDEX('@',NOMBRE), NOMBRE
FROM
	Top_UK_YouTuber.dbo.youtube_data_from_python$

SELECT 
	SUBSTRING(NOMBRE,1,CHARINDEX('@',NOMBRE)-1), 
	[ALCANCE POTENCIAL],
	total_subscribers,
	total_videos,
	total_views
FROM
	Top_UK_YouTuber.dbo.youtube_data_from_python$

---Renaming columns from spanish to english
SELECT 
	SUBSTRING(NOMBRE,1,CHARINDEX('@',NOMBRE)-1)AS channel_name, 
	[ALCANCE POTENCIAL] AS potential_reach,
	total_subscribers,
	total_videos,
	total_views
FROM
	Top_UK_YouTuber.dbo.youtube_data_from_python$

---Channel name on the 30th row need to be updated, from BBC News عربي to BBC News US 
--to match the pattern of the column----
UPDATE  Top_UK_YouTuber.dbo.youtube_data_from_python$
SET NOMBRE = 'BBC News US@'
WHERE # = 30 AND total_subscribers = 11500000 AND total_videos = 40179

--Removing the millions symbol,and converting potential reach datatype to float for calculations.
---(Note the values are in millions)----
SELECT 
	SUBSTRING(NOMBRE,1,CHARINDEX('@',NOMBRE)-1)AS channel_name, 
	CAST(SUBSTRING([ALCANCE POTENCIAL],1,CHARINDEX('M',[ALCANCE POTENCIAL])-1)AS FLOAT) AS potential_reach,
	total_subscribers,
	total_videos,
	total_views
FROM
	Top_UK_YouTuber.dbo.youtube_data_from_python$

--- Creating a view for the selected and cleaned data----
CREATE VIEW top_uk_youtubers AS
SELECT 
	SUBSTRING(NOMBRE,1,CHARINDEX('@',NOMBRE)-1)AS channel_name, 
	CAST(SUBSTRING([ALCANCE POTENCIAL],1,CHARINDEX('M',[ALCANCE POTENCIAL])-1)AS FLOAT) AS potential_reach,
	total_subscribers,
	total_videos,
	total_views
FROM
	Top_UK_YouTuber.dbo.youtube_data_from_python$

SELECT * from top_uk_youtubers

										---Data Validation Checks-------

----COUNT to check the view have 100 distinct channels----
SELECT Distinct COUNT(channel_name)
FROM top_uk_youtubers               

---Checking the datatypes of the columns----
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'top_uk_youtubers'

--total_subscribers, total_videos and total_views have to be INTEGER Datatype.
IF EXISTS (SELECT * FROM sysobjects WHERE xtype = 'V' AND name = 'top_uk_youtubers')
BEGIN
    DROP VIEW top_uk_youtubers
END	

CREATE VIEW top_uk_youtubers AS
SELECT 
	SUBSTRING(NOMBRE,1,CHARINDEX('@',NOMBRE)-1)AS channel_name, 
	CAST(SUBSTRING([ALCANCE POTENCIAL],1,CHARINDEX('M',[ALCANCE POTENCIAL])-1)AS FLOAT) AS potential_reach,
	CAST(total_subscribers AS INT) AS total_subscribers ,
	CAST(total_videos AS INT) AS total_videos ,
	CAST(total_views AS bigint) AS total_views
FROM
	Top_UK_YouTuber.dbo.youtube_data_from_python$

SELECT * FROM top_uk_youtubers

SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'top_uk_youtubers'

-----
