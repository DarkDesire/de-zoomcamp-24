{{ config(materialized='view') }}

with 
tripdata as (
    select * from {{ source('staging', 'fhv_tripdata') }}
    where DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31'
)
select * FROM tripdata
-- dbt build --select <model.sql> --vars '{'is_test_run: false}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}