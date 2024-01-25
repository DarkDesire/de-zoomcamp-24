# Useful Scripts

This README provides essential scripts and instructions to set up and use a Docker-based environment for working with PostgreSQL and inserting data into tables. Follow these steps to get started:

## Step 1: Create a Custom Docker Network

First, create a custom Docker network that will be used for container and Docker Compose communication:

```bash
docker create network pg-network
```

## Step 2: Start the Docker Cluster
Start the Docker cluster using Docker Compose. This will launch the PostgreSQL database and any other services defined in your Docker Compose file:
```bash
docker compose up -d
```

## Step 3: Build the Docker Image
Build a Docker image named dezoomcamp24:latest using the provided Dockerfile:
```bash
docker build -t dezoomcamp24:latest .
```

Step 4: Run Docker Container to Insert Data into a Table
To insert data into a specific table within your PostgreSQL database, use the following command pattern. Replace the placeholders with your actual database details and CSV file path:
```bash
docker run -it \
--network pg-network \
dezoomcamp24:latest \
--user=root \
--password=root \
--host=pgdatabase \
--port=5432 \
--db=ny_taxi \
--table=yellow_taxi_data \
--uri=data/green_tripdata_2019-09.csv
```

```bash
docker run -it \
--network pg-network \
dezoomcamp24:latest \
--user=root \
--password=root \
--host=pgdatabase \
--port=5432 \
--db=ny_taxi \
--table=taxi_zone_data \
--uri=data/taxi+_zone_lookup.csv
```