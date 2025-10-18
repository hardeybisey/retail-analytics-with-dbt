-- wide view for seller/product/ analysis
{{
    config(tags = ['obt'])
}}
with f_order_items AS (
    SELECT * FROM {{ ref('fact_order_items') }}
),

d_seller AS (
    SELECT * FROM {{ ref('dim_seller') }}
),
d_product AS (
    SELECT * FROM {{ ref('dim_product') }}
),
d_date as (
    SELECT * FROM {{ ref('dim_date') }}
)

select
    {{ dbt_utils.star(from=ref('fact_order_items'), relation_alias='f_order_items') }},
    {{ dbt_utils.star(from=ref('dim_product'), relation_alias='d_product', except=["product_sk"]) }},
    {{ dbt_utils.star(from=ref('dim_seller'), relation_alias='d_seller', except=["seller_sk"]) }},
    {{ dbt_utils.star(from=ref('dim_date'), relation_alias='d_date') }}
FROM f_order_items
LEFT JOIN d_product ON f_order_items.product_sk = d_product.product_sk
LEFT JOIN d_seller ON f_order_items.seller_sk = d_seller.seller_sk
LEFT JOIN d_date ON f_order_items.order_date_key = d_date.date_day
