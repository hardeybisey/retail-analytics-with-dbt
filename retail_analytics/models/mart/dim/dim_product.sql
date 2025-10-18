
{{ config(tags = ['product']) }}
SELECT
    s.product_id,
    s.product_name,
    s.category_name,
    s.price,
    s.size_label,
    s.length_cm,
    s.height_cm,
    s.width_cm,
    s.dbt_valid_from::date AS product_valid_from_date,
    s.dbt_valid_to::date AS product_valid_to_date,
    (s.dbt_valid_to IS null) AS product_is_current,
    {{ dbt_utils.generate_surrogate_key(["s.product_id", "s.dbt_valid_from"]) }} AS product_sk
FROM {{ ref('snapshot_products') }} AS s
