{{
    config(
        materialized='view'
    )
}}

with stg_film as (
    select
        film_id,
        film_title,
        description,
        release_year,
        language_id,
        rental_duration,
        rental_rate,
        length,
        replacement_cost,
        rating,
        film_last_update,
        special_features,
        dbt_updated_at,
        dbt_valid_from,
        dbt_valid_to
    from
    {{ ref('stg_film') }}
    where dbt_valid_to is null
),
stg_film_category as (
    select 
        film_id,
        category_id,
        film_category_last_update
    from 
    {{ref('stg_film_category')}}
),
stg_category as (
    select
        category_id,
        category_name,
        category_last_update
    from 
    {{ref('stg_category')}}
),
stg_language as (
    select
        language_id,
        language_name,
        language_last_update
    from {{ref('stg_language')}}
),
dim_film as (
    select
        sf.film_id,
        sf.film_title,
        sf.description,
        sf.release_year,
        sl.language_name,
        sf.rental_duration,
        sf.rental_rate,
        sf.length,
        sf.replacement_cost,
        sf.rating,
        sc.category_name,
        sf.film_last_update,
        sf.special_features,
        sf.dbt_updated_at,
        sf.dbt_valid_from,
        sf.dbt_valid_to
    from 
    stg_film sf
    left join stg_film_category sfc
        on sf.film_id = sfc.film_id
    left join stg_category sc
        on sfc.category_id = sc.category_id
    left join stg_language sl
        on sf.language_id = sl.language_id
)
select * from dim_film
order by film_id