-- wide view for sales/delivery/return/customer analysis
{{
    config(tags = ['obt'])
}}
with fact_orders_summary AS (
    SELECT * FROM {{ ref('fact_order_summary') }}
),
d_customer AS (
    SELECT * FROM {{ ref('dim_customer') }}
),
d_date AS (
    SELECT * FROM {{ ref('dim_date') }}
)
SELECT
    {{ dbt_utils.star(from=ref('fact_order_summary'), relation_alias='fact_orders_summary') }},
    {{ dbt_utils.star(from=ref('dim_customer'), relation_alias='d_customer', except=["customer_sk"]) }},
    {{ dbt_utils.star(from=ref('dim_date'), relation_alias='d_date', except=["date_key"]) }}
FROM fact_orders_summary
LEFT JOIN d_customer ON fact_orders_summary.customer_sk = d_customer.customer_sk
LEFT JOIN d_date ON fact_orders_summary.order_date_key = d_date.date_day
