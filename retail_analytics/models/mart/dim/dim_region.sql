{{ config(tags = ['geolocation']) }}
WITH base AS (

    SELECT
        {{ dbt_utils.generate_surrogate_key(["zip_code_prefix"]) }} AS region_key,
        zip_code_prefix,
        latitude,
        longitude,
        city,
        state

    FROM {{ ref('stg_geolocation') }}
)

SELECT
    region_key,
    zip_code_prefix,
    latitude,
    longitude,
    city,
    state
FROM base
