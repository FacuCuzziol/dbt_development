

with stg_language as (
    select 
        language_id,
        name as language_name,
        last_update as language_last_update
    from {{ source('sakila','language') }}
)
select * from stg_language sl
{% if is_incremental() %}  
    where sl.language_last_update > (select max(language_last_update) from {{ this }})
{% endif %}