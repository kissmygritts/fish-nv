-- SELECT * FROM fishable_waters_route
-- WHERE id = $<id>;  

SELECT
  fw.id,
  fw.water_name,
  fw.label,
  fw.region,
  fw.county,
  species.species_arr AS species,
  st_asGeoJSON(geom, 5)::json AS geojson
FROM fishable_waters AS fw
  JOIN (
    SELECT
      species_water_joiner.water_id,
      jsonb_agg(species.species) as species_arr
    FROM species
      JOIN species_water_joiner ON species.id = species_water_joiner.species_id
    GROUP BY species_water_joiner.water_id
  ) AS species ON fw.id = species.water_id
WHERE id = $<id>