/* LOAD FISHABLE WATER DATA INTO DATABASE */
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

/* MINIMUM TROPHY WEIGHTS */
CREATE TABLE etl.min_trophy_weight (
  species text,
  min_trophy_weight numeric
);

INSERT INTO etl.min_trophy_weight (
  species, min_trophy_weight
)
VALUES
  ('largemouth bass', 5),
  ('smallmouth bass', 3),
  ('spotted bass', 2),
  ('striped bass', 20),
  ('white bass', 2),
  ('carp', 15),
  ('bullhead catfish', 1),
  ('channel catfish', 10),
  ('white catfish', 2),
  ('black crappie', 2),
  ('white crappie', 2),
  ('sacramento perch', 2),
  ('yellow perch', 0.5),
  ('kokanee salmon', 2),
  ('bluegill sunfish', 1),
  ('green sunfish', 0.5),
  ('pumpkinseed', 0.5),
  ('redear sunfish', 0.5),
  ('brook trout', 2),
  ('brown trout', 5),
  ('bull trout', 0.5),
  ('cutthroat trout', 10),
  ('mackinaw trout', 10),
  ('rainbow trout', 5),
  ('bowcutt trout', 10),
  ('tiger trout', 2),
  ('walleye', 6),
  ('whitefish', 1),
  ('wiper', 5),
  ('arctic grayling', 0.5),
  ('northern pike', 10),
  ('silver salmon', 5);

-- update species table with minimum trophy weight
UPDATE public.species
SET min_trophy_weight = sq.min_trophy_weight
FROM public.species AS t 
JOIN (
  SELECT
    species.id,
    etl.min_trophy_weight.min_trophy_weight
  FROM species
    LEFT JOIN etl.min_trophy_weight ON species.species = min_trophy_weight.species
) as sq ON t.id = sq.id
WHERE public.species.id = sq.id;
/* FIX COUNTIES */
-- -- the test query
-- SELECT 
--   county,
--   count(county) as n
-- FROM etl.fish_entries 
-- GROUP BY county
-- ORDER BY county;

-- -- crate column to work on
ALTER TABLE etl.fish_entries
ADD raw_county text;

UPDATE etl.fish_entries
SET raw_county = county;

-- -- 1. Carson City 
UPDATE etl.fish_entries
SET county = 'Carson City'
WHERE county ilike '%carson%'
  OR county ilike '%cc%';

-- -- 2. Churchill
UPDATE etl.fish_entries
SET county = 'Churchill'
WHERE county ilike '%churchill%'
  OR county ilike '%ch%';

-- -- 3. Clark
UPDATE etl.fish_entries
SET county = 'Clark'
WHERE county ilike '%clark%'
  OR county ilike '%cl%';

-- -- 4. Douglass
UPDATE etl.fish_entries
SET county = 'Douglas'
WHERE county ilike '%douglas%'
  OR county ilike 'do%';

-- -- 5. Elko
UPDATE etl.fish_entries
SET county = 'Elko'
WHERE county in ('EL', 'Elka', 'Elko', 'elko');

-- -- 6. Esmeralda & Eureka are ok

-- -- 7. Humboldt
UPDATE etl.fish_entries
SET county = 'Humboldt'
WHERE county ilike '%humbol%'
  OR county ilike 'hu%';

-- -- 8. Lander
UPDATE etl.fish_entries
SET county = 'Lander'
WHERE county ilike '%lander%'
  OR county ilike 'la%';

-- -- 9. Lincoln is ok

-- -- 10. Lyon
UPDATE etl.fish_entries
SET county = 'Lyon'
WHERE county ilike '%lyon%'
  OR county ilike 'ly%';

-- -- 11. Mineral is ok

-- -- 12. Nye
UPDATE etl.fish_entries
SET county = 'Nye'
WHERE county ilike 'ny%';

-- -- 13. Pershing is okay

-- -- 14. Storey
UPDATE etl.fish_entries
SET county = 'Storey'
WHERE county ilike '%storey%'
  OR county ilike 'st%';

-- -- 15. Washoe
UPDATE etl.fish_entries
SET county = 'Washoe'
WHERE county ilike 'wa%';

-- -- 16. White Pine
UPDATE etl.fish_entries
SET county = 'White Pine'
WHERE county ilike '%white pine%'
  OR county ilike 'wp%';

/* POUNDS AND OUNCES FIXES */
-- null values to "0"
UPDATE etl.fish_entries
SET pounds = '0'
WHERE pounds IS NULL;

UPDATE etl.fish_entries
SET ounces = '0'
WHERE ounces IS NULL;

/* ANGLER LOCATION CLEANUP */
UPDATE etl.fish_entries
SET state = upper(trim(both ' ' from state));

/* TACKEL CLEANUP */
UPDATE etl.fish_entries
SET tackle = NULL
WHERE tackle = '-0-';

UPDATE etl.fish_entries
SET tackle = lower(tackle);

/* TROPHY FISH WATER NAME CLEANUP */
-- TODO: total of 197 waters that need cleaned. Best to
-- do it in the Access database to clean up the records.
-- Not all waters in the trophy fish have matches in the
-- fishable waters data.
-- use the query below to identify these waters without matches

-- SELECT DISTINCT
--   fe.water,
--   fe.county,
--   count(fe.water) as fish_caught
-- FROM etl.fish_entries AS fe
--   LEFT JOIN fishable_waters AS fw 
--     ON fe.water = fw.water_name
--     AND fe.county = fw.county
-- WHERE fw.id IS NULL
-- GROUP BY fe.water, fe.county
-- ORDER BY fe.water;


/* GET ID FROM FISHABLE WATERS */
-- 1. alter table to include water_id
ALTER TABLE etl.fish_entries 
ADD water_id uuid;

-- 2. add id to etl table
UPDATE etl.fish_entries
SET water_id = sq.id
FROM etl.fish_entries AS fe
  JOIN(
    SELECT 
      fe.recno,
      fw.id
    FROM etl.fish_entries AS fe
      LEFT JOIN fishable_waters AS fw ON fe.water = fw.water_name AND fe.county = fw.county
    WHERE fw.id IS NOT NULL
  ) AS sq ON fe.recno = sq.recno
WHERE etl.fish_entries.recno = sq.recno;
/* LOAD TROPHY FISH DATA INTO PUBLIC TABLES */
INSERT INTO public.fish_entries (
  species_id, water_id, date_caught, pounds, ounces,
  fish_weight, fish_length, fish_girth, tackle,
  angler_name, angler_city, angler_state
)
SELECT 
  fe.species_id,
  fe.water_id,
  fe.date_cat::date AS date_caught,
  fe.pounds::int,
  fe.ounces::int,
  fe.pounds::int * 16 + fe.ounces::int AS fish_weight,
  fe.length::real AS fish_length,
  fe.girth::real AS fish_girth,
  fe.tackle AS tackle,
  fe.ang_name AS angler_name,
  fe.city AS angler_city,
  fe.state AS angler_state
FROM etl.fish_entries AS fe
WHERE fe.species_id IS NOT NULL
  AND fe.water_id IS NOT NULL;
