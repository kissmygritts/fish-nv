/* FORMAT SPECIES NAMES WITH LKP TABLE */
CREATE TABLE etl.species_lkp (
  accdb_species text,
  fw_species text
);

-- lookup table
INSERT INTO etl.species_lkp (accdb_species, fw_species)
VALUES
  ('Bass, Largemouth', 'largemouth bass'),
  ('Bass, Smallmouth', 'smallmouth bass'),
  ('Bass, Spotted', 'spotted bass'),
  ('Bass, Striped', 'striped bass'),
  ('Bass, White', 'white bass'),
  ('Carp', 'carp'),
  ('Carp*', 'carp'),
  ('Catfish, Bullhead', 'bullhead catfish'),
  ('Catfish, Channel', 'channel catfish'),
  ('Catfish, White', 'white catfish'),
  ('Crappie, Black', 'black crappie'),
  ('Crappie, White', 'white crappie'),
  ('Muskie, Tiger', 'tiger muskie'),
  ('Perch, Sacramento', 'Sacramento perch'),
  ('Perch, Yellow', 'yellow perch'),
  ('Salmon, Kokanee', 'kokanee salmon'),
  ('Sunfish, BlueGill', 'bluegill sunfish'),
  ('Sunfish, Bluegill', 'bluegill sunfish'),
  ('Sunfish, Green', 'green sunfish'),
  ('Sunfish, Redear', 'redear sunfish'),
  ('Trout, Brook', 'brook trout'),
  ('Trout, Brown', 'brown trout'),
  ('Trout, Bull', 'bull trout'),
  ('Trout, Mackinaw', 'mackinaw trout'),
  ('Trout, Rainbow', 'rainbow trout'),
  ('Trout, Rainbow x Cutthroat', 'bowcutt trout'),
  ('Trout, Tiger', 'tiger trout'),
  ('Walleye', 'walleye'),
  ('Whitefish, Mountain', 'mountain whitefish'),
  ('Whitefish, Mountain*', 'mountain whitefish'),
  ('Wiper', 'wiper'),
  ('Wiper, White X Striped Bass Hybrid', 'wiper'),
  ('Wiper, White x Striped Bass Hybrid', 'wiper'),
  ('Sunfish, Pumpkinseed', 'pumpkinseed');

-- update species
UPDATE etl.fish_entries
SET
  species = species_lkp.fw_species
FROM etl.fish_entries s
  JOIN etl.species_lkp ON s.species = species_lkp.accdb_species
WHERE fish_entries.species = species_lkp.accdb_species;

-- deal with cutthroat
UPDATE etl.fish_entries
SET
  species = 'cutthroat trout'
WHERE species = 'Trout, Cutthroat';

-- delete species we don't want
DELETE
FROM etl.fish_entries
WHERE species IN ('Grayling, Arctic', 'Pike, Northern', 'Pike, Northern*', 'Salmon, Silver', 'Trout, Golden');

/* GET ID FROM SPECIES */
-- 1. alter table to include water_id
ALTER TABLE etl.fish_entries 
ADD species_id uuid;

-- 2. add id to etl table
UPDATE etl.fish_entries
SET species_id = species.species_id
FROM etl.fish_entries AS fe
  JOIN etl.species ON fe.species = species.species
WHERE fish_entries.species = species.species;

  JOIN(
    SELECT 
      fe.recno,
      fw.id
    FROM etl.fish_entries AS fe
      LEFT JOIN fishable_waters AS fw ON fe.water = fw.water_name AND fe.county = fw.county
    WHERE fw.id IS NOT NULL
  ) AS sq ON fe.recno = sq.recno
WHERE etl.fish_entries.recno = sq.recno;