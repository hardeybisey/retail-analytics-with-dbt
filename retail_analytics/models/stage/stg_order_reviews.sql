{{ config(tags = ['customers']) }}

with source as (

    select * from {{ source('csv_input', 'olist_order_reviews') }}

),

renamed as (

    select
        review_id,
        order_id,
        review_score::integer as score,
        review_comment_title as title,
        review_comment_message as message,
        review_creation_date::date as creation_date,
        review_answer_timestamp::date as response_date

    from source

)

select * from renamed
