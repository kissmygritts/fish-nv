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
