{{ config(tags = ['sellers']) }}

with source as (

    select * from {{ source('csv_input', 'olist_sellers') }}

),

renamed as (

    select
        seller_id,
        seller_zip_code_prefix::integer as zip_code_prefix,
        upper(seller_city) as city,
        upper(seller_state) as state

    from source

)

select * from renamed
