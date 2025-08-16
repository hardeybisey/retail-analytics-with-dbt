-- This query calculates the average amount spent per order for each customer's state,
-- which can reveal geographical purchasing trends.
SELECT
    c.state,
    AVG(fo.total_order_value) AS average_order_value
FROM
    {{ ref('dim_customer') }} AS c
INNER JOIN
    {{ ref('fact_orders') }} AS fo ON c.customer_key = fo.customer_key
GROUP BY
    c.state
ORDER BY
    average_order_value DESC;
