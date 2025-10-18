-- This query calculates the total spending for each customer, which is a foundational
-- metric for understanding customer value.
{{
    config(tags = ['analyses', 'customer'])
}}
SELECT
    c.customer_id,
    SUM(fo.total_order_value) AS total_spent
FROM

    {{ ref('dim_customer') }} AS c
INNER JOIN
    {{ ref('fact_order_summary') }} AS fo ON c.customer_sk = fo.customer_sk
GROUP BY
    c.customer_id
ORDER BY
    total_spent DESC;
