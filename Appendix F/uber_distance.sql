-- Getting the added distance between each lat-long pair and the cumulative distance till that lat-long pair  
-- on the identified route using PostGIS.
-- Example: BKC to Borivali.

CREATE TABLE uber.mumbai_BKC_to_Borivali_distances
(
  id int,
  lon numeric(11,9),
  lat numeric(11,9)
);

--import the table
COPY uber.mumbai_BKC_to_Borivali_distances(id, lon,lat)
FROM '/Users/Harsh/Desktop/Uber_Movement/mumbai/BKC/BKC_to_Borivali_route_coords.csv' CSV HEADER DELIMITER ',';

--add geohash of lat lon
alter table uber.mumbai_BKC_to_Borivali_distances 
add column where_is geography (point, 4326); 

UPDATE uber.mumbai_BKC_to_Borivali_distances
SET where_is=ST_SetSRID(ST_MakePoint(lon, lat), 4326);

--
SELECT a.*,
array_agg(where_is) OVER( ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS prev_place
INTO uber.mumbai_BKC_to_Borivali_distances_rough
FROM uber.mumbai_BKC_to_Borivali_distances AS a;

SELECT a.*,
((ST_Distance(where_is, prev_place[1]))/1000) AS km_travelled
INTO uber.mumbai_BKC_to_Borivali_distances_rough_2
FROM  uber.mumbai_BKC_to_Borivali_distances_rough AS a;
								   
--DROP unneccessary tables
DROP TABLE 	uber.mumbai_BKC_to_Borivali_distances_rough;
DROP TABLE uber.mumbai_BKC_to_Borivali_distances;
--S								   
SELECT
id,
lon,
lat,
km_travelled as added_distance,								   
SUM(km_travelled) OVER(order by id asc rows between unbounded preceding and current row) AS total_distance
INTO uber.mumbai_BKC_to_Borivali_distances
FROM
uber.mumbai_BKC_to_Borivali_distances_rough_2 AS a;
								   
COPY uber.mumbai_BKC_to_Borivali_distances TO '/Users/Harsh/Desktop/Uber_Movement/mumbai/BKC/BKC_to_Borivali.csv' DELIMITER ',' CSV HEADER;

DROP TABLE uber.mumbai_BKC_to_Borivali_distances_rough_2;
DROP TABLE uber.mumbai_BKC_to_Borivali_distances;
								   