{{ config(tags = ['products']) }}

WITH source AS (

    SELECT * FROM {{ source('csv_input', 'product_category') }}

),

deduplicated_products AS (

    SELECT
        product_category_id AS category_id,
        product_category_name AS category_name,
        product_sub_category,
        row_number() OVER (PARTITION BY product_category_id) AS row_num

    FROM source

)

SELECT
    category_id,
    category_name,
    product_sub_category
FROM deduplicated_products
WHERE row_num = 1
