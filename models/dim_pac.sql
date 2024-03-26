-- Join the necessary tables
with pac_summary as (
  select
    CMTE_ID,
    CMTE_NM,
    CMTE_TP,
    CMTE_DSGN,
    INDV_CONTRIB
  from {{ source('STAGING','PAC_SUMMARY') }}
),

-- Generate surrogate key
pac_keys as (
  select
    CMTE_ID,
    ROW_NUMBER() OVER (ORDER BY CMTE_ID) as pac_key
  from pac_summary
)

-- Select columns and populate the final result set
select
  pk.pac_key as pac_key,
  ps.CMTE_ID AS pac_id,
  ps.CMTE_NM AS committee_name,
  ps.CMTE_TP as committee_type,
  ps.CMTE_DSGN as committee_designation,
  ps.INDV_CONTRIB as indiviual_contribution
from pac_keys pk
left join pac_summary ps on pk.CMTE_ID = ps.CMTE_ID