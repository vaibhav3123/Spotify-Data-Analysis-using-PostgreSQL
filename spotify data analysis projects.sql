--Perfoming EDA on our data 
-- Total count in table 
SELECT COUNT(*) FROM spotify;

--Total Unique artist
SELECT COUNT(DISTINCT artist) FROM spotify;

--Album Type
SELECT DISTINCT album_type FROM spotify;

--Minimum and Maximum Duration 
SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;

--Check 0 duration 
SELECT * FROM spotify
WHERE duration_min = 0;

--Delete 0 duration song 
DELETE FROM spotify
WHERE duration_min = 0;

--Distinct channel
SELECT DISTINCT channel FROM spotify;




/*Data analysis 
1.Retrieve the names of all tracks that have more than 1 billion streams.*/

SELECT * FROM spotify
WHERE stream > 1000000000;


--2.List all albums along with their respective artists.
SELECT 
	DISTINCT album, artist
FROM spotify
ORDER BY 1;


--3.Get the total number of comments for tracks where licensed = TRUE.
SELECT 
	SUM(comments) AS Total_comments
FROM spotify	
WHERE licensed = 'true';


--4Find all tracks that belong to the album type single.
SELECT * FROM spotify
WHERE album_type = 'single';


--5.Count the total number of tracks by each artist.
SELECT 
	artist,
	COUNT(*) AS Total_Songs
FROM spotify
GROUP BY artist
ORDER BY 2 DESC;



-------------------------------------------------------------------------------
--6.Calculate the average danceability of tracks in each album.

SELECT 
	album,
	AVG(danceability) AS Average_Danceability
FROM spotify
GROUP BY album
ORDER BY 2 DESC;

	
--7.Find the top 5 tracks with the highest energy values.

SELECT 
	track,
	MAX(energy)
FROM spotify
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5;
	

--8.List all tracks along with their views and likes where official_video = TRUE.
SELECT 
	track,
	SUM(views) AS Total_views,
	SUM(likes) AS Total_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


--9.For each album, calculate the total views of all associated tracks.

SELECT 
	album,
	track,
	SUM(views) AS Total_views
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC;


--10.Retrives the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM 
(SELECT 
	track,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as streamed_on_spotify
FROM spotify
GROUP BY 1
) AS T1
WHERE streamed_on_spotify > streamed_on_youtube
	AND
	streamed_on_youtube <> 0;

--11.Find the top 3 most-viewed tracks for each artist using window functions.

WITH ranking_artist
AS
(SELECT 
	artist,
	track,
	SUM(views) AS Total_views,
	DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views)) AS ranks
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE ranks <= 3;

--12.Write a query to find tracks where the liveness score is above the average.

SELECT 
	track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);

--13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH cte
AS
(
SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energy
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energy as energy_diff
FROM cte
ORDER BY 2 DESC;

--14.Find tracks where the energy-to-liveness ratio is greater than 1.2.

SELECT 
    track,
    energy,
    liveness,
    (energy / liveness) AS ratio
FROM spotify
WHERE (energy / liveness) > 1.2;

--15.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT 
    track, 
    views,  
    SUM(likes) OVER (ORDER BY views) AS cumulative_likes
FROM spotify;

