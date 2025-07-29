{{ config(tags = ['order']) }}
WITH orders_base AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(["order_id"]) }} AS order_key,
        order_id,
        customer_id,
        order_timestamp,
        payment_approved_date,
        delivered_to_carrier_date,
        delivered_to_customer_date,
        estimated_delivery_date,
        order_status
    FROM {{ ref('stg_orders') }}
),

order_enriched AS (
    SELECT
        ob.order_key,
        cb.customer_key,
        ob.order_id,
        oib.item_count,
        oib.total_order_price,
        oib.total_freight_price,
        oib.min_shipping_limit_date,
        oib.max_shipping_limit_date,
        ob.order_timestamp,
        ob.payment_approved_date,
        ob.delivered_to_carrier_date,
        ob.delivered_to_customer_date,
        ob.estimated_delivery_date,
        ob.order_status
    FROM orders_base AS ob
    LEFT JOIN {{ ref('int_order_item_aggregates') }} AS oib ON ob.order_id = oib.order_id
    LEFT JOIN {{ ref('dim_customer') }} AS cb ON
        ob.customer_id = cb.customer_id
        AND ob.order_timestamp >= cb.valid_from AND (ob.order_timestamp < cb.valid_to OR cb.valid_to IS null)
)

SELECT * FROM order_enriched
