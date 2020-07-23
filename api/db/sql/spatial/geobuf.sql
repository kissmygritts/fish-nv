SELECT
  st_asGeobuf(sq, 'geom')
FROM (
  SELECT
    id,
    water_name,
    geom
  FROM fishable_waters
) AS sq
