{{ config(tags = ['order']) }}
with order_items_base as (
    select
        order_item_key,
        order_id,
        order_item_id,
        product_id,
        seller_id,
        item_price,
        freight_price,
        shipping_limit_date,
        order_timestamp
    from {{ ref('int_order_items') }}
),

order_item_enriched as (
    select
        oi.order_item_key,
        oi.order_id,
        oi.order_item_id,
        oi.item_price,
        oi.freight_price,
        oi.shipping_limit_date,
        oi.order_timestamp,
        pd.product_key,
        sd.seller_key
    from order_items_base as oi
    left join {{ ref('dim_product') }} as pd on oi.product_id = pd.product_id
    left join {{ ref('dim_seller') }} as sd on oi.seller_id = sd.seller_id
    {% if is_incremental() %}
    and oi.order_timestamp >= sd.valid_from
    and (oi.order_timestamp < sd.valid_to or sd.valid_to is null)
    {% endif %}
)

select * from order_item_enriched
