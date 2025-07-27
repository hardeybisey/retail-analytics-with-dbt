{{ config(
    tags = ['orders'],
    materialized='incremental',
    unique_key=['order_id', 'order_item_id'],
    incremental_strategy='merge',
    )
 }}

with source as (

    select * from {{ source('csv_input', 'olist_order_items') }}

),

renamed as (

    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        price::float as item_price,
        freight_value::float as freight_price,
        shipping_limit_date::date as shipping_limit_date
    from source

)

select * from renamed
