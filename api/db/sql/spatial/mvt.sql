WITH mvtgeom AS (
  SELECT
    ST_AsMVTGeom (
      ST_Transform(geom, 3857),
      ST_TileEnvelope($<z>,$<x>, $<y>)
    ) as geom,
    id,
    water_name
  FROM $<table>, (
    SELECT ST_SRID(geom) AS srid FROM $<table> LIMIT 1
  ) a
  WHERE
    ST_Intersects(
      geom,
      ST_Transform(
        ST_TileEnvelope($<z>,$<x>, $<y>),
        srid
      )
    )
)

SELECT ST_AsMVT(mvtgeom.*, 'fishable_waters'::text, 4096, 'geom'::text) AS mvt from mvtgeom;
