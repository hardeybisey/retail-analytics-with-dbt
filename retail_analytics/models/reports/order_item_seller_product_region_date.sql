-- seller/product/region/ analysis
with f_order_items as (
    select * from {{ ref('fact_order_items') }}
),

d_seller as (
    select * from {{ ref('dim_seller') }}
),
d_product as (
    select * from {{ ref('dim_product') }}
),
d_region as (
    select * from {{ ref('dim_region') }}
),
d_date as (
    select * from {{ ref('dim_date') }}
)

select
    {{ dbt_utils.star(from=ref('fact_order_items'), relation_alias='f_order_items', except=[
        "product_key", "order_date_key"
    ]) }},
    {{ dbt_utils.star(from=ref('dim_product'), relation_alias='d_product', except=["product_key"]) }},
    {{ dbt_utils.star(from=ref('dim_seller'), relation_alias='d_seller', except=["seller_key", "region_key"]) }},
    {{ dbt_utils.star(from=ref('dim_region'), relation_alias='d_region', except=["region_key"]) }},
    {{ dbt_utils.star(from=ref('dim_date'), relation_alias='d_date') }}
from f_order_items
left join d_product on f_order_items.product_key = d_product.product_key
left join d_seller on f_order_items.seller_key = d_seller.seller_key
left join d_region on d_seller.region_key = d_region.region_key
left join d_date on f_order_items.order_date_key = d_date.date_day
