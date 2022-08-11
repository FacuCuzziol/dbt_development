

with stg_inventory as (
    select 
        inventory_id,
        film_id,
        store_id,
        last_update as inventory_last_update
    from {{ source('sakila','inventory') }}
)
select * from stg_inventory si
{% if is_incremental() %}  
    where si.inventory_last_update > (select max(inventory_last_update) from {{ this }})
{% endif %}