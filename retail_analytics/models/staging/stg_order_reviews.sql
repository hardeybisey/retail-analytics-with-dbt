{{ config(tags = ['customers']) }}

WITH source AS (

    SELECT * FROM {{ source('csv_input', 'olist_order_reviews') }}

),

renamed AS (

    SELECT
        review_id,
        order_id,
        review_score::integer AS score,
        review_comment_title AS title,
        review_comment_message AS message,
        review_creation_date::date AS creation_date,
        review_answer_timestamp::date AS response_date

    FROM source

)

SELECT * FROM renamed
