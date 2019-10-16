--Getting average peak hour morning and evening travel times for each CBD to each residential area:

--Example: CBD= Lower Parel. 

-- taking only Residential Areas and one CBD and ordering by sourceid, dstid, time_period
SELECT
DISTINCT *
INTO uber.mumbai_Lower_Parel_weekday_residential_areas_1
FROM
uber.mumbai_weekday_peak_hours
WHERE
(sourceid=239 AND dstid=265) OR (sourceid=265 AND dstid=239) OR
(sourceid=239 AND dstid=577) OR (sourceid=577 AND dstid=239) OR
(sourceid=239 AND dstid=598) OR (sourceid=598 AND dstid=239) OR
(sourceid=239 AND dstid=403) OR (sourceid=403 AND dstid=239)
ORDER BY
sourceid, dstid,time_period;

--generate row_number and store in temporary table.
SELECT  sourceid, 
dstid, 
hod, 
mean_travel_time, 
time_period, 
lng_o, lat_o, lng_d, lat_d, Row_Num
INTO uber.mumbai_Lower_Parel_weekday_residential_areas_2
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
 	  FROM uber.mumbai_Lower_Parel_weekday_residential_areas_1)  AS a
 WHERE Row_Num=1 OR Row_Num=2 OR Row_Num=3 OR Row_Num=4
 ORDER BY sourceid;

--drop the temporary table. 
DROP TABLE uber.mumbai_Lower_Parel_weekday_residential_areas_1;

--generate count_of_rows and store in temporary table. 
SELECT
*,
count(row_num) OVER(PARTITION BY sourceid, dstid, time_period ORDER BY sourceid ASC) as count_of_rows
INTO uber.mumbai_Lower_Parel_weekday_residential_areas
FROM uber.mumbai_Lower_Parel_weekday_residential_areas_2;

--drop the temporary table. 
DROP TABLE uber.mumbai_Lower_Parel_weekday_residential_areas_2;

--export the file, put unique identifier (sourceid, dstid, tp- 96 for each, 480 total) in Python. 
COPY uber.mumbai_Lower_Parel_weekday_residential_areas 
TO '/Users/Harsh/Desktop/Uber_Movement/mumbai/Lower_Parel/mumbai_Lower_Parel_weekday_residential_areas.csv' DELIMITER ',' CSV HEADER;

----------------------END OF PART 1---------------------------------------------------------------------

--drop the temporary table. 
DROP TABLE uber.mumbai_Lower_Parel_weekday_residential_areas;

--create the new table.
CREATE TABLE uber.mumbai_Lower_Parel_weekday_residential_areas
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
COPY uber.mumbai_Lower_Parel_weekday_residential_areas(sourceid,dstid,hod,mean_travel_time,time_period,lng_o,lat_o, lng_d,lat_d, row_num, count_of_rows,unique_id)
FROM '/Users/Harsh/Desktop/Uber_Movement/mumbai/Lower_Parel/mumbai_Lower_Parel_weekday_residential_areas.csv' CSV HEADER DELIMITER ',';

--only morning peak hours
SELECT
DISTINCT *
INTO uber.mumbai_Lower_Parel_weekday_residential_areas_am
FROM
uber.mumbai_Lower_Parel_weekday_residential_areas
WHERE
(hod=8) OR (hod=9);

--only evening peak hours
SELECT
DISTINCT *
INTO uber.mumbai_Lower_Parel_weekday_residential_areas_pm
FROM
uber.mumbai_Lower_Parel_weekday_residential_areas
WHERE
(hod=18) OR (hod=19);

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
INTO uber.mumbai_weekday_residential_to_Lower_Parel_am
FROM
uber.mumbai_Lower_Parel_weekday_residential_areas_am
WHERE
sourceid!=239;

--selecting distict rows and ordering.
SELECT
DISTINCT *
INTO uber.mumbai_weekday_residential_to_Lower_Parel_am_final
FROM
uber.mumbai_weekday_residential_to_Lower_Parel_am
ORDER BY sourceid, dstid, time_period;

--DROP the unneccessary table

DROP TABLE uber.mumbai_weekday_residential_to_Lower_Parel_am;
DROP TABLE uber.mumbai_Lower_Parel_weekday_residential_areas_am;

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
INTO uber.mumbai_weekday_Lower_Parel_to_residential_pm
FROM
uber.mumbai_Lower_Parel_weekday_residential_areas_pm
WHERE
sourceid=239;

--selecting distict rows and ordering.
SELECT
DISTINCT *
INTO uber.mumbai_weekday_Lower_Parel_to_residential_pm_final
FROM
uber.mumbai_weekday_Lower_Parel_to_residential_pm
ORDER BY sourceid, dstid, time_period;

--DROP the unneccessary table
DROP TABLE uber.mumbai_weekday_Lower_Parel_to_residential_pm;
DROP TABLE uber.mumbai_Lower_Parel_weekday_residential_areas_pm;
DROP TABLE uber.mumbai_Lower_Parel_weekday_residential_areas;

--Copy the tables into CSV format
COPY uber.mumbai_weekday_residential_to_Lower_Parel_am_final TO '/Users/Harsh/Desktop/Uber_Movement/mumbai/Lower_Parel/mumbai_weekday_residential_to_Lower_Parel_am_final.csv' DELIMITER ',' CSV HEADER;
COPY uber.mumbai_weekday_Lower_Parel_to_residential_pm_final TO '/Users/Harsh/Desktop/Uber_Movement/mumbai/Lower_Parel/mumbai_weekday_Lower_Parel_to_residential_pm_final.csv' DELIMITER ',' CSV HEADER;

DROP TABLE uber.mumbai_weekday_residential_to_Lower_Parel_am_final;
DROP TABLE uber.mumbai_weekday_Lower_Parel_to_residential_pm_final;

----------------------END OF PART 2---------------------------------------------------------------------
