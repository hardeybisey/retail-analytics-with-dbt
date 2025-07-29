WITH order_item_base AS (

    SELECT
        order_id,
        order_item_id,
        product_id,
        seller_id,
        item_price,
        freight_price,
        shipping_limit_date,
        {{ dbt_utils.generate_surrogate_key(["order_id", "order_item_id"]) }} AS order_item_key

    FROM {{ ref('stg_order_items') }}

),

order_item_with_dates AS (
    SELECT
        oib.order_item_key,
        oib.order_id,
        oib.order_item_id,
        oib.product_id,
        oib.seller_id,
        oib.item_price,
        oib.freight_price,
        oib.shipping_limit_date,
        ob.order_timestamp
    FROM order_item_base AS oib
    LEFT JOIN {{ ref('stg_orders') }} AS ob ON oib.order_id = ob.order_id
)

SELECT * FROM order_item_with_dates
