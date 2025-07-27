{{ config(tags = ['order']) }}
with orders_base as (
    select
        {{ dbt_utils.generate_surrogate_key(["order_id"]) }} as order_key,
        order_id,
        customer_id,
        order_timestamp,
        payment_approved_date,
        delivered_to_carrier_date,
        delivered_to_customer_date,
        estimated_delivery_date,
        order_status
    from {{ ref('stg_orders') }}
),

order_enriched as (
    select
        ob.order_key,
        cb.customer_key,
        ob.order_id,
        oib.item_count,
        oib.total_order_price,
        oib.total_freight_price,
        oib.min_shipping_limit_date,
        oib.max_shipping_limit_date,
        ob.order_timestamp,
        ob.payment_approved_date,
        ob.delivered_to_carrier_date,
        ob.delivered_to_customer_date,
        ob.estimated_delivery_date,
        ob.order_status
    from orders_base as ob
    left join {{ ref('int_order_item_aggregates') }} as oib on ob.order_id = oib.order_id
    left join {{ ref('dim_customer') }} as cb on ob.customer_id = cb.customer_id
    {% if is_incremental() %}
    and ob.order_timestamp >= cb.valid_from  and (ob.order_timestamp < cb.valid_to or cb.valid_to is null)
    {% endif %}
)

select * from order_enriched
