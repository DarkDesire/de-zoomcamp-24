-- Creating schema 
CREATE SCHEMA IF NOT EXISTS taxi_rides;

-- Creating external table referring to GCS path
CREATE OR REPLACE EXTERNAL TABLE `taxi_rides.green_taxi_2022_tripdata_external`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://homework-3-de-zoomcamp-24-bucket/2022_green_taxi_trip_parquet/*.parquet']
);

-- Check green taxi trip data
SELECT * FROM `homework-3-de-zoomcamp-24.taxi_rides.green_taxi_2022_tripdata_external` limit 10;

-- Create a non partitioned table from external table
CREATE TABLE IF NOT EXISTS `homework-3-de-zoomcamp-24.taxi_rides.green_taxi_2022_tripdata_non_partitioned` AS
SELECT * FROM `homework-3-de-zoomcamp-24.taxi_rides.green_taxi_2022_tripdata_external`;

-- Create a partitioned table from external table
CREATE TABLE IF NOT EXISTS `homework-3-de-zoomcamp-24.taxi_rides.green_taxi_2022_tripdata_partitioned`
PARTITION BY
  DATE(lpep_pickup_datetime) AS
SELECT * FROM `homework-3-de-zoomcamp-24.taxi_rides.green_taxi_2022_tripdata_external`;

-- Q2.
-- Internal Table
-- This query will process 6.41 MB when run.
SELECT DISTINCT(PULocationID)
FROM `homework-3-de-zoomcamp-24.taxi_rides.green_taxi_2022_tripdata_non_partitioned`;

-- External Table
-- WARNING: Could not compute bytes processed estimate for script.
SELECT DISTINCT(PULocationID)
FROM `homework-3-de-zoomcamp-24.taxi_rides.green_taxi_2022_tripdata_external`;

-- Q3.
SELECT COUNT(*) 
FROM `homework-3-de-zoomcamp-24.taxi_rides.green_taxi_2022_tripdata_partitioned`
WHERE fare_amount = 0;

-- Q4.
-- Create a interl partitioned table+clustered table from external table
CREATE TABLE IF NOT EXISTS `homework-3-de-zoomcamp-24.taxi_rides.green_taxi_2022_tripdata_partitioned_clustered`
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PULocationID AS
SELECT * FROM `homework-3-de-zoomcamp-24.taxi_rides.green_taxi_2022_tripdata_external`;

-- Q5.
--Question 5:
--Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive)

-- internal non partitioned
-- This query will process 12.82 MB when run.
SELECT DISTINCT(PULocationID)
FROM `homework-3-de-zoomcamp-24.taxi_rides.green_taxi_2022_tripdata_non_partitioned`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

-- internal partitioned clustered
-- This query will process 1.12 MB when run.
SELECT DISTINCT(PULocationID)
FROM `homework-3-de-zoomcamp-24.taxi_rides.green_taxi_2022_tripdata_partitioned_clustered`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

-- Q6.
SELECT table_name, ddl
FROM `homework-3-de-zoomcamp-24.taxi_rides`.INFORMATION_SCHEMA.TABLES
where table_name = 'green_taxi_2022_tripdata_external';

-- Q8
-- because meta contains information about the table
SELECT count(*) FROM `homework-3-de-zoomcamp-24.taxi_rides.green_taxi_2022_tripdata_non_partitioned`;
