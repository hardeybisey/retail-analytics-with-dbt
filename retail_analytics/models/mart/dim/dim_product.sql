{{ config(tags = ['product']) }}
SELECT
    product_id,
    product_name,
    price,
    size_label,
    length_cm,
    height_cm,
    width_cm,
    category_id,
    {{ dbt_utils.generate_surrogate_key(["product_id"]) }} AS product_key
FROM {{ ref('stg_products') }}
