-- Getting the final dataset for Mumbai that includes data:
--1. from all time periods (2016Q1-2018Q4)
--2. latitude & longitudes of origin TAZ
--3. latitude & longitudes of destination TAZ

--Starting of with 2016q1 time period=1

CREATE TABLE uber.mumbai_weekdays_2016q1
(
  sourceid bigint,
  dstid bigint,
  hod int,
  mean_travel_time numeric(10,3),
  standard_deviation_travel_time numeric(10,3),
  geometric_mean_travel_time numeric(10,3),
  geometric_standard_deviation_travel_time numeric(10,3)
)

-- NOTE: make the table to be imported UTF-8 encoded in Sublime Text.
COPY uber.mumbai_weekdays_2016q1(sourceid,dstid,hod,mean_travel_time,standard_deviation_travel_time,geometric_mean_travel_time,geometric_standard_deviation_travel_time) 
FROM '/Users/Harsh/Desktop/Uber_Movement/Uber_Movement/mumbai-hexclusters-2016-1-OnlyWeekdays-HourlyAggregate.csv' HEADER DELIMITER ',' CSV;

--copy the geocoded centroids table
CREATE TABLE uber.mumbai_centroids(
id_of_location bigint,
lng numeric(11,9),
lat numeric(11,9)
);

COPY uber.mumbai_centroids(id_of_location,lng,lat) 
FROM '/Users/Harsh/Desktop/Uber_Movement/geocoded_centroids.csv' HEADER DELIMITER ',' CSV;

--put the origin geocodes there for 2016Q1
SELECT	
 a.*,
 b.lng AS lng_o,
 b.lat as lat_o
INTO TABLE uber.mumbai_weekdays_2016q1_with_origin
FROM
 uber.mumbai_weekdays_2016q1 AS a
JOIN uber.mumbai_centroids AS b
ON a.sourceid=b.id_of_location
ORDER BY
a.sourceid;

--put the destination geocodes for the final table for 2016Q1
SELECT	
 a.*,
 b.lng AS lng_d,
 b.lat as lat_d
INTO TABLE uber.mumbai_weekdays_2016q1_with_od
FROM
 uber.mumbai_weekdays_2016q1_with_origin AS a
JOIN uber.mumbai_centroids AS b
ON a.dstid=b.id_of_location
ORDER BY
a.sourceid;

--add time_period identifier for 2016Q1
ALTER TABLE uber.mumbai_weekdays_2016q1_with_od ADD COLUMN time_period INTEGER;
UPDATE  uber.mumbai_weekdays_2016q1_with_od SET  time_period=1;

--drop the unneccessary tables
DROP TABLE uber.mumbai_weekdays_2016q1;
DROP TABLE uber.mumbai_weekdays_2016q1_with_origin;

--repeat the process for all 12 time_periods (2016Q1-2018Q4) to get the final dataset for Mumbai Weekdays (by HOD).
