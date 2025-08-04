{{ config(tags = ['geolocation']) }}
WITH source AS (

    SELECT * FROM {{ source('csv_input', 'olist_geolocation') }}

),

deduplicated_geolocations AS (

    SELECT
        -- The only relationship to customer and seller is geolocation_zip_code_prefix,
        -- so we dedup on it to ensure unique entries.
        geolocation_zip_code_prefix::integer AS zip_code_prefix,
        geolocation_lat::float AS latitude,
        geolocation_lng::float AS longitude,
        row_number() OVER (PARTITION BY geolocation_zip_code_prefix) AS row_num,
        upper(geolocation_city) AS city,
        upper(geolocation_state) AS state

    FROM source

)
SELECT
    zip_code_prefix,
    latitude,
    longitude,
    city,
    state
FROM deduplicated_geolocations
WHERE row_num = 1
