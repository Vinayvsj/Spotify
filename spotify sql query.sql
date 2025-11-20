create database Music

use Music

select * from Spotify

--Business Problems:-

--1. Retrieve the names of all tracks that have more than 1 billion streams.

	select Track
	from Spotify
	where Stream >  1000000000

--2. List all albums along with their respective artists.

	select distinct Album,Artist from Spotify
	order by Album

--3. Get the total number of comments for tracks where `licensed = TRUE`.

	select SUM(Comments) as Total_Comments from Spotify
	where Licensed = 'True'

--4. Find all tracks that belong to the album type `single`

	select Track from Spotify where Album_type = 'single'

--5. Count the total number of tracks by each artist.

	select Artist,COUNT(*) as No_of_Tracks from Spotify
	group by Artist
	order by No_of_Tracks desc


--6. Calculate the average danceability of tracks in each album.

	select Album,AVG(Danceability) as avg_danceability from Spotify
	group by Album
	order by avg_danceability desc

--7. Find the top 5 tracks with the highest energy values.

	select top(5) Track from Spotify
	order by Energy desc

--8. List all tracks along with their views and likes where `official_video = TRUE`.

	select Track,sum(Views) as views,sum(Likes) as likes from Spotify
	where official_video = 'True'
	group by Track

--9. For each album, calculate the total views of all associated tracks.

	select Album,Track ,SUM(Views) as Total_views from Spotify
	group by Album,Track
	order by Album
--10. Retrieve the track names that have been streamed on Spotify more than YouTube.

	select * from
		(select Track,
		isnull(sum(case when most_playedon = 'Youtube' then Stream end),0 )as Stream_on_YouTube,
		isnull(sum(case when most_playedon = 'Spotify' then Stream end) ,0)as Stream_on_spotify
		from Spotify
		group by Track
			) as t1
	where Stream_on_YouTube < Stream_on_spotify
			and Stream_on_YouTube <> 0

--11. Find the top 3 most-viewed tracks for each artist using window functions.

	with Viewed as (
	select Artist,Track,SUM(Views) as Total_views
	from Spotify
	group by Artist,Track
	) ,
	Ranking_Artist as 
	(select *,ROW_NUMBER()over(partition by artist 
	order by artist,total_views desc) as rank from Viewed)

	select Artist,Track,Total_views from Ranking_Artist where RANK <= 3

--12. Write a query to find tracks where the liveness score is above the average.

	select Track,Liveness from Spotify 
		where Liveness > (select AVG(Liveness)  from Spotify)

/*13. Use a `WITH` clause to calculate the difference between the highest and
lowest energy values for tracks in each album.*/

	with CTE as 
		(select Album ,
		max(Energy) as Highest_energy,
		min(Energy) as Lowest_energy 
		from Spotify
		group by Album)
	select Album,(Highest_energy-Lowest_energy) as Energy_diff 
	from CTE
	order by Energy_diff desc




























