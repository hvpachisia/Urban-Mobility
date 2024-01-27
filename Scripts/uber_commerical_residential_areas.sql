--taking only peak hour travel times (for both AM and PM)
SELECT
*
INTO uber.mumbai_weekday_peak_hours
FROM
uber.mumbai_weekday_hourly_with_od
WHERE
(hod=8) OR (hod=9) OR (hod=18) OR (hod=19);

-- taking only Commercial Areas
SELECT
*
INTO uber.mumbai_weekday_commercial_areas
FROM
uber.mumbai_weekday_peak_hours
WHERE
((sourceid=182 AND dstid=196) OR (sourceid=196 AND dstid=182)) OR
((sourceid=182 AND dstid=357) OR (sourceid=357 AND dstid=182)) OR
((sourceid=182 AND dstid=382) OR (sourceid=382 AND dstid=182)) OR
((sourceid=182 AND dstid=576) OR (sourceid=576 AND dstid=182));
--exporting the commerical areas into a CSV File
COPY uber.mumbai_weekday_commerical_areas TO '/Users/Harsh/Desktop/Uber_Movement/mumbai_weekday_commerical_areas.csv' DELIMITER ',' CSV HEADER;

-- taking only Residential Areas
SELECT
DISTINCT *
INTO uber.mumbai_weekday_residential_areas
FROM
uber.mumbai_weekday_peak_hours
WHERE
((sourceid=182 AND dstid=265) OR (sourceid=265 AND dstid=182)) OR
((sourceid=182 AND dstid=577) OR (sourceid=577 AND dstid=182)) OR
((sourceid=182 AND dstid=598) OR (sourceid=598 AND dstid=182)) OR
((sourceid=182 AND dstid=403) OR (sourceid=403 AND dstid=182));

SELECT
DISTINCT *
--INTO uber.mumbai_weekday_residential_areas_final
FROM
uber.mumbai_weekday_residential_areas
ORDER BY time_period;
--exporting the commerical areas into a CSV File
COPY uber.mumbai_weekday_residential_areas TO '/Users/Harsh/Desktop/Uber_Movement/mumbai_weekday_residential_areas.csv' DELIMITER ',' CSV HEADER;
					  
								  
--remove duplicates and reimport the file								  
CREATE TABLE uber.mumbai_weekday_commerical_areas
(
  sourceid bigint,
  dstid bigint,
  hod int,
  mean_travel_time numeric(10,3),
  standard_deviation_travel_time numeric(10,3),
  geometric_mean_travel_time numeric(10,3),
  geometric_standard_deviation_travel_time numeric(10,3),
  time_period integer,
  lng_o numeric (11,9),
  lat_o numeric (11,9),
  lng_d numeric (11,9),
  lat_d numeric (11,9)
);

COPY uber.mumbai_weekday_commerical_areas(sourceid,dstid,hod,mean_travel_time,standard_deviation_travel_time,geometric_mean_travel_time,geometric_standard_deviation_travel_time,
										 time_period, lng_o, lat_o, lng_d, lat_d) 
FROM '/Users/Harsh/Desktop/Uber_Movement/mumbai_weekday_commerical_areas.csv' HEADER DELIMITER ',' CSV;

