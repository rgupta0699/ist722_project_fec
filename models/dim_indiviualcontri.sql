-- Join the necessary tables
with indi_contri as (
  select
    CMTE_ID,
    ENTITY_TP,
    NAME,
    CITY,
    STATE,
    ZIP_CODE,
    OTHER_ID
  from {{ source('STAGING','INDI_CONTRI') }}
),

-- Generate surrogate key
indi_contri_keys as (
  select
    ROW_NUMBER() OVER (ORDER BY CMTE_ID) as indiviual_contribution_key,
    CMTE_ID
  from indi_contri
)

-- Select columns and populate the final result set
select
  ick.indiviual_contribution_key as indiviual_contribution_key,
  ic.CMTE_ID as indiviual_contribution_id,
  ic.ENTITY_TP as entity_type,
  ic.NAME as contributor_name,
  ic.CITY as contributor_city,
  ic.STATE as contributor_state,
  ic.ZIP_CODE as contributor_sip,
  ic.OTHER_ID as other_id
from indi_contri ic
left join indi_contri_keys ick on ic.CMTE_ID = ick.CMTE_ID
