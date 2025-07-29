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
        order_timestamp
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
        oi.order_timestamp,
        pd.product_key,
        sd.seller_key
    FROM order_items_base AS oi
    LEFT JOIN {{ ref('dim_product') }} AS pd ON oi.product_id = pd.product_id
    LEFT JOIN {{ ref('dim_seller') }} AS sd ON
        oi.seller_id = sd.seller_id
        AND oi.order_timestamp >= sd.valid_from AND (oi.order_timestamp < sd.valid_to OR sd.valid_to IS null)
)

SELECT * FROM order_item_enriched
