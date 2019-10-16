--Goals of this script:
--1. Identifiying the closest Uber defined TAZ to the lat-long pair identified on a particular route.
--2. After identifying all TAZs, calculating Average Travel times for each segment between 2016Q1-2018Q4

--Example:Andheri West to Nariman Point

--select the TAZs closest to the lat long
SELECT
id_of_location,
lat,
lng,
where_is
FROM
uber.mumbai_centroids
WHERE
(lng LIKE '72.85%') AND (lat LIKE  '19.1%');
19.12356	72.85649
----------------------END OF PART 1---------------------------------------------------------------------
SELECT
DISTINCT *
INTO uber.mumbai_Andheri_West_to_Nariman_Point_1
FROM
uber.mumbai_weekday_peak_hours
WHERE
(sourceid=403 AND dstid=554) OR (sourceid=554 AND dstid=245) OR
(sourceid=245 AND dstid=191) OR (sourceid=191 AND dstid=283) OR
(sourceid=283 AND dstid=382) --OR (sourceid=350 AND dstid=265) --OR
--(sourceid=577 AND dstid=668) OR (sourceid=668 AND dstid=191) --OR
--(sourceid=128 AND dstid=357) --OR (sourceid=668 AND dstid=577) 
ORDER BY
sourceid, dstid,time_period;

--generate row_number and store in temporary table.
SELECT  sourceid, 
dstid, 
hod, 
mean_travel_time, 
time_period, 
lng_o, lat_o, lng_d, lat_d, Row_Num
INTO uber.mumbai_Andheri_West_to_Nariman_Point_2
FROM (SELECT sourceid,
	  dstid,
	  hod,
	  mean_travel_time,
	  time_period,
	  lng_o,
	  lat_o,
	  lng_d,
	  lat_d, 
	  row_number() OVER (PARTITION BY sourceid, dstid, time_period ORDER BY sourceid ASC) AS Row_Num
 	  FROM uber.mumbai_Andheri_West_to_Nariman_Point_1)  AS a
 WHERE Row_Num=1 OR Row_Num=2 OR Row_Num=3 OR Row_Num=4
 ORDER BY sourceid;
 
 --drop the temporary table. 
DROP TABLE uber.mumbai_Andheri_West_to_Nariman_Point_1;
--generate count_of_rows and store in temporary table. 
SELECT
*,
count(row_num) OVER(PARTITION BY sourceid, dstid, time_period ORDER BY sourceid ASC) as count_of_rows
INTO uber.mumbai_Andheri_West_to_Nariman_Point
FROM uber.mumbai_Andheri_West_to_Nariman_Point_2;

--drop the temporary table. 
DROP TABLE uber.mumbai_Andheri_West_to_Nariman_Point_2;

--export the file, put unique identifier (sourceid, dstid, tp- 96 for each, 480 total) in Python. 
COPY uber.mumbai_Andheri_West_to_Nariman_Point 
TO '/Users/Harsh/Desktop/Uber_Movement/mumbai/Nariman_Point/mumbai_Andheri_West_to_Nariman_Point.csv' DELIMITER ',' CSV HEADER;

----------------------END OF PART 2---------------------------------------------------------------------

--drop the temporary table. 
DROP TABLE uber.mumbai_Andheri_West_to_Nariman_Point;

--create the new table.
CREATE TABLE uber.mumbai_Andheri_West_to_Nariman_Point
(
  sourceid bigint,
  dstid bigint,
  hod int,
  mean_travel_time numeric(10,3),
  time_period int,
  lng_o numeric(11,9),
  lat_o numeric(11,9),
  lng_d numeric(11,9),
  lat_d numeric(11,9),
  row_num int,
  count_of_rows int,
  unique_id int
);

--reimport the new table with the unique_id in place.
COPY uber.mumbai_Andheri_West_to_Nariman_Point(sourceid,dstid,hod,mean_travel_time,time_period,lng_o,lat_o, lng_d,lat_d, row_num, count_of_rows,unique_id)
FROM '/Users/Harsh/Desktop/Uber_Movement/mumbai/Nariman_Point/mumbai_Andheri_West_to_Nariman_Point.csv' CSV HEADER DELIMITER ',';

-------ONLY For morning (residential to CBD routes)------------------------------------------------------------------------
--only morning peak hours
SELECT
DISTINCT *
INTO uber.mumbai_Andheri_West_to_Nariman_Point_am
FROM
uber.mumbai_Andheri_West_to_Nariman_Point
WHERE
(hod=8) OR (hod=9);



--from all residential areas to one CBD -average morning peak hours
SELECT
sourceid,
dstid,
time_period,
AVG(mean_travel_time) OVER (partition by unique_id ORDER BY sourceid) AS average_travel_time,
lng_o,
lat_o,
lng_d,
lat_d,unique_id
INTO uber.Andheri_West_to_Nariman_Point_am
FROM
uber.mumbai_Andheri_West_to_Nariman_Point_am;

--selecting distict rows and ordering.
SELECT
DISTINCT *
INTO uber.Andheri_West_to_Nariman_Point_am_final
FROM
uber.Andheri_West_to_Nariman_Point_am
ORDER BY sourceid, dstid, time_period;

--DROP the unneccessary table

DROP TABLE uber.Andheri_West_to_Nariman_Point_am;
DROP TABLE uber.mumbai_Andheri_West_to_Nariman_Point_am;

--Copy the tables into CSV format
COPY uber.Andheri_West_to_Nariman_Point_am_final TO '/Users/Harsh/Desktop/Uber_Movement/mumbai/Nariman_Point/Andheri_West_to_Nariman_Point_am_final.csv' DELIMITER ',' CSV HEADER;

DROP TABLE uber.Andheri_West_to_Nariman_Point_am_final;

-------ONLY For evening PM (CBD to Residential routes)------------------------------------------------------------------------

--only evening peak hours
SELECT
DISTINCT *
INTO uber.mumbai_Andheri_West_to_Nariman_Point_pm
FROM
uber.mumbai_Andheri_West_to_Nariman_Point
WHERE
(hod=18) OR (hod=19);

--from the CBD to all residential areas average evening peak hours
SELECT
sourceid,
dstid,
time_period,
AVG(mean_travel_time) OVER (partition by unique_id ORDER BY dstid) AS average_travel_time,
lng_o,
lat_o,
lng_d,
lat_d
INTO uber.Andheri_West_to_Nariman_Point_pm
FROM
uber.mumbai_Andheri_West_to_Nariman_Point_pm;

--selecting distict rows and ordering.
SELECT
DISTINCT *
INTO uber.Andheri_West_to_Nariman_Point_pm_final
FROM
uber.Andheri_West_to_Nariman_Point_pm
ORDER BY sourceid, dstid, time_period;

--DROP the unneccessary table
DROP TABLE uber.Andheri_West_to_Nariman_Point_pm;
DROP TABLE uber.mumbai_Andheri_West_to_Nariman_Point_pm;
DROP TABLE uber.mumbai_Andheri_West_to_Nariman_Point;

--Copy the tables into CSV format
COPY uber.Andheri_West_to_Nariman_Point_pm_final TO '/Users/Harsh/Desktop/Uber_Movement/mumbai/Nariman_Point/Andheri_West_to_Nariman_Point_pm_final.csv' DELIMITER ',' CSV HEADER;

DROP TABLE uber.Andheri_West_to_Nariman_Point_pm_final;

----------------------END OF PART 2--------------------------------------------------------------------
