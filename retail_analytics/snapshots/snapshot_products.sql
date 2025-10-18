{% snapshot snapshot_products %}
{{
    config(
        tags = ['product'],
        target_schema='snapshots',
        unique_key='product_id',
        strategy='timestamp',
        updated_at='updated_date',
        hard_deletes='invalidate',
    )
}}
    WITH source AS (

        SELECT * FROM {{ source('csv_input', 'products') }}

    ),

    deduplicated_product AS (

        SELECT


            product_id,
            upper(product_category) AS category_name,
            product_name,
            product_size_label AS size_label,
            product_width_cm::float AS width_cm,
            product_length_cm::float AS length_cm,
            product_height_cm::float AS height_cm,
            product_price::float AS price,
            product_created_date::timestamp AS created_date,
            COALESCE(product_updated_date, product_created_date)::timestamp AS updated_date,
            ROW_NUMBER() OVER (PARTITION BY product_id) AS row_num
        FROM source

    )

    SELECT
        product_id,
        product_name,
        category_name,
        size_label,
        width_cm,
        length_cm,
        height_cm,
        price,
        created_date,
        updated_date
    FROM deduplicated_product
    WHERE row_num = 1

{% endsnapshot %}
