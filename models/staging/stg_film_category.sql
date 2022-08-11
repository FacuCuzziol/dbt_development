
with stg_film_category as (
    select 
        {{ dbt_utils.surrogate_key(['film_id','category_id']) }} as film_category_id,
        film_id,
        category_id,
        last_update as film_category_last_update
    from {{ source('sakila','film_category') }}
)
select * from stg_film_category sfc
{% if is_incremental() %}  
    where sfc.film_category_last_update > (select max(film_category_last_update) from {{ this }})
{% endif %}