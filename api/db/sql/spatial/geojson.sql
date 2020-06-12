SELECT
  json_build_object(
    'type', 'featureCollection',
    'features', json_agg(st_asgeojson(sq)::json)
  ) AS geojson
FROM (
  SELECT
    geom
    $<columns:raw>
  FROM $<table:name>
  LIMIT 3
) AS sq