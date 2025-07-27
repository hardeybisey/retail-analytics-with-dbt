{{ config(
    tags = ['orders'],
    )
 }}

with source as (

    select * from {{ source('csv_input', 'olist_orders') }}
),

renamed as (

    select
        order_id,
        customer_id,
        order_purchase_timestamp::timestamp as order_timestamp,
        order_approved_at::date as payment_approved_date,
        order_delivered_carrier_date::date as delivered_to_carrier_date,
        order_delivered_customer_date::date as delivered_to_customer_date,
        order_estimated_delivery_date::date as estimated_delivery_date,
        upper(order_status) as order_status

    from source

)

select * from renamed
