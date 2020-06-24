SELECT
  species.species,
  fish_entries.water_id,
  fish_entries.date_caught,
  fish_entries.pounds,
  fish_entries.ounces,
  fish_entries.fish_weight,
  fish_entries.fish_length,
  fish_entries.angler_name,
  fish_entries.angler_city,
  fish_entries.angler_state
FROM fish_entries
  JOIN species ON fish_entries.species_id = species.id
$<where:raw>
$<order:raw>
$<pagination:raw>