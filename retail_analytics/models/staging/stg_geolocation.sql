{{ config(tags = ['geolocation']) }}
with source as (

    select * from {{ source('csv_input', 'olist_geolocation') }}

),

renamed as (

    select
        geolocation_zip_code_prefix::integer as zip_code_prefix,
        geolocation_lat::float as latitude,
        geolocation_lng::float as longitude,
        geolocation_city as city,
        geolocation_state as state

    from source

)

select * from renamed
