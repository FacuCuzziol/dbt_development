
with stg_country as (
    select 
        country_id,
        country as country_name,
        last_update as country_last_update
    from {{ source('sakila','country') }}
)
select * from stg_country scty
{% if is_incremental() %}  
    where scty.country_last_update > (select max(country_last_update) from {{ this }})
{% endif %}