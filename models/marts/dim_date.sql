
{{
config(
    materialized='view'
)
}}

with dates as (
    {{ dbt_date.get_date_dimension("2000-01-01", "2030-12-31") }}
)
select 
    d.*,
    {{ dbt_date.to_unixtimestamp('d.date_day') }} as date_id
from dates d