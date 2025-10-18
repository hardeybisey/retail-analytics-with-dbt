{{
    config(tags = ['order'])
}}
WITH order_items_base AS (

    SELECT
        oi.order_id,
        oi.order_item_id,
        oi.product_id,
        oi.seller_id,
        oi.item_value,
        oi.freight_value,
        oi.shipping_limit_date,
        o.order_date
    FROM {{ ref('stg_order_items') }} AS oi
    LEFT JOIN {{ ref('stg_orders') }} AS o ON oi.order_id = o.order_id
),

order_item_enriched AS (
    SELECT
        oi.order_id,
        oi.order_item_id,
        oi.item_value,
        oi.freight_value,
        pd.product_sk,
        sd.seller_sk,

        -- Joining with date dimensions
        odd.date_day AS order_date_key,
        sdd.date_day AS shipping_limit_date_key

    FROM order_items_base AS oi
    LEFT JOIN {{ ref('dim_product') }} AS pd
        ON oi.product_id = pd.product_id
        AND oi.order_date >= pd.product_valid_from_date AND (oi.order_date < pd.product_valid_to_date OR pd.product_valid_to_date IS null)
    LEFT JOIN {{ ref('dim_seller') }} AS sd
        ON
            oi.seller_id = sd.seller_id
            AND oi.order_date >= sd.seller_valid_from_date AND (oi.order_date < sd.seller_valid_to_date OR sd.seller_valid_to_date IS null)
    LEFT JOIN {{ ref('dim_date') }} AS odd ON oi.order_date = odd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS sdd ON oi.shipping_limit_date = sdd.date_day
)

SELECT * FROM order_item_enriched
