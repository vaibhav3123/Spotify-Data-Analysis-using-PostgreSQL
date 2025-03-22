# Spotify SQL Analysis

## Overview
This project performs **Exploratory Data Analysis (EDA) and Data Analysis** on a Spotify dataset using SQL. The analysis covers various aspects, including track performance, artist insights, album trends, and user engagement metrics.

## Dataset Description
The dataset contains the following columns:
- `artist` – Name of the artist.
- `track` – Name of the track.
- `album` – Album name.
- `album_type` – Type of album (e.g., single, album, compilation, EP).
- `danceability` – A measure of how suitable a track is for dancing.
- `energy` – Represents the intensity and activity of the track.
- `loudness` – Overall loudness of the track in decibels.
- `speechiness` – The presence of spoken words in a track.
- `acousticness` – The likelihood of a track being acoustic.
- `instrumentalness` – Predicts whether a track contains vocals.
- `liveness` – Detects the presence of a live audience in the track.
- `valence` – Describes the musical positiveness conveyed by a track.
- `tempo` – The tempo of the track (beats per minute).
- `duration_min` – Length of the track in minutes.
- `views` – Number of views on YouTube.
- `likes` – Number of likes on YouTube.
- `comments` – Number of comments on YouTube.
- `licensed` – Indicates if the track is licensed.
- `official_video` – Indicates if the track has an official video.
- `stream` – Number of streams on Spotify.
- `most_played_on` – Platform where the track is most streamed (Spotify/YouTube).

## SQL Queries and Analysis
### **Exploratory Data Analysis (EDA)**
1. **Total Records:**
   ```sql
   SELECT COUNT(*) FROM spotify;
   ```
2. **Unique Artists Count:**
   ```sql
   SELECT COUNT(DISTINCT artist) FROM spotify;
   ```
3. **Distinct Album Types:**
   ```sql
   SELECT DISTINCT album_type FROM spotify;
   ```
4. **Minimum & Maximum Duration:**
   ```sql
   SELECT MIN(duration_min), MAX(duration_min) FROM spotify;
   ```
5. **Tracks with 0 Duration (if any):**
   ```sql
   SELECT * FROM spotify WHERE duration_min = 0;
   ```
   - **Deleting Tracks with 0 Duration:**
     ```sql
     DELETE FROM spotify WHERE duration_min = 0;
     ```
6. **Distinct Channels:**
   ```sql
   SELECT DISTINCT channel FROM spotify;
   ```

### **Data Analysis**
7. **Tracks with More Than 1 Billion Streams:**
   ```sql
   SELECT track, artist, stream FROM spotify WHERE stream > 1000000000;
   ```
8. **Total Number of Comments for Licensed Tracks:**
   ```sql
   SELECT SUM(comments) AS total_comments FROM spotify WHERE licensed = TRUE;
   ```
9. **Tracks from Albums of Type 'Single':**
   ```sql
   SELECT * FROM spotify WHERE album_type = 'single';
   ```
10. **Total Number of Tracks per Artist:**
    ```sql
    SELECT artist, COUNT(*) AS total_tracks FROM spotify GROUP BY artist ORDER BY total_tracks DESC;
    ```
11. **Average Danceability per Album:**
    ```sql
    SELECT album, AVG(danceability) AS avg_danceability FROM spotify GROUP BY album ORDER BY avg_danceability DESC;
    ```
12. **Top 5 Tracks with Highest Energy:**
    ```sql
    SELECT track, energy FROM spotify ORDER BY energy DESC LIMIT 5;
    ```
13. **Tracks with Official Videos and Their Views & Likes:**
    ```sql
    SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes FROM spotify WHERE official_video = TRUE GROUP BY track ORDER BY total_views DESC LIMIT 5;
    ```
14. **Total Views for Each Album:**
    ```sql
    SELECT album, track, SUM(views) AS total_views FROM spotify GROUP BY album, track ORDER BY total_views DESC;
    ```
15. **Tracks Streamed More on Spotify Than YouTube:**
    ```sql
    SELECT * FROM ( SELECT track, COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS streamed_on_youtube, COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS streamed_on_spotify FROM spotify GROUP BY track ) AS T1 WHERE streamed_on_spotify > streamed_on_youtube;
    ```
16. **Top 3 Most-Viewed Tracks for Each Artist:**
    ```sql
    WITH ranking_artist AS (
        SELECT artist, track, SUM(views) AS total_views,
               DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
        FROM spotify
        GROUP BY artist, track
    )
    SELECT * FROM ranking_artist WHERE rank <= 3;
    ```
17. **Tracks with Liveness Score Above Average:**
    ```sql
    SELECT track, artist, liveness FROM spotify WHERE liveness > (SELECT AVG(liveness) FROM spotify);
    ```
18. **Difference Between Highest and Lowest Energy per Album:**
    ```sql
    WITH cte AS (
        SELECT album, MAX(energy) AS highest_energy, MIN(energy) AS lowest_energy FROM spotify GROUP BY album
    )
    SELECT album, highest_energy - lowest_energy AS energy_diff FROM cte ORDER BY energy_diff DESC;
    ```
19. **Tracks Where the Energy-to-Liveness Ratio is Greater Than 1.2:**
    ```sql
    SELECT track, energy, liveness, (energy / liveness) AS ratio FROM spotify WHERE (energy / liveness) > 1.2;
    ```
20. **Cumulative Sum of Likes Ordered by Views:**
    ```sql
    SELECT track, views, SUM(likes) OVER (ORDER BY views) AS cumulative_likes FROM spotify;
    ```

## Insights & Key Findings
- Most artists have released multiple tracks, but only a few have reached **over 1 billion streams**.
- **Danceability and energy** vary significantly across albums, with some having a high concentration of energetic songs.
- **Official videos** contribute to a higher number of views and likes on YouTube.
- **The most-played platform (Spotify vs. YouTube)** helps in identifying user preferences and marketing strategies.

## How to Use
1. Load the dataset into a **PostgreSQL database**.
2. Run the SQL queries to explore and analyze the data.
3. Modify or extend queries based on your analysis needs.

## Tools Used
- **PostgreSQL** for SQL queries.
- **DBeaver / pgAdmin** for query execution and database management.

## 📬 Contact & Contributions
For any questions, discussions, or improvements, feel free to reach out:

GitHub: https://github.com/vaibhav3123  
LinkedIn: https://www.linkedin.com/in/vaibhav-bari-915bb5202/  
Email: bariv219@gmail.com  

🚀 Happy Analyzing!

