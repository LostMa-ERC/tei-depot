select
  s.preferred_name AS story,
  t.*
from
  (
  select
    UNNEST(t."is_expression_of H-ID") as story_id,
    t."H-ID" text_id,
    any_value(t.preferred_name) text_name,
    any_value(t.tradition_status) text_status,
    any_value(t.literary_form) text_form,
    any_value(t.language_COLUMN) text_lang,
    date_trunc('day', any_value(t.date_of_creation).estMinDate) text_earliest,
    date_trunc('day', any_value(t.date_of_creation).estMaxDate) as text_latest,
    sum(case when w.status_witness like 'complete' then 1 else 0 end) as wit_count_complete,
    sum(case when w.status_witness like 'defective' then 1 else 0 end) as wit_count_defective,
    sum(case when w.status_witness like 'fragmentary' then 1 else 0 end) as wit_count_fragmentary,
    sum(case when w.status_witness like 'lost' then 1 else 0 end) as wit_count_lost,
    count(w.status_witness) wits_total,
    date_trunc('day', min(w.date_of_creation.estMinDate)) earliest_wit,
    date_trunc('day', max(w.date_of_creation.estMaxDate)) latest_wit
  from TextTable t
  left join Witness w on t."H-ID" = w."is_manifestation_of H-ID"
  where t.is_hypothetical like 'No'
  and t.peripheral like 'No'
  and t.tradition_status not like 'lost'
  group by (t."H-ID", t."is_expression_of H-ID")
) t
left join Story s on s."H-ID" = t.story_id
order by (t.story_id, t.text_earliest);