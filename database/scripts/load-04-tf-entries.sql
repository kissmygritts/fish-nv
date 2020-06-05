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
