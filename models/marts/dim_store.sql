{{
    config(
        materialized='view'
    )
}}

with stg_store as (
    select 
        store_id,
        store_address_id,
        manager_staff_id,
        store_last_update,
        dbt_updated_at,
        dbt_valid_from,
        dbt_valid_to
    from {{ ref('stg_store') }}
    where dbt_valid_to is null
),
stg_staff as (
    select
        staff_id,
        first_name,
        last_name
    from {{ ref('stg_staff') }}
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
dim_store as (
    select
        ss.store_id,
        sa.address_name,
        sa.district,
        sa.postal_code,
        gi.city_name,
        gi.country_name,
        sf.first_name as manager_staff_first_name,
        sf.last_name as manager_staff_last_name,
        ss.dbt_updated_at as store_dbt_updated_at,
        ss.dbt_valid_from as store_dbt_valid_from,
        ss.dbt_valid_to as store_dbt_valid_to
    from stg_store ss
    left join stg_staff sf
        on ss.manager_staff_id = sf.staff_id
    left join stg_address sa 
        on ss.store_address_id = sa.address_id
    left join geographical_info gi 
        on sa.city_id = gi.city_id
    order by ss.store_id
)
select * from dim_store