{% snapshot snapshot_sellers %}
{{
    config(
        tags = ['seller'],
        target_schema='snapshots',
        unique_key='seller_id',
        strategy='check',
        check_cols=['zip_code_prefix'],
        hard_deletes='invalidate',
        snapshot_meta_column_names={
            'dbt_valid_from': 'valid_from',
            'dbt_valid_to': 'valid_to',
            'dbt_updated_at': 'dbt_modified_date',
        },
    )
}}

    with source as (

        select * from {{ source('csv_input', 'olist_sellers') }}

    ),

    renamed as (

        select
            seller_id,
            seller_zip_code_prefix::integer as zip_code_prefix,
            upper(seller_city) as city,
            upper(seller_state) as state

        from source

    )

    select * from renamed

{% endsnapshot %}
