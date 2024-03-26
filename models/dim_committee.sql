-- Join the necessary tables
with committee as (
  select
    CMTE_ID,
    CMTE_NM,
    CMTE_TP,
    CMTE_DSGN,
    CMTE_PTY_AFFILIATION,
    CMTE_ST,
    CMTE_CITY,
    CMTE_ST1,
    CMTE_ST2,
    CMTE_ZIP
  from {{ source('STAGING','COMMITTEE_MASTER') }}
),

-- Generate surrogate key
committee_keys as (
  select
    ROW_NUMBER() OVER (ORDER BY CMTE_ID) as committee_key,
    CMTE_ID
  from committee
)

-- Select columns and populate the final result set
select
  ck.committee_key as committee_key,
  c.CMTE_ID as committee_id,
  c.CMTE_NM as committee_name,
  c.CMTE_TP as committee_type,
  c.CMTE_DSGN as committee_designation,
  c.CMTE_PTY_AFFILIATION as committee_party_affiliation,
  c.CMTE_ST as committee_state,
  c.CMTE_CITY as committee_city,
  c.CMTE_ST1 as committee_street_1,
  c.CMTE_ST2 as committee_street2,
  c.CMTE_ZIP as committee_zipcode,
from committee c
left join committee_keys ck on c.CMTE_ID = ck.CMTE_ID
