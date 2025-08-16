-- This query identifies the top-selling products for each seller, providing insights
-- into product performance at a seller level.
WITH ranked_products AS (
    SELECT
        s.seller_id,
        p.product_name,
        SUM(foi.item_value) AS product_sales,
        ROW_NUMBER() OVER (
            PARTITION BY s.seller_id ORDER BY SUM(foi.item_value) DESC
        ) AS rn
    FROM

        {{ ref('dim_seller') }} AS s
    INNER JOIN
        {{ ref('fact_order_items') }} AS foi ON s.seller_key = foi.seller_key
    INNER JOIN
        {{ ref('dim_product') }} AS p ON foi.product_key = p.product_key
    GROUP BY
        s.seller_id,
        p.product_name
)

SELECT
    seller_id,
    product_name,
    product_sales
FROM ranked_products
WHERE rn <= 5
