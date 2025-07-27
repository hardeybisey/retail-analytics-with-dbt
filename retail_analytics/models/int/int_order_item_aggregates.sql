select
    order_id,
    sum(item_price) as total_order_price,
    sum(freight_price) as total_freight_price,
    min(shipping_limit_date) as min_shipping_limit_date,
    max(shipping_limit_date) as max_shipping_limit_date,
    count(order_item_id) as item_count
from {{ ref('int_order_items') }}
group by order_id
