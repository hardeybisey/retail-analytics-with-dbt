{{ config(tags = ['customers']) }}
with snapshots as (

    select *
    from {{ ref('snapshot_customers') }}

),

dim as (

    select
        {{ dbt_utils.generate_surrogate_key(["customer_id", "valid_from"]) }} as customer_key,
        customer_id,
        customer_unique_id,
        zip_code_prefix,
        city,
        state,
        valid_from,
        valid_to,
        coalesce(valid_to is null, false) as is_current
    from snapshots
)

select * from dim
