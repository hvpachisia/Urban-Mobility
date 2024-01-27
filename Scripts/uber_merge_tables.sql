CREATE TABLE uber.mumbai_weekends_hourly
(
  sourceid bigint,
  dstid bigint,
  hod int,
  mean_travel_time numeric(10,3),
  standard_deviation_travel_time numeric(10,3),
  geometric_mean_travel_time numeric(10,3),
  geometric_standard_deviation_travel_time numeric(10,3)
)


COPY uber.mumbai_weekends_hourly(sourceid,dstid,hod,mean_travel_time,standard_deviation_travel_time,geometric_mean_travel_time,geometric_standard_deviation_travel_time) 
FROM '/Users/Harsh/Desktop/Uber_Movement/mumbai-hexclusters-2018-1-OnlyWeekends-HourlyAggregate.csv' HEADER DELIMITER ',' CSV;

CREATE TABLE uber.mumbai_centroids(
  id_of_location bigint,
  lng numeric(11,9),
  lat numeric(11,9)
)

COPY uber.mumbai_centroids(id_of_location,lng,lat) 
FROM '/Users/Harsh/Desktop/Uber_Movement/geocoded_centroids.csv' HEADER DELIMITER ',' CSV;

SELECT
*
INTO uber.mumbai_weekends_hourly_ordered
FROM
uber.mumbai_weekends_hourly
ORDER BY
sourceid;

SELECT	
 a.*,
 b.lng AS lng_o,
 b.lat as lat_o
INTO TABLE uber.mumbai_weekends_hourly_with_origin
FROM
 uber.mumbai_weekends_hourly_ordered AS a
JOIN uber.mumbai_centroids AS b
ON a.sourceid=b.id_of_location
ORDER BY
a.sourceid;

SELECT	
 a.*,
 b.lng AS lng_d,
 b.lat as lat_d
INTO TABLE uber.mumbai_weekends_hourly_with_origin_destination
FROM
 uber.mumbai_weekends_hourly_with_origin AS a
JOIN uber.mumbai_centroids AS b
ON a.dstid=b.id_of_location
ORDER BY
a.sourceid;

COPY uber.mumbai_weekends_hourly_with_origin_destination TO '/Users/Harsh/Desktop/Uber_Movement/mumbai_weekends_hourly_OD.csv' DELIMITER ',' CSV HEADER;
