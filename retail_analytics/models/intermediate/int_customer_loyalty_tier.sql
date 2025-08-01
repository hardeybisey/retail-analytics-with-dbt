WITH customer_orders AS (
    SELECT
        customer_key,
        COUNT(DISTINCT order_key) AS total_orders
    FROM {{ ref('fact_orders') }}
    WHERE order_status NOT IN ('CANCELED', 'UNAVAILABLE')
    GROUP BY customer_key
),

loyalty_tiers AS (
    SELECT
        customer_key,
        CASE
            WHEN total_orders >= 10 THEN 'Platinum'
            WHEN total_orders >= 5 THEN 'Gold'
            WHEN total_orders >= 2 THEN 'Silver'
            ELSE 'Bronze'
        END AS loyalty_tier
    FROM customer_orders
)

SELECT * FROM loyalty_tiers
