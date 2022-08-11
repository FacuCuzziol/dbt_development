


with stg_staff as (
    select 
        staff_id,
        first_name,
        last_name,
        address_id as staff_address_id,
        email,
        store_id,
        active,
        last_update as staff_last_update,
        dbt_updated_at,
        dbt_valid_from,
        dbt_valid_to
    from {{ ref('snap_staff') }}
)
select * from stg_staff ss
{% if is_incremental() %}  
    where ss.staff_last_update > (select max(staff_last_update) from {{ this }})
{% endif %}