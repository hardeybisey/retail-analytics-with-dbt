{{ config(tags = ['customers']) }}

with source as (

    select * from {{ source('csv_input', 'olist_order_reviews') }}

),

renamed as (

    select
        review_id,
        order_id,
        review_score::integer as score,
        review_comment_title as comment_title,
        review_comment_message as comment_message,
        review_creation_date::timestamp as creation_date,
        review_answer_timestamp::timestamp as answer_timestamp

    from source

)

select * from renamed
