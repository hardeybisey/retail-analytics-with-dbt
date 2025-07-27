{{ config(tags = ['location']) }}
with base as (

    select
        {{ dbt_utils.generate_surrogate_key(["zip_code_prefix"]) }} as geolocation_key,
        zip_code_prefix,
        latitude,
        longitude,
        city,
        state
    from {{ ref('stg_geolocation') }}
)

select
    geolocation_key,
    zip_code_prefix,
    latitude,
    longitude,
    city,
    state
from base
