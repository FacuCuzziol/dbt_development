{% snapshot snap_customer %}

{{
    config(
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='last_update',
        invalidate_hard_deletes=True
    )
}}

    select 
        customer_id,
        store_id,
        first_name,
        last_name,
        email,
        address_id,
        activeboolean as activebool,
        create_date,
        last_update,
        active
    from {{ source('sakila','customer') }}


{% endsnapshot %}