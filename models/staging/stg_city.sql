

with stg_city as (
    select
        city_id,
        city as city_name,
        country_id,
        last_update as city_last_update
    from {{ source('sakila','city') }}
)
select * from stg_city scy
{% if is_incremental() %}  
    where scy.city_last_update > (select max(city_last_update) from {{ this }})
{% endif %}
