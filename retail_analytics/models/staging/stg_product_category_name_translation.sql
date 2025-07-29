{{ config(tags = ['products']) }}

WITH source AS (

    SELECT * FROM {{ source('csv_input', 'product_category_name_translation') }}

),

renamed AS (

    SELECT
        upper(product_category_name) AS category_name,
        upper(product_category_name_english) AS category_name_english

    FROM source

)

SELECT * FROM renamed
