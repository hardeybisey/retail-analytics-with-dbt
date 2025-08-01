-- Track Monthly Active Customers by City
{{ config(tags = ['reports']) }}
WITH customers AS (

    SELECT * FROM {{ ref('dim_customer') }}
),

orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
),

regions AS (
    SELECT * FROM {{ ref('dim_region') }}
)

SELECT
    r.city,
    r.latitude,
    r.longitude,
    date_part('year', o.order_date_key) || '_' || date_part('month', o.order_date_key) AS order_yy_mm,
    count(c.customer_unique_id) AS customers_with_order
FROM customers AS c
INNER JOIN orders AS o ON c.customer_key = o.customer_key
INNER JOIN regions AS r ON c.region_key = r.region_key
WHERE o.order_status = 'CREATED'
GROUP BY
    1, 2, 3, 4
ORDER BY 5 DESC
