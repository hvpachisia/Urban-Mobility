--Getting average travel times during free-flow hours (1am-5am) for each CBD to each residential area:

--Example: CBD= Andheri East. 

-- taking only Residential Areas and one CBD and ordering by sourceid, dstid, time_period
SELECT
DISTINCT *
INTO uber.mumbai_Andheri_East_weekday_free_flow_1
FROM
uber.mumbai_weekday_hourly_with_od
WHERE
(sourceid=357 AND dstid=265 AND (hod=1 OR hod=2 OR hod=3 OR hod=4)) OR (sourceid=265 AND dstid=357 AND (hod=1 OR hod=2 OR hod=3 OR hod=4)) OR
(sourceid=357 AND dstid=577 AND (hod=1 OR hod=2 OR hod=3 OR hod=4)) OR (sourceid=577 AND dstid=357 AND (hod=1 OR hod=2 OR hod=3 OR hod=4)) OR
(sourceid=357 AND dstid=598 AND (hod=1 OR hod=2 OR hod=3 OR hod=4)) OR (sourceid=598 AND dstid=357 AND (hod=1 OR hod=2 OR hod=3 OR hod=4)) OR
(sourceid=357 AND dstid=403 AND (hod=1 OR hod=2 OR hod=3 OR hod=4)) OR (sourceid=403 AND dstid=357 AND (hod=1 OR hod=2 OR hod=3 OR hod=4))
ORDER BY
sourceid, dstid,time_period;
																										
--generate row_number and store in temporary table.
SELECT  sourceid, 
dstid, 
hod, 
mean_travel_time, 
time_period, 
lng_o, lat_o, lng_d, lat_d, Row_Num
INTO uber.mumbai_Andheri_East_weekday_free_flow_2
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
 	  FROM uber.mumbai_Andheri_East_weekday_free_flow_1)  AS a
 WHERE Row_Num=1 OR Row_Num=2 OR Row_Num=3 OR Row_Num=4
 ORDER BY sourceid;	

--drop the temporary table. 
DROP TABLE uber.mumbai_Andheri_East_weekday_free_flow_1;
--generate count_of_rows and store in temporary table. 
SELECT
*,
count(row_num) OVER(PARTITION BY sourceid, dstid, time_period ORDER BY sourceid ASC) as count_of_rows
INTO uber.mumbai_Andheri_East_weekday_free_flow
FROM uber.mumbai_Andheri_East_weekday_free_flow_2;

--drop the temporary table. 
DROP TABLE uber.mumbai_Andheri_East_weekday_free_flow_2;

--export the file, put unique identifier (sourceid, dstid, tp- 96 for each, 480 total) in Python. 
COPY uber.mumbai_Andheri_East_weekday_free_flow 
TO '/Users/Harsh/Desktop/Uber_Movement/mumbai/Andheri_East/mumbai_Andheri_East_weekday_free_flow.csv' DELIMITER ',' CSV HEADER;

----------------------END OF PART 1---------------------------------------------------------------------

--drop the temporary table. 
DROP TABLE uber.mumbai_Andheri_East_weekday_free_flow;
																										
--create the new table.
CREATE TABLE uber.mumbai_Andheri_East_weekday_free_flow
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
COPY uber.mumbai_Andheri_East_weekday_free_flow(sourceid,dstid,hod,mean_travel_time,time_period,lng_o,lat_o, lng_d,lat_d, row_num, count_of_rows,unique_id)
FROM '/Users/Harsh/Desktop/Uber_Movement/mumbai/Andheri_East/mumbai_Andheri_East_weekday_free_flow.csv' CSV HEADER DELIMITER ',';

--from all residential areas to one CBD -average hours
SELECT
sourceid,
dstid,
time_period,
AVG(mean_travel_time) OVER (partition by unique_id ORDER BY sourceid) AS average_travel_time,
lng_o,
lat_o,
lng_d,
lat_d,unique_id
INTO uber.mumbai_weekday_free_flow_residential_to_Andheri_East
FROM
uber.mumbai_Andheri_East_weekday_free_flow
WHERE
sourceid!=357;																										

--selecting distict rows and ordering.
SELECT
DISTINCT *
INTO uber.mumbai_weekday_free_flow_residential_to_Andheri_East_final
FROM
uber.mumbai_weekday_free_flow_residential_to_Andheri_East
ORDER BY sourceid, dstid, time_period;

--DROP the unneccessary table
DROP TABLE uber.mumbai_weekday_free_flow_residential_to_Andheri_East;

--from the CBD to all residential areas average free flow hours
SELECT
sourceid,
dstid,
time_period,
AVG(mean_travel_time) OVER (partition by unique_id ORDER BY dstid) AS average_travel_time,
lng_o,
lat_o,
lng_d,
lat_d
INTO uber.mumbai_weekday_free_flow_Andheri_East_to_residential
FROM
uber.mumbai_Andheri_East_weekday_free_flow
WHERE
sourceid=357;

--selecting distict rows and ordering.
SELECT
DISTINCT *
INTO uber.mumbai_weekday_free_flow_Andheri_East_to_residential_final
FROM
uber.mumbai_weekday_free_flow_Andheri_East_to_residential
ORDER BY sourceid, dstid, time_period;

--DROP the unneccessary table
DROP TABLE uber.mumbai_weekday_free_flow_Andheri_East_to_residential;
DROP TABLE uber.mumbai_Andheri_East_weekday_free_flow;

--Copy the tables into CSV format
COPY uber.mumbai_weekday_free_flow_residential_to_Andheri_East_final TO '/Users/Harsh/Desktop/Uber_Movement/mumbai/Andheri_East/mumbai_weekday_free_flow_residential_to_Andheri_East_final.csv' DELIMITER ',' CSV HEADER;
COPY uber.mumbai_weekday_free_flow_Andheri_East_to_residential_final TO '/Users/Harsh/Desktop/Uber_Movement/mumbai/Andheri_East/mumbai_weekday_free_flow_Andheri_East_to_residential_final.csv' DELIMITER ',' CSV HEADER;

DROP TABLE uber.mumbai_weekday_free_flow_residential_to_Andheri_East_final;
DROP TABLE uber.mumbai_weekday_free_flow_Andheri_East_to_residential_final;

----------------------END OF PART 2---------------------------------------------------------------------
																										