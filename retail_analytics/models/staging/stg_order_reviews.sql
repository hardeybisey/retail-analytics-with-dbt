{{ config(tags = ['customers']) }}

WITH source AS (

    SELECT * FROM {{ source('csv_input', 'olist_order_reviews') }}

),

deduplicated_order_reviews AS (

    SELECT
        review_id,
        order_id,
        review_score::integer AS score,
        review_comment_title AS title,
        review_comment_message AS message,
        review_creation_date::date AS creation_date,
        review_answer_timestamp::date AS response_date,
        row_number() OVER (PARTITION BY order_id) AS row_num

    FROM source

)
SELECT
    review_id,
    order_id,
    score,
    title,
    message,
    creation_date,
    response_date
FROM deduplicated_order_reviews
WHERE row_num = 1
