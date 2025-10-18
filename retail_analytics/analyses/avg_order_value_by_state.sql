-- This query calculates the average amount spent per order for each customer's state,
-- which can reveal geographical purchasing trends.
{{
    config(tags = ['analyses'])
}}
SELECT
    c.state,
    AVG(fo.total_order_value) AS average_order_value
FROM
    {{ ref('dim_customer') }} AS c
INNER JOIN
    {{ ref('fact_order_summary') }} AS fo ON c.customer_sk = fo.customer_sk
GROUP BY
    c.state
ORDER BY
    average_order_value DESC;
