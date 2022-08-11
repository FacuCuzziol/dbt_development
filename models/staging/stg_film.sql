

with stg_film as (
    select 
        film_id,
        title as film_title,
        description,
        release_year,
        language_id,
        original_language_id,
        rental_duration,
        rental_rate,
        length,
        replacement_cost,
        rating,
        last_update as film_last_update,
        special_features,
        fulltext,
        dbt_updated_at,
        dbt_valid_from,
        dbt_valid_to
    from {{ ref('snap_film') }}
)
select * from stg_film sf
{% if is_incremental() %}  
    where sf.film_last_update > (select max(film_last_update) from {{ this }})
{% endif %}