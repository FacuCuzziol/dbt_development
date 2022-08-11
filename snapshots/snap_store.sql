{% snapshot snap_store %}

{{
    config(
        unique_key='store_id',
        strategy='timestamp',
        updated_at='last_update',
        invalidate_hard_deletes=True
    )
}}

    select 
        store_id,
        manager_staff_id,
        address_id,
        last_update
    from {{ source('sakila','store') }}


{% endsnapshot %}