---- W E L C O M E   T O   A P A R T M E N T   M A N A G E R   W E B A P P ----

This application is an apartment rental tracker that contains a list of apartment buildings
with a list of primary tenants, rents, and apartment size

The schema is One (apartment) : Many (Tenants)

---- APPLICATION DEPENDENCY VERSIONS ----

Ruby, PostgreSQL and Gem versions used:

Ruby 2.6.3p62 [x86_64-Linux]
PostgreSQL v13.7
Sinatra v1.4.7

Webrick is the preferred server used during the design of this project

This program was designed, tested, and run in an AWS Cloud9 environment through a Google Chrome web browser

---- USING THIS APPLICATION PROPERLY ----

Create a database with the name of your choosing and download schema.sql into the database with the following terminal command:
psql -d chosen_database < schema.sql
