{{ config(tags = ['product']) }}

WITH source AS (

    SELECT * FROM {{ source('csv_input', 'products') }}

),

deduplicated_products AS (

    SELECT
        product_id,
        product_category_id AS category_id,
        product_name,
        product_size_label AS size_label,
        product_price::float AS price,
        product_length_cm::float AS length_cm,
        product_height_cm::float AS height_cm,
        product_width_cm::float AS width_cm,
        row_number() OVER (PARTITION BY product_id) AS row_num

    FROM source

)

SELECT
    product_id,
    product_name,
    category_id,
    price,
    size_label,
    length_cm,
    height_cm,
    width_cm
FROM deduplicated_products
WHERE row_num = 1
