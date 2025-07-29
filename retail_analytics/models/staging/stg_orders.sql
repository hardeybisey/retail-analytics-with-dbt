{{ config(
    tags = ['orders'],
    )
 }}

WITH source AS (

    SELECT * FROM {{ source('csv_input', 'olist_orders') }}
),

renamed AS (

    SELECT
        order_id,
        customer_id,
        order_purchase_timestamp::timestamp AS order_timestamp,
        order_approved_at::date AS payment_approved_date,
        order_delivered_carrier_date::date AS delivered_to_carrier_date,
        order_delivered_customer_date::date AS delivered_to_customer_date,
        order_estimated_delivery_date::date AS estimated_delivery_date,
        upper(order_status) AS order_status

    FROM source

)

SELECT * FROM renamed
