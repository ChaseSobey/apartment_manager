CREATE TABLE apartment_buildings (
id serial PRIMARY KEY,
name text UNIQUE NOT NULL,
total_units INTEGER NOT NULL
address text UNIQUE NOT NULL
);


CREATE TABLE units (
id serial PRIMARY KEY,
building_id integer NOT NULL REFERENCES apartment_buildings.id,
rent NUMERIC(6,2) NOT NULL,
tenant text UNIQUE NOT NULL
);