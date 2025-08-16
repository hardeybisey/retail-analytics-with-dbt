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

    deduplicated_customers AS (

        SELECT
            customer_id,
            customer_address AS address,
            customer_state AS state,
            customer_zip_code::integer AS zip_code_prefix,
            customer_created_date::timestamp AS created_date,
            COALESCE(customer_updated_date, customer_created_date::timestamp) AS updated_date,
            ROW_NUMBER() OVER (PARTITION BY customer_id) AS row_num

        FROM source

    )

    SELECT
        customer_id,
        address,
        state,
        zip_code_prefix,
        created_date,
        updated_date
    FROM deduplicated_customers
    WHERE row_num = 1

{% endsnapshot %}
