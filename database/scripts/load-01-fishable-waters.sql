/* LOAD FISHABLE WATER DATA INTO DATABASE */

-- Create and assign UUID to species in the etl table
ALTER TABLE etl.species
  ADD species_id uuid;

UPDATE etl.species
  SET species_id = uuid_generate_v4();

INSERT INTO public.species (
  id, species, abbr, scientific_name, min_trophy_weight, description
)
SELECT
  etl.species.species_id AS id,
  etl.species.species,
  etl.species.abbr,
  etl.species.scientific_name,
  etl.species.min_trophy_weight::numeric,
  etl.species.description
FROM etl.species;

-- Create and assign UUID to fishable waters in etl table
ALTER TABLE etl.fishable_waters
  ADD water_id uuid;

UPDATE etl.fishable_waters
  SET water_id = uuid_generate_v4();

INSERT INTO public.fishable_waters (
  id, water_name, label, county, region, geom
)
SELECT
  etl.fishable_waters.water_id AS id,
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
  species.species_id,
  fishable_waters.water_id
FROM etl.species_water_joiner
  JOIN etl.species ON etl.species_water_joiner.species = etl.species.abbr
  JOIN etl.fishable_waters ON etl.species_water_joiner.label = etl.fishable_waters.id;