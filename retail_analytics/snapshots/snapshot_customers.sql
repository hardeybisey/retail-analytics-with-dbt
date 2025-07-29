{% snapshot snapshot_customers %}
{{
    config(
        tags = ['customer'],
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='check',
        check_cols=['zip_code_prefix'],
        hard_deletes='invalidate',
        snapshot_meta_column_names={
            'dbt_valid_from': 'valid_from',
            'dbt_valid_to': 'valid_to',
            'dbt_scd_id': 'scd_id',
            'dbt_updated_at': 'dbt_modified_date',
        },
    )
}}
    WITH source AS (

        SELECT * FROM {{ source('csv_input', 'olist_customers') }}

    ),

    renamed AS (

        SELECT
            customer_id,
            customer_unique_id,
            customer_zip_code_prefix::integer AS zip_code_prefix,
            upper(customer_city) AS city,
            upper(customer_state) AS state

        FROM source

    )

    SELECT * FROM renamed

{% endsnapshot %}
