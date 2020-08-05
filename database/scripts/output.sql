-- species per water body
COPY (
  SELECT
    species,
    count(water_name) as n
  FROM species
    LEFT JOIN species_water_joiner ON species.id = species_water_joiner.species_id
    LEFT JOIN fishable_waters ON species_water_joiner.water_id = fishable_waters.id
  GROUP BY species
  ORDER BY species
) TO '/Users/mitchellgritts/documents/projects/ndow/fish-nv/data/species-out.csv'
WITH CSV HEADER QUOTE '"';

-- water bodies and species array
COPY (
  SELECT
    water_name,
    county,
    string_agg(species, ', ') as species
  FROM fishable_waters
    LEFT JOIN species_water_joiner ON fishable_waters.id = species_water_joiner.water_id
    LEFT JOIN species ON species_water_joiner.species_id = species.id
  GROUP BY water_name, county
  ORDER BY water_name
) TO '/Users/mitchellgritts/documents/projects/ndow/fish-nv/data/waters-out.csv'
WITH CSV HEADER QUOTE '"';

-- mismatched water names from etl
COPY (
  SELECT DISTINCT
    water AS trophy_fish_water_name,
    name AS fishable_waters_water_name
  FROM etl.fish_entries
    LEFT JOIN etl.fishable_waters ON fish_entries.water = fishable_waters.name
  WHERE fishable_waters.name IS NULL
  ORDER BY water
) TO '/Users/mitchellgritts/documents/projects/ndow/fish-nv/data/tf-fw-name-mismatches.csv'
WITH CSV HEADER QUOTE '"';

-- the other wa
COPY (
  SELECT DISTINCT
    water AS trophy_fish_water_name,
    name AS fishable_waters_water_name
  FROM etl.fish_entries
    RIGHT JOIN etl.fishable_waters ON fish_entries.water = fishable_waters.name
  WHERE fish_entries.water IS NULL
  ORDER BY water
) TO '/Users/mitchellgritts/documents/projects/ndow/fish-nv/data/fw-tf-name-mismatches.csv'
WITH CSV HEADER QUOTE '"';
