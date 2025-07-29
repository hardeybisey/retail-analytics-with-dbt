SELECT
    order_id,
    sum(item_price) AS total_order_price,
    sum(freight_price) AS total_freight_price,
    min(shipping_limit_date) AS min_shipping_limit_date,
    max(shipping_limit_date) AS max_shipping_limit_date,
    count(order_item_id) AS item_count
FROM {{ ref('int_order_items') }}
GROUP BY order_id
