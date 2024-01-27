--only morning peak hours
SELECT
*
INTO uber.mumbai_weekday_commerical_areas_am
FROM
uber.mumbai_weekday_commerical_areas
WHERE
(hod=8) OR (hod=9);

--only evening peak hours
SELECT
*
INTO uber.mumbai_weekday_commerical_areas_pm
FROM
uber.mumbai_weekday_commerical_areas
WHERE
(hod=18) OR (hod=19);
--from BKC to all commerical areas average morning peak hours
SELECT
sourceid,
dstid,
time_period,
AVG(mean_travel_time) OVER (partition by time_period ORDER BY dstid) AS average_travel_time,
lng_o,
lat_o,
lng_d,
lat_d
INTO uber.mumbai_weekday_BKC_to_commerical_am
FROM
uber.mumbai_weekday_commerical_areas_am
WHERE
sourceid=182;

--from all commerical areas to BKC -average morning peak hours
SELECT
sourceid,
dstid,
time_period,
AVG(mean_travel_time) OVER (partition by time_period ORDER BY sourceid) AS average_travel_time,
lng_o,
lat_o,
lng_d,
lat_d
INTO uber.mumbai_weekday_commerical_to_BKC_am
FROM
uber.mumbai_weekday_commerical_areas_am
WHERE
sourceid!=182;

--from BKC to all commerical areas average evening peak hours
SELECT
sourceid,
dstid,
time_period,
AVG(mean_travel_time) OVER (partition by time_period ORDER BY dstid) AS average_travel_time,
lng_o,
lat_o,
lng_d,
lat_d
INTO uber.mumbai_weekday_BKC_to_commerical_pm
FROM
uber.mumbai_weekday_commerical_areas_pm
WHERE
sourceid=182;

--from all commerical areas to BKC -average evening peak hours
SELECT
sourceid,
dstid,
time_period,
AVG(mean_travel_time) OVER (partition by time_period ORDER BY sourceid) AS average_travel_time,
lng_o,
lat_o,
lng_d,
lat_d
INTO uber.mumbai_weekday_commerical_to_BKC_pm
FROM
uber.mumbai_weekday_commerical_areas_pm
WHERE
sourceid!=182;

--BKC to Nariman Point morning and evening average peak hours
SELECT
a.sourceid,
a.dstid,
a.time_period,
a.average_travel_time as morning_travel_time,
b.average_travel_time as evening_travel_time,
a.lng_o,
a.lat_o,
a.lng_d,
a.lat_d
FROM
uber.mumbai_weekday_BKC_to_commerical_am AS a
JOIN
uber.mumbai_weekday_BKC_to_commerical_pm AS b
ON
a.sourceid=b.sourceid
WHERE
(a.sourceid=182 AND a.dstid=382) OR (s.sourceid=182 AND s.dstid=382);


