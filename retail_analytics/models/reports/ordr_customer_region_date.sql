-- sales/delivery/return/customer analysis
with f_orders as (
    select * from {{ ref('fact_orders') }}
),

d_customer as (
    select * from {{ ref('dim_customer') }}
),

d_region as (
    select * from {{ ref('dim_region') }}
),
d_date as (
    select * from {{ ref('dim_date') }}
)

select
    {{ dbt_utils.star(from=ref('fact_orders'), relation_alias='f_orders', except=[
        "order_key", "customer_key", "order_date_key"
    ]) }},
    {{ dbt_utils.star(from=ref('dim_customer'), relation_alias='d_customer', except=["customer_key"]) }},
    {{ dbt_utils.star(from=ref('dim_region'), relation_alias='d_region', except=["region_key"]) }},
    {{ dbt_utils.star(from=ref('dim_date'), relation_alias='d_date', except=["date_key"]) }}
from f_orders
left join d_customer on f_orders.customer_key = d_customer.customer_key
left join d_region on d_customer.region_key = d_region.region_key
left join d_date on f_orders.order_date_key = d_date.date_day
