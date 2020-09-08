/* DELETE FISH SPECIES NAME CLEANUP */
-- edit names
UPDATE species
SET species = 'mountain whitefish'
WHERE species = 'whitefish';

UPDATE species
SET species = 'Sacramento perch'
WHERE species = 'sacramento perch';

-- delete species
DELETE 
FROM species
WHERE species = 'arctic grayling';

DELETE
FROM species
WHERE species = 'golden trout';

DELETE
FROM species
WHERE species = 'northern pike';

DELETE
FROM species
WHERE species = 'silver salmon';