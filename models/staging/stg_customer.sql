

with stg_customer as (
    select 
        customer_id,
        store_id,
        first_name,
        last_name,
        email,
        address_id,
        activebool,
        create_date as customer_create_date,
        last_update as customer_last_update,
        dbt_updated_at,
        dbt_valid_from,
        dbt_valid_to
    from {{ ref('snap_customer') }}
)
select * from stg_customer scr
{% if is_incremental() %}  
    where scr.customer_last_update > (select max(customer_last_update) from {{ this }})
{% endif %}