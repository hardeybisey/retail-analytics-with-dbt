{{ config(tags = ['products']) }}

with source as (

    select * from {{ source('csv_input', 'olist_products') }}

),

renamed as (

    select
        product_id,
        product_name_lenght::integer as name_length,
        product_description_lenght::integer as description_length,
        product_photos_qty::integer as photos_qty,
        product_weight_g::integer as weight_g,
        product_length_cm::integer as length_cm,
        product_height_cm::integer as height_cm,
        product_width_cm::integer as width_cm,
        upper(product_category_name) as category_name

    from source

)

select * from renamed
