{{
    config(
        materialized='view'
    )
}}
with stg_customer as (
    select 
        customer_id,
        first_name,
        last_name,
        email,
        address_id,
        customer_create_date,
        customer_last_update,
        dbt_updated_at,
        dbt_valid_from,
        dbt_valid_to
    from {{ref('stg_customer')}}
    where activebool
    and dbt_valid_to is null
),
stg_address as (
    select 
        address_id,
        address_name,
        district,
        city_id,
        postal_code,
        phone,
        address_last_update
    from {{ref('stg_address')}}
),
dim_customer as (
    select 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.customer_create_date,
        c.customer_last_update,
        a.address_name,
        a.district,
        a.city_id,
        a.postal_code,
        a.phone,
        a.address_last_update,
        c.dbt_updated_at,
        c.dbt_valid_from,
        c.dbt_valid_to
    from 
        stg_customer c
        left join stg_address a
        on c.address_id = a.address_id
)
select * from dim_customer