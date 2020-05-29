BEGIN;

--
INSERT INTO public.species (
  species, abbr
)
SELECT
  etl.species.species,
  etl.species.abbr
FROM etl.species;

--
INSERT INTO public.fishable_waters (
  water_name, label, county, region, geom
)
SELECT
  etl.fishable_waters.name,
  etl.fishable_waters.label,
  etl.fishable_waters.county,
  etl.fishable_waters.region,
  etl.fishable_waters.geom
FROM etl.fishable_waters;

--
INSERT INTO  public.species_water_joiner (
  species_id, water_id
)
SELECT
  public.species.id,
  public.fishable_waters.id
FROM etl.species_water_joiner
  LEFT JOIN public.species ON etl.species_water_joiner.abbr = public.species.abbr
  LEFT JOIN public.fishable_waters ON etl.species_water_joiner.label = public.fishable_waters.label;

COMMIT;