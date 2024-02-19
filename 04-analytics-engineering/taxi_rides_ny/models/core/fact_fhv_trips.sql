{{ config(materialized="table") }}

with
    fhv_tripdata as (
        select *, 'FHV' as service_type from {{ ref("stg_fhv_tripdata") }}
    ),
    dim_zones as (select * from {{ ref("dim_zones") }} where borough != 'Unknown')
select fhv_tripdata.PUlocationID, fhv_tripdata.DOlocationID from fhv_tripdata
inner join
    dim_zones as pickup_zone on fhv_tripdata.PUlocationID = pickup_zone.locationid
inner join
    dim_zones as dropoff_zone on fhv_tripdata.DOlocationID = dropoff_zone.locationid
