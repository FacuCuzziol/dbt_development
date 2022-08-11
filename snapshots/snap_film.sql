{% snapshot snap_film %}

{{
    config(
        unique_key='film_id',
        strategy='timestamp',
        updated_at='last_update',
        invalidate_hard_deletes=True
    )
}}

    select 
        film_id,
        title,
        description,
        release_year,
        language_id,
        original_language_id,
        rental_duration,
        rental_rate,
        length,
        replacement_cost,
        rating,
        last_update,
        special_features,
        fulltext
    from {{ source('sakila','film') }}


{% endsnapshot %}