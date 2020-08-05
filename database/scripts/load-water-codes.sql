CREATE TABLE etl.water_codes (
  water_code text,
  water_name text,
  county text,
  mountain_range text,
  tributary text,
  legal_description text,
  fish_species_list text,
  comments text,
  date_entered text,
  strain text
);

-- upload
-- psql trophy_fish -c \
--   "\copy etl.water_codes from '/Users/mitchellgritts/Documents/projects/ndow/fish-nv/data/water-codes.csv' with csv header"

--


-- export
COPY (
  SELECT
    fid,
    name,
    fishable_waters.county,
    water_codes.*
  FROM etl.fishable_waters
    LEFT JOIN etl.water_codes ON lower(fishable_waters.name) = lower(water_codes.water_name)
      AND fishable_waters.county = water_codes.county
  ORDER BY name
)
TO '/Users/mitchellgritts/documents/projects/ndow/fish-nv/data/fw-codes.csv'
WITH CSV HEADER QUOTE '"';
