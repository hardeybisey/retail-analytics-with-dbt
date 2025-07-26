{{ config(tags = ['orders']) }}

with source as (

    select * from {{ source('csv_input', 'olist_orders') }}

),

renamed as (

    select
        order_id,
        customer_id,
        order_purchase_timestamp::timestamp as purchase_timestamp,
        order_approved_at::timestamp as approved_at,
        order_delivered_carrier_date::timestamp as delivered_carrier_date,
        order_delivered_customer_date::timestamp as delivered_customer_date,
        order_estimated_delivery_date::timestamp as estimated_delivery_date,
        upper(order_status) as order_status

    from source

)

select * from renamed
