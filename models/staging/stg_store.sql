


with stg_store as (
    select 
        store_id,
        manager_staff_id,
        address_id as store_address_id,
        last_update as store_last_update,
        dbt_updated_at,
        dbt_valid_from,
        dbt_valid_to
    from {{ ref('snap_store') }}
)
select * from stg_store sstre 
{% if is_incremental() %}  
    where sstre.store_last_update > (select max(store_last_update) from {{ this }})
{% endif %}