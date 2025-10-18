{{ config(
    tags = ['order'],
    )
 }}

WITH source AS (

    SELECT * FROM {{ source('csv_input', 'orders') }}
),

deduplicated_orders AS (

    SELECT
    order_id,
    customer_id,
    upper(order_status) AS order_status,
    order_purchase_date::date AS order_date,
    order_approved_at::date AS order_approved_date,
    order_delivered_carrier_date::date AS delivered_to_carrier_date,
    order_delivered_customer_date::date AS delivered_to_customer_date,
    order_estimated_delivery_date::date AS estimated_delivery_date,
    row_number() OVER (PARTITION BY order_id) AS row_num
    FROM source
)

SELECT
    order_id,
    customer_id,
    order_status,
    order_date,
    order_approved_date,
    delivered_to_carrier_date,
    delivered_to_customer_date,
    estimated_delivery_date
FROM deduplicated_orders
WHERE row_num = 1
