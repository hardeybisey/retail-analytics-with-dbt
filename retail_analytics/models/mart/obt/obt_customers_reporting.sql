-- wide view for sales/delivery/return/customer analysis
{{
    config(tags = ['obt'])
}}
with f_orders AS (
    SELECT * FROM {{ ref('fact_orders') }}
),
d_customer AS (
    SELECT * FROM {{ ref('dim_customer') }}
),
d_date AS (
    SELECT * FROM {{ ref('dim_date') }}
)
SELECT
    {{ dbt_utils.star(from=ref('fact_orders'), relation_alias='f_orders', except=[
        "order_key", "order_date_key"
    ]) }},
    {{ dbt_utils.star(from=ref('dim_customer'), relation_alias='d_customer', except=["customer_key"]) }},
    {{ dbt_utils.star(from=ref('dim_date'), relation_alias='d_date', except=["date_key"]) }}
FROM f_orders
LEFT JOIN d_customer ON f_orders.customer_key = d_customer.customer_key
LEFT JOIN d_date ON f_orders.order_date_key = d_date.date_day
