{{
    config(
        materialized='view'
    )
}}


with stg_staff as (
    select 
        staff_id,
        first_name,
        last_name,
        staff_address_id,
        email,
        store_id,
        active,
        staff_last_update,
        dbt_updated_at,
        dbt_valid_from,
        dbt_valid_to
    from {{ ref('stg_staff') }}
    where dbt_valid_to is null
    and active
),
stg_address as (
    select 
        address_id,
        address_name,
        district,
        city_id,
        postal_code,
        address_last_update
    from {{ ref('stg_address') }}
),
geographical_info as (
    select 
        sc.city_id,
        sc.city_name,
        scy.country_name
    from {{ ref('stg_city') }} sc
    left join {{ ref('stg_country') }} scy
    on sc.country_id = scy.country_id
),
dim_staff as (
    select 
        ss.staff_id,
        ss.first_name,
        ss.last_name,
        ss.email,
        sa.address_name,
        sa.postal_code,
        gi.city_name,
        gi.country_name,
        ss.dbt_updated_at as staff_dbt_updated_at,
        ss.dbt_valid_from as staff_dbt_valid_from,
        ss.dbt_valid_to as staff_dbt_valid_to
    from stg_staff ss 
    left join stg_address sa 
        on ss.staff_address_id = sa.address_id
    left join geographical_info gi 
        on sa.city_id = gi.city_id
)
select * from dim_staff 