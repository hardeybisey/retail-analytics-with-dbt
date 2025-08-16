{% snapshot snapshot_sellers %}
{{
    config(
        tags = ['seller'],
        target_schema='snapshots',
        unique_key='seller_id',
        strategy='timestamp',
        updated_at='updated_date',
        hard_deletes='invalidate',
    )
}}

    WITH source AS (

        SELECT * FROM {{ source('csv_input', 'sellers') }}

    ),

    deduplicated_sellers AS (

        SELECT
            seller_id,
            seller_address AS address,
            seller_state AS state,
            seller_zip_code::integer AS zip_code_prefix,
            seller_created_date::timestamp AS created_date,
            COALESCE(seller_updated_date, '1900-01-01 00:00:00'::timestamp) AS updated_date,
            ROW_NUMBER() OVER (PARTITION BY seller_id) AS row_num
        FROM source

    )

    SELECT
        seller_id,
        address,
        state,
        zip_code_prefix,
        created_date,
        updated_date
    FROM deduplicated_sellers
    WHERE row_num = 1


{% endsnapshot %}
