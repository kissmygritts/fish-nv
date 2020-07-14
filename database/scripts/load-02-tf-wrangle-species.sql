/* FORMAT MISSING SPECIES NAMES */
-- 1. create new column for Access DB species name
ALTER TABLE etl.fs
  ADD accdb_species_name text;

-- 2. move copy species to accdb_species_name
UPDATE etl.fs
  SET accdb_species_name = species;

-- 3. format species names that are missing from 
--    the fishable waters database in the same 
--    style as the fishable waters database.
UPDATE etl.fs
SET 
  species = s.species_name
FROM etl.fs as t
  JOIN (
    -- this subquery is formatting the species name from the Access database
    -- eg: Trout, Brown -> brown trout, etc
    SELECT
      id,
      CASE
        WHEN comma = 0 THEN lower(species)
        WHEN comma > 0 THEN lower(rhs || ' ' || lhs)
      END AS species_name
    FROM (
      -- prepping species name for the case statement above
      SELECT
        id,
        species,
        position(',' in species) AS comma,
        left(species, position(',' in species) - 1) AS lhs,
        trim(both ' ' from right(species, char_length(species) - position(',' in species))) AS rhs
      FROM etl.fs
      WHERE tf_db_name IS NULL
    ) AS sp
  ) AS s ON t.id = s.id
WHERE etl.fs.id = s.id;

-- 4. append formated species names to public.species
INSERT INTO public.species 
  (species)
SELECT 
  etl.fs.species
FROM etl.fs
  LEFT JOIN species ON etl.fs.tf_db_name = species.species
WHERE species.species IS NULL;

/* THESE GET UPDATED IN THE ETL.FS TABLE WITH THE ID */
-- 1. move species to the tf_db_name where null
UPDATE etl.fs
  set tf_db_name = species
WHERE tf_db_name IS NULL;

-- 2. alter the table
ALTER TABLE etl.fs
  ADD species_id uuid;

-- 3. then add id from species table
UPDATE etl.fs
SET species_id = species.id
FROM species
WHERE etl.fs.tf_db_name = species.species;

/* ADD SPECIES_ID TO THE ETL.FISH_ENTRIES TABLE */
-- 1. add species_id to table
ALTER TABLE etl.fish_entries
  ADD species_id uuid;

-- 2. update species_id to species.id
UPDATE etl.fish_entries
SET species_id = etl.fs.species_id
FROM etl.fish_entries as t
  JOIN etl.fs on t.species = etl.fs.accdb_species_name
WHERE etl.fish_entries.species = etl.fs.accdb_species_name;

-- 3. update the singleton errors, 
--    the only reason I know these exist is because
--    of the following query. Subsequent updates query 
--    might need to change in the future. 
--    Query commented out for etl from Makefile

-- SELECT
--   etl.fs.species_id,
--   etl.fs.accdb_species_name,
--   etl.fish_entries.species,
--   etl.fish_entries.species_id
-- FROM etl.fish_entries
--   LEFT JOIN etl.fs 
--     ON etl.fish_entries.species = etl.fs.accdb_species_name
-- WHERE etl.fs.species_id IS NULL;

-- 4. Wiper
UPDATE etl.fish_entries
SET species_id = sq.species_id
FROM (
  SELECT 
    species_id 
  FROM etl.fs
  WHERE tf_db_name = 'wiper'
) AS sq
WHERE etl.fish_entries.species IN ('Wiper', 'Wiper, White X Striped Bass Hybrid');

-- 5. Sunfish BlueGill -> bluegill sunfish
UPDATE etl.fish_entries
SET species_id = sq.species_id
FROM (
  SELECT 
    species_id 
  FROM etl.fs
  WHERE tf_db_name = 'bluegill sunfish'
) AS sq
WHERE etl.fish_entries.species = 'Sunfish, BlueGill';

-- 6. Whitefish, Mountain* -> whitefish
--    note, that the asterisk will need to be included
--    in an exceptions column as unofficail state record
UPDATE etl.fish_entries
SET species_id = sq.species_id
FROM (
  SELECT 
    species_id 
  FROM etl.fs
  WHERE tf_db_name = 'whitefish'
) AS sq
WHERE etl.fish_entries.species = 'Whitefish, Mountain*';

-- 7. Carp* -> carp
UPDATE etl.fish_entries
SET species_id = sq.species_id
FROM (
  SELECT 
    species_id 
  FROM etl.fs
  WHERE tf_db_name = 'carp'
) AS sq
WHERE etl.fish_entries.species = 'Carp*';

-- 8. Pike, Northern* -> northern pike
UPDATE etl.fish_entries
SET species_id = sq.species_id
FROM (
  SELECT 
    species_id 
  FROM etl.fs
  WHERE tf_db_name = 'northern pike'
) AS sq
WHERE etl.fish_entries.species = 'Pike, Northern*';

/* INSERT SPECIES DESCRIPTIONS */
-- update scientific name
UPDATE public.species
SET scientific_name = sq.scientific_name
FROM public.species AS t 
JOIN (
  SELECT
    species.id,
    species_descriptions.scientific_name
  FROM species
  JOIN etl.species_descriptions ON species.species = species_descriptions.species
) as sq ON t.id = sq.id
WHERE public.species.id = sq.id;

-- update description
UPDATE public.species
SET description = sq.description
FROM public.species AS t 
JOIN (
  SELECT
    species.id,
    species_descriptions.description
  FROM species
  JOIN etl.species_descriptions ON species.species = species_descriptions.species
) as sq ON t.id = sq.id
WHERE public.species.id = sq.id;

-- update other names
UPDATE public.species
SET other_names = sq.other_names
FROM public.species AS t 
JOIN (
  SELECT
    species.id,
    species_descriptions.other_names
  FROM species
  JOIN etl.species_descriptions ON species.species = species_descriptions.species
) as sq ON t.id = sq.id
WHERE public.species.id = sq.id;
