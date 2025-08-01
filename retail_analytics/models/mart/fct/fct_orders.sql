{{ config(tags = ['order']) }}
WITH orders_base AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(["order_id"]) }} AS order_key,
        order_id,
        customer_id,
        order_timestamp,
        order_timestamp::date AS order_date,
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
        ob.order_status,

        -- Joining with date dimensions
        odd.date_day AS order_date_key,
        minsdd.date_day AS min_shipping_limit_date_key,
        maxsdd.date_day AS max_shipping_limit_date_key,
        dtcrdd.date_day AS delivered_to_carrier_date_key,
        dtcsdd.date_day AS delivered_to_customer_date_key,
        edddd.date_day AS estimated_delivery_date_key,
        padd.date_day AS payment_approved_date_key

    FROM orders_base AS ob
    LEFT JOIN {{ ref('dim_customer') }} AS cb
        ON
            ob.customer_id = cb.customer_id
            AND ob.order_timestamp >= cb.valid_from AND (ob.order_timestamp < cb.valid_to OR cb.valid_to IS null)
    LEFT JOIN {{ ref('int_order_item_aggregates') }} AS oib ON ob.order_id = oib.order_id
    LEFT JOIN {{ ref('dim_date') }} AS odd ON ob.order_date = odd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS padd ON ob.payment_approved_date = padd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS dtcrdd ON ob.delivered_to_carrier_date = dtcrdd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS dtcsdd ON ob.delivered_to_customer_date = dtcsdd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS edddd ON ob.estimated_delivery_date = edddd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS minsdd ON oib.min_shipping_limit_date = minsdd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS maxsdd ON oib.max_shipping_limit_date = maxsdd.date_day

)

SELECT * FROM order_enriched
