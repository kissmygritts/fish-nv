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