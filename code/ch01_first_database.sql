-- From Field to Code: Spatial SQL from Scratch
-- Chapter 1. Where our data will live
-- Lesson 1.3. Our first database: create the database of the book and connect to it.
--
-- Run from the Terminal, in the folder of the repository:
--   Mac:     psql -d postgres -f code/ch01_first_database.sql
--   Windows: psql -U postgres -d postgres -f code/ch01_first_database.sql
--   Linux:   sudo -u postgres psql -d postgres -f code/ch01_first_database.sql
-- Run it once. A second run stops with: database "spatial_sql" already exists.

-- Stop at the first error
\set ON_ERROR_STOP on

-- Databases on the server before we start
\l

-- Create the database of the book
CREATE DATABASE spatial_sql;

-- Connect to the new database and check where we are
\connect spatial_sql
SELECT current_database();
