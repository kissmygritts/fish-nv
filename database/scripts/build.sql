BEGIN;

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA etl;

CREATE TABLE etl.species (
  abbr text,
  species text
);

CREATE TABLE etl.species_water_joiner (
  label text,
  abbr text,
  species text
);

-- fisheries species from the trophy database
CREATE TABLE etl.fs (
  id int,
  species text,
  min_tropy_weight text,
  tf_db_name text
);

CREATE TABLE etl.fish_entries (
  recno int,
  species text,
  date_cat text,
  pounds text,
  ounces text,
  length text,
  girth text,
  water text,
  county text,
  tackle text,
  ang_name text,
  ang_age text,
  ang_res text,
  city text,
  state text,
  zip text,
  date_rec text,
  picture text,
  data_entry text,
  date_entered text
);

-- create tables in public schema to load into
CREATE TABLE public.species (
  id uuid PRIMARY KEY default uuid_generate_v4(),
  species text NOT NULL,
  abbr text
);

CREATE TABLE public.fishable_waters (
  id uuid PRIMARY KEY default uuid_generate_v4(),
  water_name text NOT NULL,
  label text NOT NULL,
  county text,
  region text,
  geom geometry(Geometry, 4326) NOT NULL
);

CREATE TABLE public.species_water_joiner (
  id uuid PRIMARY KEY default uuid_generate_v4(),
  species_id uuid references species(id),
  water_id uuid references fishable_waters(id)
);

CREATE TABLE public.fish_entries (
  id uuid PRIMARY KEY default uuid_generate_v4(),
  species_id uuid references species(id),
  water_id uuid references fishable_waters(id),
  date_caught date,
  pounds int,
  ounces int,    
  fish_weight int,  -- in ounces
  fish_length real,
  fish_girth real,
  tackle text,
  angler_name text,
  angler_city text,
  angler_state text,
  exceptions text
);

/* VIEW FOR FISHABLE WATER API ENDPOINT */
CREATE OR REPLACE VIEW fishable_waters_route AS
  SELECT
    fw.id,
    fw.water_name,
    fw.label,
    fw.region,
    fw.county,
    species.species_arr AS species,
    (
      SELECT jsonb_agg(row_to_json(fe))
      FROM (
        SELECT
          species.species,
          fish_entries.water_id,
          fish_entries.date_caught,
          fish_entries.pounds,
          fish_entries.ounces,
          fish_entries.fish_weight,
          fish_entries.fish_length,
          fish_entries.angler_name,
          fish_entries.angler_city,
          fish_entries.angler_state
        FROM fish_entries
          JOIN species ON fish_entries.species_id = species.id
        WHERE fish_entries.water_id = fw.id
        ORDER BY species.species, fish_entries.fish_weight DESC
      ) AS fe
    ) AS fish_entries,
    st_asGeoJSON(geom, 5) as geojson
  FROM fishable_waters AS fw
    JOIN (
      SELECT
        species_water_joiner.water_id,
        jsonb_agg(species.species) as species_arr
      FROM species
        JOIN species_water_joiner ON species.id = species_water_joiner.species_id
      GROUP BY species_water_joiner.water_id
    ) AS species ON fw.id = species.water_id;

COMMIT;
