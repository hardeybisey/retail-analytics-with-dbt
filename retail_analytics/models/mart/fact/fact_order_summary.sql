{{
    config(tags = ['order'])
}}
WITH order_item_aggregate AS (
    SELECT
        order_id,
        sum(item_value) AS total_order_value,
        sum(freight_value) AS total_freight_value,
        min(shipping_limit_date) AS min_shipping_limit_date,
        max(shipping_limit_date) AS max_shipping_limit_date,
        count(order_item_id) AS item_count
    FROM {{ ref('stg_order_items') }}
    GROUP BY order_id

),

orders_base AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        order_approved_date,
        delivered_to_carrier_date,
        delivered_to_customer_date,
        estimated_delivery_date,
        order_status
    FROM {{ ref('stg_orders') }}

),

order_enriched AS (
    SELECT
        cb.customer_sk,
        ob.order_id,
        order_item_agg.item_count,
        order_item_agg.total_order_value,
        order_item_agg.total_freight_value,
        ob.order_status,

        -- Joining with date dimensions
        order_date.date_day AS order_date_key,
        min_shipping_limit.date_day AS min_shipping_limit_date_key,
        max_shipping_limit.date_day AS max_shipping_limit_date_key,
        delivered_to_carrier.date_day AS delivered_to_carrier_date_key,
        delivered_to_customer.date_day AS delivered_to_customer_date_key,
        estimated_delivery.date_day AS estimated_delivery_date_key,
        order_approved.date_day AS order_approved_date_key

    FROM orders_base AS ob
    LEFT JOIN {{ ref('dim_customer') }} AS cb
        ON
            ob.customer_id = cb.customer_id
            AND ob.order_date >= cb.customer_valid_from_date AND (ob.order_date < cb.customer_valid_to_date OR cb.customer_valid_to_date IS null)
    LEFT JOIN order_item_aggregate AS order_item_agg ON ob.order_id = order_item_agg.order_id
    LEFT JOIN {{ ref('dim_date') }} AS order_date ON ob.order_date = order_date.date_day
    LEFT JOIN {{ ref('dim_date') }} AS order_approved ON ob.order_approved_date = order_approved.date_day
    LEFT JOIN {{ ref('dim_date') }} AS delivered_to_carrier ON ob.delivered_to_carrier_date = delivered_to_carrier.date_day
    LEFT JOIN {{ ref('dim_date') }} AS delivered_to_customer ON ob.delivered_to_customer_date = delivered_to_customer.date_day
    LEFT JOIN {{ ref('dim_date') }} AS estimated_delivery ON ob.estimated_delivery_date = estimated_delivery.date_day
    LEFT JOIN {{ ref('dim_date') }} AS min_shipping_limit ON order_item_agg.min_shipping_limit_date = min_shipping_limit.date_day
    LEFT JOIN {{ ref('dim_date') }} AS max_shipping_limit ON order_item_agg.max_shipping_limit_date = max_shipping_limit.date_day

)

SELECT * FROM order_enriched
