--only morning peak hours
SELECT
*
INTO uber.mumbai_weekday_residential_areas_am
FROM
uber.mumbai_weekday_residential_areas
WHERE
(hod=8) OR (hod=9);

--only evening peak hours
SELECT
*
INTO uber.mumbai_weekday_residential_areas_pm
FROM
uber.mumbai_weekday_residential_areas
WHERE
(hod=18) OR (hod=19);
--from BKC to all residential areas average morning peak hours
SELECT
sourceid,
dstid,
time_period,
AVG(mean_travel_time) OVER (partition by time_period ORDER BY dstid) AS average_travel_time,
lng_o,
lat_o,
lng_d,
lat_d)
INTO uber.mumbai_weekday_BKC_to_residential_am
FROM
uber.mumbai_weekday_residential_areas_am
WHERE
sourceid=182;

SELECT
DISTINCT *
INTO uber.mumbai_weekday_BKC_to_residential_am_final
FROM
uber.mumbai_weekday_BKC_to_residential_am;

DROP TABLE uber.mumbai_weekday_BKC_to_residential_am;

--from all residential areas to BKC -average morning peak hours
SELECT
sourceid,
dstid,
time_period,
AVG(mean_travel_time) OVER (partition by time_period ORDER BY sourceid) AS average_travel_time,
lng_o,
lat_o,
lng_d,
lat_d
INTO uber.mumbai_weekday_residential_to_BKC_am
FROM
uber.mumbai_weekday_residential_areas_am
WHERE
sourceid!=182;

SELECT
DISTINCT *
INTO uber.mumbai_weekday_residential_to_BKC_am_final
FROM
uber.mumbai_weekday_residential_to_BKC_am;

DROP TABLE uber.mumbai_weekday_residential_to_BKC_am;
--from BKC to all residential areas average evening peak hours
SELECT
sourceid,
dstid,
time_period,
AVG(mean_travel_time) OVER (partition by time_period ORDER BY dstid) AS average_travel_time,
lng_o,
lat_o,
lng_d,
lat_d
INTO uber.mumbai_weekday_BKC_to_residential_pm
FROM
uber.mumbai_weekday_residential_areas_pm
WHERE
sourceid=182;

SELECT
DISTINCT *
INTO uber.mumbai_weekday_BKC_to_residential_pm_final
FROM
uber.mumbai_weekday_BKC_to_residential_pm;

DROP TABLE uber.mumbai_weekday_BKC_to_residential_pm;

--from all residential areas to BKC -average evening peak hours
SELECT
sourceid,
dstid,
time_period,
AVG(mean_travel_time) OVER (partition by time_period ORDER BY sourceid) AS average_travel_time,
lng_o,
lat_o,
lng_d,
lat_d
INTO uber.mumbai_weekday_residential_to_BKC_pm
FROM
uber.mumbai_weekday_residential_areas_pm
WHERE
sourceid!=182;

SELECT
DISTINCT *
INTO uber.mumbai_weekday_residential_to_BKC_pm_final
FROM
uber.mumbai_weekday_residential_to_BKC_pm;

DROP TABLE uber.mumbai_weekday_residential_to_BKC_pm;
COPY uber.mumbai_weekday_BKC_to_residential_am_final TO '/Users/Harsh/Desktop/Uber_Movement/mumbai_weekday_BKC_to_residential_am_final.csv' DELIMITER ',' CSV HEADER;
COPY uber.mumbai_weekday_residential_to_BKC_am_final TO '/Users/Harsh/Desktop/Uber_Movement/mumbai_weekday_residential_to_BKC_am_final.csv' DELIMITER ',' CSV HEADER;
COPY uber.mumbai_weekday_BKC_to_residential_pm_final TO '/Users/Harsh/Desktop/Uber_Movement/mumbai_weekday_BKC_to_residential_pm_final.csv' DELIMITER ',' CSV HEADER;
COPY uber.mumbai_weekday_residential_to_BKC_pm_final TO '/Users/Harsh/Desktop/Uber_Movement/mumbai_weekday_residential_to_BKC_pm_final.csv' DELIMITER ',' CSV HEADER;

