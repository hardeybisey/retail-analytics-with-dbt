SELECT
    order_id,
    sum(item_value) AS total_order_value,
    sum(freight_value) AS total_freight_value,
    min(shipping_limit_date) AS min_shipping_limit_date,
    max(shipping_limit_date) AS max_shipping_limit_date,
    count(order_item_id) AS item_count
FROM {{ ref('int_order_items') }}
GROUP BY order_id
