CREATE TABLE apartment_buildings (
id serial PRIMARY KEY,
name text UNIQUE NOT NULL,
address text UNIQUE NOT NULL
);


CREATE TABLE units (
id serial PRIMARY KEY,
building_id integer NOT NULL REFERENCES apartment_buildings (id),
rent NUMERIC(6,2) NOT NULL,
tenant text UNIQUE NOT NULL
);

INSERT INTO apartment_buildings (name, address) VALUES
('Fillmore Center', '1420 Turk St'),
('Vintage Pads', '14 E Border Place'),
('Baker Street apts', '12 Baker St');

INSERT INTO units (building_id, rent, tenant) VALUES
(1, 2650, 'Stephanie Smith'), (1, 2650, 'James Earl'), (1, 1700, 'Tiffany Mueller'), (1, 3600, 'Zach Brown'),
(2, 950, 'Bowen Young'), (2, 650, 'Callie Norton'), (2, 800, 'Marissa Kumani'),
(3, 1200, 'Marianna Lopez'), (3, 1200, 'Neda Heydari'), (3, 1200, 'Alexa Flint'), (3, 900, 'Martin Jones');