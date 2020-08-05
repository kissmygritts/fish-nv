-- the query -> eventualy a materialized view
SELECT 
  id, water_name, species, coordinates
FROM (
  SELECT
    fw.id,
    fw.water_name,
    to_jsonb(species.species) AS species,
    json_build_array(
      st_Y(st_PointOnSurface(fw.geom)),
      st_X(st_PointOnSurface(fw.geom))
    ) as coordinates,
    to_tsvector(
      concat_ws(
        ' ',
        coalesce(fw.water_name, ''),
        coalesce(fw.region, ''),
        coalesce(fw.county, ''),
        coalesce(array_to_string(species.species, ', '), '')
      )
    ) as tokens
  FROM fishable_waters AS fw
    JOIN (
      SELECT
        species_water_joiner.water_id,
        array_agg(species.species) as species
      FROM species
        JOIN species_water_joiner ON species.id = species_water_joiner.species_id
      GROUP BY species_water_joiner.water_id
    ) AS species ON fw.id = species.water_id
  ) as document
WHERE tokens @@ websearch_to_tsquery($<s:csv>)
ORDER BY water_name
