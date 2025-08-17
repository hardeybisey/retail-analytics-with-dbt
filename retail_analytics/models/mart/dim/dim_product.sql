{{ config(tags = ['product']) }}
SELECT
    sp.product_id,
    sp.product_name,
    sp.price,
    sp.size_label,
    sp.length_cm,
    sp.height_cm,
    sp.width_cm,
    spc.category_key,
    {{ dbt_utils.generate_surrogate_key(["product_id"]) }} AS product_key
FROM {{ ref('stg_products') }} AS sp
LEFT JOIN {{ ref('dim_product_category') }} AS spc on sp.category_id=spc.category_id
