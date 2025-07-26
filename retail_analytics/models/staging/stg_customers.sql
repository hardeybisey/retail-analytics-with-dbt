{{ config(tags = ['customers']) }}
with source as (

    select * from {{ source('csv_input', 'olist_customers') }}

),

renamed as (

    select
        customer_unique_id as customer_id,
        customer_id as customer_order_id,
        customer_zip_code_prefix::integer as zip_code_prefix,
        upper(customer_city) as city,
        upper(customer_state) as state

    from source

)

select * from renamed
