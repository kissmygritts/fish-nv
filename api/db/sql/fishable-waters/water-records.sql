SELECT
  species.id,
  fish_entries.water_id,
  species.species,
  fish_entries.fish_weight,
  fish_entries.pounds,
  fish_entries.ounces
FROM fish_entries
  JOIN (
    SELECT
      species_id,
      water_id,
      max(fish_weight) as fish_weight
    FROM fish_entries
    WHERE water_id = $<id>
    GROUP BY species_id, water_id
  ) AS fr 
  ON fish_entries.species_id = fr.species_id
    AND fish_entries.water_id = fr.water_id
    AND fish_entries.fish_weight = fr.fish_weight
  JOIN species ON fish_entries.species_id = species.id
ORDER BY species.species