{{
    config(
        materialized='table'
    )
}}

with stg_rental as (
    select 
        rental_id,
        customer_id,
        inventory_id,
        staff_id,
        rental_date as timestamp_rental_date,
        return_date as timestamp_return_date,
        rental_last_update,
        date(rental_date) as rental_date,
        date(return_date) as return_date

    from {{ ref('stg_rental') }} sr
),
stg_inventory as (
    select  
        inventory_id,
        film_id,
        store_id
    from {{ ref('stg_inventory') }}
),
stg_payment as (
    select 
        payment_id,
        customer_id,
        rental_id,
        payment_amount,
        payment_date
    from {{ ref('stg_payment') }}
),
stg_rental_film as (
    select
        sr.rental_id,
        sr.customer_id,
        si.film_id,
        si.store_id,
        sr.staff_id,
        sr.rental_date,
        sr.return_date
    from stg_rental sr
    left join stg_inventory si 
        on sr.inventory_id = si.inventory_id
),
payment_amount_sum as (
    select 
        sp.rental_id,
        sum(sp.payment_amount) as rental_payment_amount
    from stg_payment sp
    group by 1
),
fct_rental as (
    select 
        srf.rental_id,
        srf.customer_id,
        srf.film_id,
        srf.staff_id,
        srf.store_id,
        {{ dbt_date.to_unixtimestamp('rental_date') }} as date_id_rental,
        {{ dbt_date.to_unixtimestamp('return_date') }} as date_id_return,
        pas.rental_payment_amount
    from stg_rental_film srf
    left join payment_amount_sum pas 
        on srf.rental_id = pas.rental_id
)
select * from fct_rental

