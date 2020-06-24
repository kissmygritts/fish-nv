SELECT
  count(*)
FROM fish_entries
  JOIN species ON fish_entries.species_id = species.id
$<where:raw>