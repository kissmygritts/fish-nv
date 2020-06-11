SELECT
  json_build_object(
    'type', 'featureCollection',
    'features', json_agg(st_asgeojson(sq)::json)
  ) AS geojson
FROM (
  SELECT
    *
  FROM fishable_waters
  LIMIT 5
) AS sq