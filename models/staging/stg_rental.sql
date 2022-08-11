

with stg_rental as (
    select 
        rental_id,
        inventory_id,
        customer_id,
        staff_id,
        rental_date,
        return_date,
        last_update as rental_last_update
    from {{ source('sakila','rental') }}
)
select * from stg_rental sr
{% if is_incremental() %}  
    where sr.rental_last_update > (select max(rental_last_update) from {{ this }})
{% endif %}