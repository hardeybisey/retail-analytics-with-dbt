-- This query calculates the total spending for each customer, which is a foundational
-- metric for understanding customer value.
SELECT
    c.customer_id,
    SUM(fo.total_order_value) AS total_spent
FROM

    {{ ref('dim_customer') }} AS c
INNER JOIN
    {{ ref('fact_orders') }} AS fo ON c.customer_key = fo.customer_key
GROUP BY
    c.customer_id
ORDER BY
    total_spent DESC;
