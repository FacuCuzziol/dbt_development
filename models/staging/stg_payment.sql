

with stg_payment as (
    select 
        payment_id,
        customer_id,
        staff_id,
        rental_id,
        amount as payment_amount,
        payment_date
    from {{ source('sakila','payment') }}
)
select * from stg_payment sp
{% if is_incremental() %}  
    where sp.payment_date > (select max(payment_date) from {{ this }})
{% endif %}