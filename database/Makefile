DATA = /Users/mitchellgritts/Documents/projects/ndow/trophy-fish/data
URI = trophy_fish
# URI = postgres://gus_su_admin@gus.cotwjstfvxik.us-west-2.rds.amazonaws.com:5432/dev
# URI = postgres://gus_su_admin@gus.cotwjstfvxik.us-west-2.rds.amazonaws.com:5432/gus

build: scripts/build.sql
	@psql $(URI) -a -f $<

extract: build
	psql $(URI) -c "\copy etl.species from '$(DATA)/species-lkp.csv' with csv header"
	psql $(URI) -c "\copy etl.species_water_joiner from '$(DATA)/species-water-joiner.csv' with csv header"
	ogr2ogr -f PostgreSQL "PG:dbname=trophy_fish" -lco SCHEMA=etl $(DATA)/fishable-waters.gpkg

load: scripts/transform-load.sql extract
	@psql $(URI) -a -f $<


clean: scripts/drop.sql
	@psql $(URI) -a -f $<
