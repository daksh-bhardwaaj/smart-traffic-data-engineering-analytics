CREATE DATABASE smart_traffic;
USE smart_traffic;
SHOW TABLES;

CREATE TABLE locations (
    Location_ID VARCHAR(20) PRIMARY KEY,
    Zone_Name VARCHAR(100),
    Road_Type VARCHAR(100),
    Speed_Limit_kmh INT
);

DESCRIBE locations;
SHOW TABLES;


LOAD DATA LOCAL INFILE 'D:/WORK - MAIN/PROJECTS/Smart Traffic Data Engineering & Analytics Pipeline/locations.csv'
INTO TABLE locations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_locations
FROM locations;

SELECT *
FROM locations;

CREATE TABLE traffic_logs (
    Record_ID VARCHAR(20) PRIMARY KEY,
    Timestamp DATETIME,
    Location_ID VARCHAR(20),
    Vehicle_Type VARCHAR(50),
    Speed_kmh DECIMAL(6,2),
    Traffic_Volume INT,
    Weather_Condition VARCHAR(50),
    Lane_Number VARCHAR(50),

    FOREIGN KEY (Location_ID)
        REFERENCES locations(Location_ID)
);

DESCRIBE traffic_logs;


LOAD DATA LOCAL INFILE 'D:/WORK - MAIN/PROJECTS/Smart Traffic Data Engineering & Analytics Pipeline/traffic_logs.csv'
INTO TABLE traffic_logs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT COUNT(*) AS total_traffic_records
FROM traffic_logs;

SELECT *
FROM traffic_logs
LIMIT 5;

SELECT COUNT(*) AS total_locations
FROM locations;

SELECT *
FROM locations;

SELECT
    t.Record_ID,
    t.Location_ID,
    l.Zone_Name,
    l.Road_Type,
    l.Speed_Limit_kmh
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID
LIMIT 10;


SELECT COUNT(DISTINCT Location_ID) AS unique_locations
FROM traffic_logs;


SELECT
    Vehicle_Type,
    COUNT(*) AS total_records
FROM traffic_logs
GROUP BY Vehicle_Type
ORDER BY total_records DESC;

SELECT
    Weather_Condition,
    COUNT(*) AS total_records
FROM traffic_logs
GROUP BY Weather_Condition
ORDER BY total_records DESC;

SELECT
    COUNT(*) AS total_records,
    AVG(Speed_kmh) AS average_speed,
    MIN(Speed_kmh) AS minimum_speed,
    MAX(Speed_kmh) AS maximum_speed,
    AVG(Traffic_Volume) AS average_traffic_volume
FROM traffic_logs;



SELECT
    Location_ID,
    SUM(Traffic_Volume) AS total_traffic_volume
FROM traffic_logs
GROUP BY Location_ID
ORDER BY total_traffic_volume DESC;


SELECT
    Location_ID,
    AVG(Traffic_Volume) AS avg_traffic_volume
FROM traffic_logs
GROUP BY Location_ID
ORDER BY avg_traffic_volume DESC;


SELECT
    Vehicle_Type,
    SUM(Traffic_Volume) AS total_traffic_volume
FROM traffic_logs
GROUP BY Vehicle_Type
ORDER BY total_traffic_volume DESC;


SELECT
    Vehicle_Type,
    ROUND(AVG(Speed_kmh), 2) AS avg_speed
FROM traffic_logs
GROUP BY Vehicle_Type
ORDER BY avg_speed DESC;



SELECT
    l.Zone_Name,
    SUM(t.Traffic_Volume) AS total_traffic_volume
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID
GROUP BY l.Zone_Name
ORDER BY total_traffic_volume DESC;


SELECT
    l.Road_Type,
    ROUND(AVG(t.Speed_kmh), 2) AS avg_speed
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID
GROUP BY l.Road_Type
ORDER BY avg_speed DESC;


SELECT
    l.Road_Type,
    SUM(t.Traffic_Volume) AS total_traffic_volume
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID
GROUP BY l.Road_Type
ORDER BY total_traffic_volume DESC;


SELECT
    l.Zone_Name,
    l.Road_Type,
    ROUND(AVG(t.Speed_kmh), 2) AS avg_speed,
    l.Speed_Limit_kmh
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID
GROUP BY
    l.Zone_Name,
    l.Road_Type,
    l.Speed_Limit_kmh
ORDER BY avg_speed DESC;


SELECT
    MIN(Timestamp) AS earliest_timestamp,
    MAX(Timestamp) AS latest_timestamp
FROM traffic_logs;



SELECT
    Timestamp,
    HOUR(Timestamp) AS traffic_hour
FROM traffic_logs
LIMIT 10;



SELECT
    HOUR(Timestamp) AS traffic_hour,
    SUM(Traffic_Volume) AS total_traffic_volume
FROM traffic_logs
GROUP BY HOUR(Timestamp)
ORDER BY traffic_hour;



SELECT
    HOUR(Timestamp) AS traffic_hour,
    SUM(Traffic_Volume) AS total_traffic_volume
FROM traffic_logs
GROUP BY HOUR(Timestamp)
ORDER BY total_traffic_volume DESC
LIMIT 1;




SELECT
    HOUR(Timestamp) AS traffic_hour,
    Vehicle_Type,
    COUNT(*) AS record_count
FROM traffic_logs
GROUP BY
    HOUR(Timestamp),
    Vehicle_Type
ORDER BY
    traffic_hour,
    record_count DESC;
    
    
    
SELECT
    HOUR(Timestamp) AS traffic_hour,
    Vehicle_Type,
    SUM(Traffic_Volume) AS total_traffic_volume
FROM traffic_logs
GROUP BY
    HOUR(Timestamp),
    Vehicle_Type
ORDER BY
    traffic_hour,
    total_traffic_volume DESC;
    
    
    
SELECT
Weather_Condition,
SUM(Traffic_Volume) AS total_traffic_volume,
ROUND(AVG(Speed_kmh), 2) AS avg_speed
FROM traffic_logs
GROUP BY Weather_Condition
ORDER BY total_traffic_volume DESC;



SELECT
    l.Zone_Name,
    t.Vehicle_Type,
    SUM(t.Traffic_Volume) AS total_traffic_volume
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID
GROUP BY
    l.Zone_Name,
    t.Vehicle_Type
ORDER BY
    l.Zone_Name,
    total_traffic_volume DESC;
    
    
    
SELECT
    Location_ID,
    ROUND(AVG(Traffic_Volume), 2) AS avg_traffic_volume
FROM traffic_logs
GROUP BY Location_ID
HAVING AVG(Traffic_Volume) > 50
ORDER BY avg_traffic_volume DESC;


SELECT
    Vehicle_Type,
    ROUND(AVG(Speed_kmh), 2) AS avg_speed
FROM traffic_logs
GROUP BY Vehicle_Type
HAVING AVG(Speed_kmh) > 48
ORDER BY avg_speed DESC;


SELECT
    Vehicle_Type,
    ROUND(AVG(Speed_kmh), 2) AS avg_speed
FROM traffic_logs
WHERE Weather_Condition = 'rainy'
GROUP BY Vehicle_Type
HAVING AVG(Speed_kmh) > 45
ORDER BY avg_speed DESC;


SELECT
    l.Zone_Name,
    SUM(t.Traffic_Volume) AS total_traffic_volume
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID
GROUP BY l.Zone_Name
HAVING SUM(t.Traffic_Volume) > 10000
ORDER BY total_traffic_volume DESC;



SELECT
    ROUND(AVG(Speed_kmh), 2) AS overall_avg_speed
FROM traffic_logs;



SELECT
    Vehicle_Type,
    ROUND(AVG(Speed_kmh), 2) AS avg_speed
FROM traffic_logs
GROUP BY Vehicle_Type
HAVING AVG(Speed_kmh) > (
    SELECT AVG(Speed_kmh)
    FROM traffic_logs
)
ORDER BY avg_speed DESC;



SELECT
    Location_ID,
    ROUND(AVG(Traffic_Volume), 2) AS avg_traffic_volume
FROM traffic_logs
GROUP BY Location_ID
HAVING AVG(Traffic_Volume) > (
    SELECT AVG(Traffic_Volume)
    FROM traffic_logs
)
ORDER BY avg_traffic_volume DESC;



SELECT
    l.Zone_Name,
    ROUND(AVG(t.Traffic_Volume), 2) AS avg_traffic_volume
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID
GROUP BY l.Zone_Name
HAVING AVG(t.Traffic_Volume) > (
    SELECT AVG(Traffic_Volume)
    FROM traffic_logs
)
ORDER BY avg_traffic_volume DESC;




WITH location_traffic AS (
    SELECT
        Location_ID,
        AVG(Traffic_Volume) AS avg_traffic_volume
    FROM traffic_logs
    GROUP BY Location_ID
)
SELECT
    Location_ID,
    ROUND(avg_traffic_volume, 2) AS avg_traffic_volume
FROM location_traffic
ORDER BY avg_traffic_volume DESC;


WITH location_traffic AS (
    SELECT
        Location_ID,
        AVG(Traffic_Volume) AS avg_traffic_volume
    FROM traffic_logs
    GROUP BY Location_ID
)
SELECT
    l.Zone_Name,
    ROUND(lt.avg_traffic_volume, 2) AS avg_traffic_volume
FROM location_traffic lt
JOIN locations l
    ON lt.Location_ID = l.Location_ID
ORDER BY avg_traffic_volume DESC;


SELECT
    Location_ID,
    ROUND(AVG(Traffic_Volume), 2) AS avg_traffic_volume,
    RANK() OVER (
        ORDER BY AVG(Traffic_Volume) DESC
    ) AS traffic_rank
FROM traffic_logs
GROUP BY Location_ID
ORDER BY traffic_rank;


SELECT
    Vehicle_Type,
    ROUND(AVG(Speed_kmh), 2) AS avg_speed,
    RANK() OVER (
        ORDER BY AVG(Speed_kmh) DESC
    ) AS speed_rank
FROM traffic_logs
GROUP BY Vehicle_Type
ORDER BY speed_rank;



SELECT
    Location_ID,
    ROUND(AVG(Traffic_Volume), 2) AS avg_traffic_volume,
    ROW_NUMBER() OVER (
        ORDER BY AVG(Traffic_Volume) DESC
    ) AS row_num
FROM traffic_logs
GROUP BY Location_ID
ORDER BY row_num;


SELECT
    Vehicle_Type,
    ROUND(AVG(Speed_kmh), 2) AS avg_speed,
    DENSE_RANK() OVER (
        ORDER BY AVG(Speed_kmh) DESC
    ) AS speed_rank
FROM traffic_logs
GROUP BY Vehicle_Type
ORDER BY speed_rank;



SELECT
    HOUR(Timestamp) AS traffic_hour,
    SUM(Traffic_Volume) AS hourly_traffic,
    SUM(SUM(Traffic_Volume)) OVER (
        ORDER BY HOUR(Timestamp)
    ) AS running_total
FROM traffic_logs
GROUP BY HOUR(Timestamp)
ORDER BY traffic_hour;


SELECT
    Vehicle_Type,
    ROUND(AVG(Speed_kmh), 2) AS avg_speed,
    ROUND(AVG(AVG(Speed_kmh)) OVER (), 2) AS overall_avg_speed
FROM traffic_logs
GROUP BY Vehicle_Type;



SELECT
    l.Location_ID,
    l.Zone_Name,
    l.Speed_Limit_kmh,
    ROUND(AVG(t.Speed_kmh), 2) AS avg_speed
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID
GROUP BY
    l.Location_ID,
    l.Zone_Name,
    l.Speed_Limit_kmh
HAVING AVG(t.Speed_kmh) < l.Speed_Limit_kmh
ORDER BY avg_speed;


SELECT
    l.Zone_Name,
    l.Speed_Limit_kmh,
    ROUND(AVG(t.Speed_kmh), 2) AS avg_speed,
    ROUND(
        (AVG(t.Speed_kmh) / l.Speed_Limit_kmh) * 100,
        2
    ) AS speed_utilization_percent
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID
GROUP BY
    l.Zone_Name,
    l.Speed_Limit_kmh
ORDER BY speed_utilization_percent DESC;



WITH vehicle_hourly_traffic AS (
    SELECT
        Vehicle_Type,
        HOUR(Timestamp) AS traffic_hour,
        SUM(Traffic_Volume) AS total_traffic
    FROM traffic_logs
    GROUP BY
        Vehicle_Type,
        HOUR(Timestamp)
),
ranked_hours AS (
    SELECT
        Vehicle_Type,
        traffic_hour,
        total_traffic,
        RANK() OVER (
            PARTITION BY Vehicle_Type
            ORDER BY total_traffic DESC
        ) AS traffic_rank
    FROM vehicle_hourly_traffic
)
SELECT
    Vehicle_Type,
    traffic_hour,
    total_traffic
FROM ranked_hours
WHERE traffic_rank = 1
ORDER BY Vehicle_Type;



WITH location_traffic AS (
    SELECT
        l.Zone_Name,
        t.Location_ID,
        SUM(t.Traffic_Volume) AS total_traffic
    FROM traffic_logs t
    JOIN locations l
        ON t.Location_ID = l.Location_ID
    GROUP BY
        l.Zone_Name,
        t.Location_ID
),
ranked_locations AS (
    SELECT
        Zone_Name,
        Location_ID,
        total_traffic,
        RANK() OVER (
            PARTITION BY Zone_Name
            ORDER BY total_traffic DESC
        ) AS location_rank
    FROM location_traffic
)
SELECT
    Zone_Name,
    Location_ID,
    total_traffic
FROM ranked_locations
WHERE location_rank = 1
ORDER BY Zone_Name;


SELECT
    DATE(Timestamp) AS traffic_date,
    SUM(Traffic_Volume) AS total_traffic_volume
FROM traffic_logs
GROUP BY DATE(Timestamp)
ORDER BY traffic_date;


SELECT
    DAYNAME(Timestamp) AS day_name,
    SUM(Traffic_Volume) AS total_traffic_volume
FROM traffic_logs
GROUP BY DAYNAME(Timestamp)
ORDER BY total_traffic_volume DESC;


SELECT
    Vehicle_Type,
    ROUND(AVG(Speed_kmh), 2) AS avg_speed,
    ROUND(AVG(Traffic_Volume), 2) AS avg_traffic_volume
FROM traffic_logs
WHERE Traffic_Volume > (
    SELECT AVG(Traffic_Volume)
    FROM traffic_logs
)
GROUP BY Vehicle_Type
ORDER BY avg_traffic_volume DESC;



CREATE OR REPLACE VIEW traffic_analysis AS
SELECT
    t.Record_ID,
    t.Timestamp,
    t.Location_ID,
    t.Vehicle_Type,
    t.Speed_kmh,
    t.Traffic_Volume,
    t.Weather_Condition,
    t.Lane_Number,
    l.Zone_Name,
    l.Road_Type,
    l.Speed_Limit_kmh
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID;
    
    
    DESCRIBE traffic_analysis;
    SELECT COUNT(*) AS total_records
FROM traffic_analysis;


CREATE OR REPLACE VIEW location_traffic_summary AS
SELECT
    t.Location_ID,
    l.Zone_Name,
    l.Road_Type,
    l.Speed_Limit_kmh,
    COUNT(*) AS total_records,
    ROUND(AVG(t.Speed_kmh), 2) AS avg_speed,
    ROUND(AVG(t.Traffic_Volume), 2) AS avg_traffic_volume,
    SUM(t.Traffic_Volume) AS total_traffic_volume
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID
GROUP BY
    t.Location_ID,
    l.Zone_Name,
    l.Road_Type,
    l.Speed_Limit_kmh;
    
    SELECT *
FROM location_traffic_summary
ORDER BY total_traffic_volume DESC;



CREATE OR REPLACE VIEW vehicle_traffic_summary AS
SELECT
    Vehicle_Type,
    COUNT(*) AS total_records,
    ROUND(AVG(Speed_kmh), 2) AS avg_speed,
    ROUND(AVG(Traffic_Volume), 2) AS avg_traffic_volume,
    SUM(Traffic_Volume) AS total_traffic_volume
FROM traffic_logs
GROUP BY Vehicle_Type;

SELECT *
FROM vehicle_traffic_summary
ORDER BY total_traffic_volume DESC;



CREATE OR REPLACE VIEW hourly_traffic_summary AS
SELECT
    HOUR(Timestamp) AS traffic_hour,
    COUNT(*) AS total_records,
    SUM(Traffic_Volume) AS total_traffic_volume,
    ROUND(AVG(Speed_kmh), 2) AS avg_speed
FROM traffic_logs
GROUP BY HOUR(Timestamp);


SELECT *
FROM hourly_traffic_summary
ORDER BY traffic_hour;

SELECT COUNT(*) AS total_locations
FROM location_traffic_summary;

SELECT *
FROM location_traffic_summary
ORDER BY Location_ID;


SELECT COUNT(*) AS total_vehicle_types
FROM vehicle_traffic_summary;


SELECT *
FROM vehicle_traffic_summary
ORDER BY total_traffic_volume DESC;


SELECT COUNT(*) AS total_hours
FROM hourly_traffic_summary;


SELECT *
FROM hourly_traffic_summary
ORDER BY traffic_hour;


CREATE OR REPLACE VIEW powerbi_traffic_data AS
SELECT
    t.Record_ID,
    t.Timestamp,
    t.Location_ID,
    t.Vehicle_Type,
    t.Speed_kmh,
    t.Traffic_Volume,
    t.Weather_Condition,
    t.Lane_Number,
    l.Zone_Name,
    l.Road_Type,
    l.Speed_Limit_kmh
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID;
    
    
    SELECT *
FROM powerbi_traffic_data
LIMIT 10;


SELECT COUNT(*) AS total_records
FROM powerbi_traffic_data;




SELECT
    COUNT(*) AS total_records,
    SUM(Speed_kmh IS NULL) AS missing_speed,
    SUM(Traffic_Volume IS NULL) AS missing_traffic_volume,
    SUM(Weather_Condition IS NULL) AS missing_weather,
    SUM(Location_ID IS NULL) AS missing_location
FROM powerbi_traffic_data;

SELECT
    Record_ID,
    COUNT(*) AS record_count
FROM powerbi_traffic_data
GROUP BY Record_ID
HAVING COUNT(*) > 1;


SELECT COUNT(*) AS unmatched_locations
FROM traffic_logs t
LEFT JOIN locations l
    ON t.Location_ID = l.Location_ID
WHERE l.Location_ID IS NULL;


SELECT COUNT(*) AS traffic_records
FROM traffic_logs;


SELECT COUNT(*) AS locations
FROM locations;


SELECT COUNT(*) AS powerbi_records
FROM powerbi_traffic_data;


SHOW FULL TABLES
WHERE Table_type = 'VIEW';



SELECT
    traffic_hour,
    total_traffic_volume,
    avg_speed
FROM hourly_traffic_summary
ORDER BY total_traffic_volume DESC
LIMIT 1;


SELECT
    Location_ID,
    Zone_Name,
    Road_Type,
    total_traffic_volume,
    avg_traffic_volume,
    avg_speed
FROM location_traffic_summary
ORDER BY total_traffic_volume DESC
LIMIT 1;


SELECT
    Vehicle_Type,
    total_traffic_volume,
    avg_traffic_volume,
    avg_speed
FROM vehicle_traffic_summary
ORDER BY total_traffic_volume DESC
LIMIT 1;



SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT Location_ID) AS total_locations,
    COUNT(DISTINCT Vehicle_Type) AS total_vehicle_types,
    ROUND(AVG(Speed_kmh), 2) AS avg_speed,
    SUM(Traffic_Volume) AS total_traffic_volume,
    ROUND(AVG(Traffic_Volume), 2) AS avg_traffic_volume
FROM traffic_logs;


SELECT
    Weather_Condition,
    COUNT(*) AS total_records,
    SUM(Traffic_Volume) AS total_traffic_volume,
    ROUND(AVG(Speed_kmh), 2) AS avg_speed
FROM traffic_logs
GROUP BY Weather_Condition
ORDER BY total_traffic_volume DESC;


SELECT
    l.Road_Type,
    COUNT(*) AS total_records,
    SUM(t.Traffic_Volume) AS total_traffic_volume,
    ROUND(AVG(t.Speed_kmh), 2) AS avg_speed
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID
GROUP BY l.Road_Type
ORDER BY total_traffic_volume DESC;


SELECT
    l.Zone_Name,
    l.Road_Type,
    l.Speed_Limit_kmh,
    ROUND(AVG(t.Speed_kmh), 2) AS avg_speed,
    ROUND(
        l.Speed_Limit_kmh - AVG(t.Speed_kmh),
        2
    ) AS speed_difference
FROM traffic_logs t
JOIN locations l
    ON t.Location_ID = l.Location_ID
GROUP BY
    l.Zone_Name,
    l.Road_Type,
    l.Speed_Limit_kmh
ORDER BY speed_difference DESC;



SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT Location_ID) AS total_locations,
    COUNT(DISTINCT Vehicle_Type) AS total_vehicle_types,
    COUNT(DISTINCT Weather_Condition) AS total_weather_conditions,
    ROUND(AVG(Speed_kmh), 2) AS overall_avg_speed,
    ROUND(AVG(Traffic_Volume), 2) AS overall_avg_traffic,
    SUM(Traffic_Volume) AS total_traffic_volume,
    MIN(Speed_kmh) AS minimum_speed,
    MAX(Speed_kmh) AS maximum_speed
FROM traffic_logs;


