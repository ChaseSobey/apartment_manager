# Welcome to apartment manager web app!

This application is an apartment rental tracker that contains a list of apartment buildings
with a list of primary tenants, rents, and apartment size

The schema is One (apartment) : Many (Tenants)

## Application dependency versions

Ruby, PostgreSQL and Gem versions used:

Ruby 2.6.3p62 [x86_64-Linux]
PostgreSQL v13.7
Sinatra v1.4.7

Webrick is the preferred server used during the design of this project

Google Chrome Version 108.0.5359.125 (Official Build) (64-bit) used during production

This program was designed, tested, and run in an AWS Cloud9 environment through a Google Chrome web browser and as such
this is the recommended setup for using this web application

## Application setup

Create a database with the name 'project' and download schema.sql into the database with the following terminal command:

```
psql -d project < schema.sql
```

enter the file path of the program and run 'bundle install' in the terminal to set up all dependencies
run the program with the terminal command "bundle exec ruby apt_manager.rb" and then enjoy!

## Login credentials

the username to log in is: 'grader'

the password to log in is: '100%'

## FAQ's when using

A valid address for a new property must begin with a number

A valid name for a tenant must be a first and last name and be unique

A valid rent must be less than $10000 and input in whole dollars (no cents)

A valid property name must be unique
