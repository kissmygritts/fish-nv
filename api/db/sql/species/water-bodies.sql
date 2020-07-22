SELECT
  json_build_object(
    'type', 'featureCollection',
    'features', json_agg(st_asGeoJSON(sq)::json)
  )::json AS geojson
FROM (
  SELECT
    -- add species array here?
    fishable_waters.id,
    fishable_waters.water_name,
    fishable_waters.geom
  FROM species
    JOIN species_water_joiner ON species.id = species_water_joiner.species_id
    JOIN fishable_waters ON species_water_joiner.water_id = fishable_waters.id
  WHERE species.id = $/id/
) as sq