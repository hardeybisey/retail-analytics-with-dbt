with order_item_base as (

    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        item_price,
        freight_price,
        shipping_limit_date,
        {{ dbt_utils.generate_surrogate_key(["order_id", "order_item_id"]) }} as order_item_key

    from {{ ref('stg_order_items') }}

),

order_item_with_dates as (
    select
        oib.order_item_key,
        oib.order_id,
        oib.order_item_id,
        oib.product_id,
        oib.seller_id,
        oib.item_price,
        oib.freight_price,
        oib.shipping_limit_date,
        ob.order_timestamp
    from order_item_base as oib
    left join {{ ref('stg_orders') }} as ob on oib.order_id = ob.order_id
)

select * from order_item_with_dates
