-- This query tracks the month-over-month growth in total sales, a critical KPI for
-- business performance.
{{
    config(tags = ['analyses'])
}}
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date_key) AS sales_month,
        SUM(total_order_value) AS total_sales
    FROM {{ ref('fact_order_summary') }}
    GROUP BY sales_month
)

SELECT
    sales_month,
    total_sales,
    (total_sales - LAG(total_sales, 1, 0) OVER (ORDER BY sales_month))
    / LAG(total_sales, 1, 1) OVER (ORDER BY sales_month) AS sales_growth
FROM monthly_sales
ORDER BY sales_month
