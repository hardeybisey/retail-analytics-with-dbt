{{ config(tags = ['products']) }}

WITH source AS (

    SELECT * FROM {{ source('csv_input', 'olist_products') }}

),

deduplicated_products AS (

    SELECT
        product_id,
        product_name_lenght::integer AS name_length,
        product_description_lenght::integer AS description_length,
        product_photos_qty::integer AS photos_qty,
        product_weight_g::integer AS weight_g,
        product_length_cm::integer AS length_cm,
        product_height_cm::integer AS height_cm,
        product_width_cm::integer AS width_cm,
        row_number() OVER (PARTITION BY product_id) AS row_num,
        upper(product_category_name) AS category_name

    FROM source

)

SELECT * FROM deduplicated_products
WHERE row_num = 1
