--Getting the free flow and peak hours trips for each quarter
SELECT
*
INTO uber.mumbai_2018q3_peak_freeflow_hours
FROM
uber.mumbai_weekday_hourly_with_od
WHERE
(time_period=11 AND hod=2) OR (time_period=11 AND hod=3)
OR (time_period=11 AND hod=8) OR (time_period=11 AND hod=9)
OR (time_period=11 AND hod=18) OR (time_period=11 AND hod=19);

--average of mean_travel_time in peak hours and free-flow hours
SELECT
AVG(mean_travel_time)
FROM 
uber.mumbai_2018q3_peak_freeflow_hours
WHERE
(hod=18) OR (hod=19);