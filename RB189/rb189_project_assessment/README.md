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

Google Chrome Version 108.0.5359.125 (Official Build) (64-bit) used during production

This program was designed, tested, and run in an AWS Cloud9 environment through a Google Chrome web browser and as such
this is the recommended setup for using this web application

---- USING THIS APPLICATION PROPERLY ----

Create a database with the name 'project' and download schema.sql into the database with the following terminal command:
psql -d project < schema.sql

run the program with the terminal command "bundle exec ruby apt_manager.rb -p $PORT -o $IP" and then enjoy!


---- LOGIN CREDENTIALS ----

the username to log in is: 'grader'
the password to log in is: '100%'


---- FAQ WHEN USING ----

A valid address for a new property must begin with a number
A valid name for a tenant must be a first and last name
A valid rent must be less than $10000 and input in whole dollars (no cents)