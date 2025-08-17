-- This query evaluates seller performance based on total sales and the number of
-- orders they have fulfilled.
{{
    config(tags = ['analyses', 'seller'])
}}
SELECT
    s.seller_id,
    SUM(foi.item_value) AS total_sales,
    COUNT(DISTINCT foi.order_id) AS total_orders
FROM
    {{ ref('dim_seller') }} AS s
INNER JOIN
    {{ ref('fact_order_items') }} AS foi ON s.seller_key = foi.seller_key
GROUP BY s.seller_id
ORDER BY total_sales DESC
