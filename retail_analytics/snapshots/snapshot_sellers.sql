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

    renamed AS (

        SELECT
            seller_id,
            seller_state AS state,
            seller_zip_code::integer AS zip_code_prefix,
            seller_created_date::timestamp AS created_date,
            COALESCE(seller_updated_date, '1900-01-01 00:00:00'::timestamp) AS updated_date
        FROM source

    )

    SELECT * FROM renamed

{% endsnapshot %}
