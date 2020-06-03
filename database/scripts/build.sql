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

COMMIT;