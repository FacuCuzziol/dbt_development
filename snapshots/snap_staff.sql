{% snapshot snap_staff %}

{{
    config(
        unique_key='staff_id',
        strategy='timestamp',
        updated_at='last_update',
        invalidate_hard_deletes=True
    )
}}

    select 
        staff_id,
        first_name,
        last_name,
        address_id,
        email,
        store_id,
        active,
        last_update
    from {{ source('sakila','staff') }}


{% endsnapshot %}