{{ config(tags = ['orders']) }}
with base as (

    select
        {{ dbt_utils.generate_surrogate_key(["review_id"]) }} as review_key,
        order_id,
        -- score,
        title,
        message,
        creation_date,
        response_date

    from {{ ref('stg_order_reviews') }}
)

select
    review_key,
    order_id,
    title,
    message,
    creation_date,
    response_date
from base
