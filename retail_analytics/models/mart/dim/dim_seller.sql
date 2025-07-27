{{ config(tags = ['sellers']) }}
with snapshots as (

    select *
    from {{ ref('snapshot_sellers') }}

),

dim as (

    select
        {{ dbt_utils.generate_surrogate_key(["seller_id", "valid_from"]) }} as seller_key,
        seller_id,
        zip_code_prefix,
        city,
        state,
        valid_from,
        valid_to,
        coalesce(valid_to is null, false) as is_current
    from snapshots
)

select * from dim
