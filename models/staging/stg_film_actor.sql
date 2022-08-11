
with stg_film_actor as (
    select 
        {{ dbt_utils.surrogate_key(['actor_id','film_id']) }} as film_actor_id,
        actor_id,
        film_id,
        last_update as film_actor_last_update
    from {{ source('sakila','film_actor') }}
)
select * from stg_film_actor sfa
{% if is_incremental() %}  
    where sfa.film_actor_last_update > (select max(film_actor_last_update) from {{ this }})
{% endif %}