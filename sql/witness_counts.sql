select
  s."H-ID" story_id,
  s.preferred_name AS story,
  text_id,
  text_name,
  text_earliest,
  text_latest,
  text_lang,
  wit_count,
  date_trunc('day', earliest_wit) earliest_wit,
  date_trunc('day', latest_wit) as latest_wit
from
  (
  select
    UNNEST(t."is_expression_of H-ID") as text_story,
    t."H-ID" text_id,
    any_value(t.preferred_name) text_name,
    date_trunc('day', any_value(t.date_of_creation).estMinDate) text_earliest,
    date_trunc('day', any_value(t.date_of_creation).estMaxDate) as text_latest,
    count(*) wit_count,
    any_value(t.language_COLUMN) text_lang,
    min(w.date_of_creation.estMinDate) earliest_wit,
    max(w.date_of_creation.estMaxDate) latest_wit
  from TextTable t
  left join Witness w on t."H-ID" = w."is_manifestation_of H-ID"
  group by (t."H-ID", t."is_expression_of H-ID")
)
left join Story s on s."H-ID" = text_story
order by (story_id, text_earliest);