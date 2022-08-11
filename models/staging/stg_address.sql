
with stg_address as (
    select 
        address_id,
        address as address_name,
        district,
        city_id,
        postal_code,
        phone,
        last_update as address_last_update
    from {{ source('sakila','address') }}
)
select * from stg_address sad
{% if is_incremental() %}  
    where sad.address_last_update > (select max(address_last_update) from {{ this }})
{% endif %}
