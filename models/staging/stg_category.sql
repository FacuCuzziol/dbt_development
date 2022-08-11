
with stg_category as (
    select 
        category_id,
        name as category_name,
        last_update as category_last_update
    from {{ source('sakila','category') }}
)
select * from stg_category sc
{% if is_incremental() %}  
    where sc.category_last_update > (select max(category_last_update) from {{ this }})
{% endif %}
