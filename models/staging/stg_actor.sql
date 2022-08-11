
with stg_actor as (
    select
        actor_id,
        first_name,
        last_name,
        last_update as actor_last_update
    from 
    {{ source('sakila','actor') }} 
)
select
    *
from
    stg_actor sa 
{% if is_incremental() %}  
    where sa.actor_last_update > (select max(actor_last_update) from {{ this }})
{% endif %}
