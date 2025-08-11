{% snapshot snapshot_customers %}
{{
    config(
        tags = ['customer'],
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='updated_date',
        hard_deletes='invalidate',
    )
}}
    WITH source AS (

        SELECT * FROM {{ source('csv_input', 'customers') }}

    ),

    renamed AS (

        SELECT
            customer_id,
            customer_address AS address,
            customer_state AS state,
            customer_zip_code::integer AS zip_code_prefix,
            TO_TIMESTAMP(customer_created_date::text, 'YYYY-MM-DD') AS created_date,
            TO_TIMESTAMP(customer_updated_date::text, 'YYYY-MM-DD') AS updated_date

        FROM source

    )

    SELECT * FROM renamed

{% endsnapshot %}
