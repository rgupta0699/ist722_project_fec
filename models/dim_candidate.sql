-- Join the necessary tables
with candidate_master as (
  select
    CAND_ID,
    CAND_NAME,
    CAND_PTY_AFFILIATION,
    CAND_ZIP
  from {{ source('STAGING','CANDIDATE_MASTER') }}
),

house_senate_campaigns as (
  select
    CAND_ID,
    CAND_OFFICE_ST,
    CAND_OFFICE_DISTRICT
  from  {{ source('STAGING','HOUSE_SENATE_CAMPAIGNS') }}
),

-- Generate surrogate key
candidate_keys as (
  select
    CAND_ID,
    ROW_NUMBER() OVER (ORDER BY CAND_ID) as CANDKEY
  from candidate_master
)

-- Select distinct columns to populate dim_candidate
select
    
  ck.CANDKEY as CANDIDATE_KEY,
  cm.CAND_ID,
  cm.CAND_NAME,
  cm.CAND_PTY_AFFILIATION,
  hsc.CAND_OFFICE_ST as candidate_office_state,
  hsc.CAND_OFFICE_DISTRICT as candidate_office_district,
  cm.CAND_ZIP as candidate_mailing_zip
from candidate_keys ck
left join candidate_master cm on ck.CAND_ID = cm.CAND_ID
left join house_senate_campaigns hsc on cm.CAND_ID = hsc.CAND_ID
