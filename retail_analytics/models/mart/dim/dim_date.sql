{{

    config(
        tags = ['date'],
    )
}}
{{ dbt_date.get_date_dimension(var("start_date") , var("end_date")) }}
