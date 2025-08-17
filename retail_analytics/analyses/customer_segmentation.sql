-- This query segments customers based on their purchasing behavior, which can be
-- used to tailor marketing campaigns.
{{
    config(tags = ['analyses', 'customer'])
}}
WITH customer_rfm AS (
    SELECT
        c.customer_id,
        MAX(fo.order_date_key) AS last_purchase_date,
        COUNT(DISTINCT fo.order_id) AS frequency,
        SUM(fo.total_order_value) AS monetary
    FROM

        {{ ref('dim_customer') }} AS c
    INNER JOIN

        {{ ref('fact_orders') }} AS fo ON c.customer_key = fo.customer_key
    GROUP BY
        c.customer_id
)

SELECT
    customer_id,
    last_purchase_date,
    frequency,
    monetary,
    NTILE(4) OVER (ORDER BY last_purchase_date DESC) AS recency_score,
    NTILE(4) OVER (ORDER BY frequency DESC) AS frequency_score,
    NTILE(4) OVER (ORDER BY monetary DESC) AS monetary_score
FROM
    customer_rfm;
