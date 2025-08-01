{{ config(tags = ['order']) }}
WITH order_items_base AS (
    SELECT
        order_item_key,
        order_id,
        order_item_id,
        product_id,
        seller_id,
        item_price,
        freight_price,
        shipping_limit_date,
        order_timestamp,
        order_timestamp::date AS order_date
    FROM {{ ref('int_order_items') }}
),

order_item_enriched AS (
    SELECT
        oi.order_item_key,
        oi.order_id,
        oi.order_item_id,
        oi.item_price,
        oi.freight_price,
        oi.shipping_limit_date,
        pd.product_key,
        sd.seller_key,

        -- Joining with date dimensions
        odd.date_day AS order_date_key,
        sdd.date_day AS shipping_limit_date_key

    FROM order_items_base AS oi
    LEFT JOIN {{ ref('dim_product') }} AS pd ON oi.product_id = pd.product_id
    LEFT JOIN {{ ref('dim_seller') }} AS sd
        ON
            oi.seller_id = sd.seller_id
            AND oi.order_timestamp >= sd.valid_from AND (oi.order_timestamp < sd.valid_to OR sd.valid_to IS null)
    LEFT JOIN {{ ref('dim_date') }} AS odd ON oi.order_date = odd.date_day
    LEFT JOIN {{ ref('dim_date') }} AS sdd ON oi.shipping_limit_date = sdd.date_day
)

SELECT * FROM order_item_enriched
