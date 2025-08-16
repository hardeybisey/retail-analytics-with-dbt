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
        {{ dbt_utils.generate_surrogate_key(["order_id"]) }} AS order_key,
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
        ob.order_key,
        cb.customer_key,
        ob.order_id,
        oib.item_count,
        oib.total_order_value,
        oib.total_freight_value,
        ob.order_status,

        -- Joining with date dimensions
        odd.date_day AS order_date_key,
        minsdd.date_day AS min_shipping_limit_date_key,
        maxsdd.date_day AS max_shipping_limit_date_key,
        dtcrdd.date_day AS delivered_to_carrier_date_key,
        dtcsdd.date_day AS delivered_to_customer_date_key,
        edddd.date_day AS estimated_delivery_date_key,
        padd.date_day AS order_approved_date_key

    FROM orders_base AS ob
    LEFT JOIN {{ ref('dim_customer') }} AS cb
        ON
            ob.customer_id = cb.customer_id
            AND ob.order_date >= cb.valid_from_date AND (ob.order_date < cb.valid_to_date OR cb.valid_to_date IS null)
    LEFT JOIN order_item_aggregate AS oib ON ob.order_id = oib.order_id
    LEFT JOIN {{ ref('dim_date') }} AS odd ON ob.order_date = odd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS padd ON ob.order_approved_date = padd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS dtcrdd ON ob.delivered_to_carrier_date = dtcrdd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS dtcsdd ON ob.delivered_to_customer_date = dtcsdd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS edddd ON ob.estimated_delivery_date = edddd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS minsdd ON oib.min_shipping_limit_date = minsdd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS maxsdd ON oib.max_shipping_limit_date = maxsdd.date_day

)

SELECT * FROM order_enriched
