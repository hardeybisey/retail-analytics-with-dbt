{{ config(
    tags = ['order'],
    )
 }}

WITH source AS (

    SELECT * FROM {{ source('csv_input', 'order_items') }}

),

deduplicated_order_items AS (

    SELECT
        order_id,
        order_item_id,
        product_id,
        seller_id,
        price::float AS item_value,
        freight_value::float AS freight_value,
        shipping_limit_date::date AS shipping_limit_date,
        row_number() OVER (PARTITION BY order_id, order_item_id) AS row_num

    FROM source


)

SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    item_value,
    freight_value
FROM deduplicated_order_items
WHERE row_num = 1
