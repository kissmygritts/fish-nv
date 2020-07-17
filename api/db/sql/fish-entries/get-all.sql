-- SELECT
--   species.species,
--   fish_entries.water_id,
--   fish_entries.date_caught,
--   fish_entries.pounds,
--   fish_entries.ounces,
--   fish_entries.fish_weight,
--   fish_entries.fish_length,
--   fish_entries.angler_name,
--   fish_entries.angler_city,
--   fish_entries.angler_state
-- FROM fish_entries
--   JOIN species ON fish_entries.species_id = species.id
SELECT
  fish_entries.id,
  fish_entries.species_id,
  tc.species,
  fish_entries.water_id,
  fishable_waters.water_name,
  fish_entries.date_caught,
  fish_entries.pounds,
  fish_entries.ounces,
  fish_entries.fish_weight,
  fish_entries.fish_length,
  fish_entries.angler_name,
  fish_entries.angler_state,
  tc.trophy_classification
FROM fish_entries
  JOIN (
    SELECT
      fish_entries.id,
      species.species,
      COALESCE(
        CASE
          WHEN fish_entries.fish_weight >= state_records.state_record THEN 'state record'
          ELSE NULL
        END,
        CASE
          WHEN fish_entries.fish_weight >= water_records.water_record_weight THEN 'water record'
          ELSE NULL
        END,
        CASE
          WHEN fish_entries.fish_weight >= (species.min_trophy_weight * 16) THEN 'trophy fish'
          ELSE NULL
        END
      ) AS trophy_classification
    FROM species
      JOIN fish_entries ON species.id = fish_entries.species_id
      JOIN (
        -- get state records
        SELECT
          species_id,
          max(fish_weight) as state_record
        FROM fish_entries
        GROUP BY species_id
      ) AS state_records ON fish_entries.species_id = state_records.species_id
      JOIN (
        -- get water records
        SELECT
          water_id,
          species_id,
          max(fish_weight) AS water_record_weight
        FROM fish_entries
        GROUP BY water_id, species_id
        ORDER BY water_id, species_id    
      ) AS water_records ON fish_entries.species_id = water_records.species_id
        AND fish_entries.water_id = water_records.water_id
    ) AS tc ON fish_entries.id = tc.id
  JOIN fishable_waters ON fish_entries.water_id = fishable_waters.id
$<where:raw>
$<order:raw>
$<pagination:raw>