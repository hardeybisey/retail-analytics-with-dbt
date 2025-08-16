{{ config(tags = ['product']) }}
WITH cetegory_base AS (

    SELECT
        {{ dbt_utils.generate_surrogate_key(["category_id"]) }} AS category_key,
        category_id,
        category_name,
        product_sub_category
    FROM {{ ref('stg_product_category') }}
)

SELECT * FROM cetegory_base
