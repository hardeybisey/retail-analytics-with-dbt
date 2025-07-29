{{ config(tags = ['geolocation']) }}
WITH source AS (

    SELECT * FROM {{ source('csv_input', 'olist_geolocation') }}

),

renamed AS (

    SELECT
        geolocation_zip_code_prefix::integer AS zip_code_prefix,
        geolocation_lat::float AS latitude,
        geolocation_lng::float AS longitude,
        upper(geolocation_city) AS city,
        upper(geolocation_state) AS state

    FROM source

)

SELECT * FROM renamed
