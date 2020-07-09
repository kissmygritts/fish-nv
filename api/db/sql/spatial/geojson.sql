SELECT
  json_build_object(
    'type', 'featureCollection',
    'features', json_agg(st_asGeoJSON(sq)::json)
  )::json AS geojson
FROM (
  SELECT
    $<columns:raw>
  FROM $<table:name>
) AS sq