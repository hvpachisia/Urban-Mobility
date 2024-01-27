--Starting of with 2016q1 time period=1
--note: 2018q1 is already done as a test case. Given number=9 (quarter 9)

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

--already done
--CREATE TABLE uber.mumbai_centroids(
--  id_of_location bigint,
  --lng numeric(11,9),
--  lat numeric(11,9)
--)

--COPY uber.mumbai_centroids(id_of_location,lng,lat) 
--FROM '/Users/Harsh/Desktop/Uber_Movement/geocoded_centroids.csv' HEADER DELIMITER ',' CSV;

--put the origin geocodes there.
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

--put the destination geocodes for the final table
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

--COPY uber.mumbai_weekends_hourly_with_origin_destination TO '/Users/Harsh/Desktop/Uber_Movement/mumbai_weekends_hourly_OD.csv' DELIMITER ',' CSV HEADER;

ALTER TABLE uber.mumbai_weekdays_2016q1_with_od ADD COLUMN time_period INTEGER;
UPDATE  uber.mumbai_weekdays_2016q1_with_od SET  time_period=1;

--drop the unneccessary tables
DROP TABLE uber.mumbai_weekdays_2016q1;
DROP TABLE uber.mumbai_weekdays_2016q1_with_origin;

--2016 Q2
CREATE TABLE uber.mumbai_weekdays_2016q2
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
COPY uber.mumbai_weekdays_2016q2(sourceid,dstid,hod,mean_travel_time,standard_deviation_travel_time,geometric_mean_travel_time,geometric_standard_deviation_travel_time) 
FROM '/Users/Harsh/Desktop/Uber_Movement/Uber_Movement/mumbai-hexclusters-2016-2-OnlyWeekdays-HourlyAggregate.csv' HEADER DELIMITER ',' CSV;

--put the origin geocodes there.
SELECT	
 a.*,
 b.lng AS lng_o,
 b.lat as lat_o
INTO TABLE uber.mumbai_weekdays_2016q2_with_origin
FROM
 uber.mumbai_weekdays_2016q2 AS a
JOIN uber.mumbai_centroids AS b
ON a.sourceid=b.id_of_location
ORDER BY
a.sourceid;

--put the destination geocodes for the final table
SELECT	
 a.*,
 b.lng AS lng_d,
 b.lat as lat_d
INTO TABLE uber.mumbai_weekdays_2016q2_with_od
FROM
 uber.mumbai_weekdays_2016q2_with_origin AS a
JOIN uber.mumbai_centroids AS b
ON a.dstid=b.id_of_location
ORDER BY
a.sourceid;

--COPY uber.mumbai_weekends_hourly_with_origin_destination TO '/Users/Harsh/Desktop/Uber_Movement/mumbai_weekends_hourly_OD.csv' DELIMITER ',' CSV HEADER;

ALTER TABLE uber.mumbai_weekdays_2016q2_with_od ADD COLUMN time_period INTEGER;
UPDATE  uber.mumbai_weekdays_2016q2_with_od SET  time_period=2;

--drop the unneccessary tables
DROP TABLE uber.mumbai_weekdays_2016q2;
DROP TABLE uber.mumbai_weekdays_2016q2_with_origin;

--2016 Q3
CREATE TABLE uber.mumbai_weekdays_2016q3
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
COPY uber.mumbai_weekdays_2016q3(sourceid,dstid,hod,mean_travel_time,standard_deviation_travel_time,geometric_mean_travel_time,geometric_standard_deviation_travel_time) 
FROM '/Users/Harsh/Desktop/Uber_Movement/Uber_Movement/mumbai-hexclusters-2016-3-OnlyWeekdays-HourlyAggregate.csv' HEADER DELIMITER ',' CSV;

--put the origin geocodes there.
SELECT	
 a.*,
 b.lng AS lng_o,
 b.lat as lat_o
INTO TABLE uber.mumbai_weekdays_2016q3_with_origin
FROM
 uber.mumbai_weekdays_2016q3 AS a
JOIN uber.mumbai_centroids AS b
ON a.sourceid=b.id_of_location
ORDER BY
a.sourceid;

--put the destination geocodes for the final table
SELECT	
 a.*,
 b.lng AS lng_d,
 b.lat as lat_d
INTO TABLE uber.mumbai_weekdays_2016q3_with_od
FROM
 uber.mumbai_weekdays_2016q3_with_origin AS a
JOIN uber.mumbai_centroids AS b
ON a.dstid=b.id_of_location
ORDER BY
a.sourceid;

--COPY uber.mumbai_weekends_hourly_with_origin_destination TO '/Users/Harsh/Desktop/Uber_Movement/mumbai_weekends_hourly_OD.csv' DELIMITER ',' CSV HEADER;

ALTER TABLE uber.mumbai_weekdays_2016q3_with_od ADD COLUMN time_period INTEGER;
UPDATE  uber.mumbai_weekdays_2016q3_with_od SET  time_period=3;
DROP TABLE uber.mumbai_weekdays_2016q3;
DROP TABLE uber.mumbai_weekdays_2016q3_with_origin;




--drop the unneccessary tables
DROP TABLE uber.mumbai_weekdays_2016q2;
DROP TABLE uber.mumbai_weekdays_2016q2_with_origin;


--put the origin geocodes there.
SELECT	
 a.*,
 b.lng AS lng_o,
 b.lat as lat_o
INTO TABLE uber.mumbai_weekday_hourly_with_origin
FROM
 uber.mumbai_weekday_hourly AS a
JOIN uber.mumbai_centroids AS b
ON a.sourceid=b.id_of_location
ORDER BY
a.sourceid;

DROP TABLE uber.mumbai_weekday_hourly;

--put the destination geocodes for the final table
SELECT	
 a.*,
 b.lng AS lng_d,
 b.lat as lat_d
INTO TABLE uber.mumbai_weekday_hourly_with_od
FROM
 uber.mumbai_weekday_hourly_with_origin AS a
JOIN uber.mumbai_centroids AS b
ON a.dstid=b.id_of_location
ORDER BY
a.sourceid;

