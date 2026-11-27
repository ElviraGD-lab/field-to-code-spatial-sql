-- From Field to Code: Spatial SQL from Scratch
-- Chapter 3. Asking the table
-- Lesson 3.1. Which towers are taller than 35 metres: SELECT, WHERE, comparisons, AND, OR.
--
-- Needs the table towers loaded in chapter 2 (code/ch02_towers.sql).
-- Run from the Terminal, in the folder of the repository:
--   Mac:     psql -d spatial_sql -f code/ch03_queries.sql
--   Windows: psql -U postgres -d spatial_sql -f code/ch03_queries.sql
--   Linux:   sudo -u postgres psql -d spatial_sql -f code/ch03_queries.sql
-- The queries only read the table; the script can be run any number of times.

-- Stop at the first error; print whole results without paging
\set ON_ERROR_STOP on
\pset pager off

-- All columns of all towers
SELECT * FROM towers;

-- Only three columns
SELECT label, lines, height_m FROM towers;

-- Towers taller than 35 m (expected: 10 rows)
SELECT label, height_m FROM towers WHERE height_m > 35;

-- Tall AND on a steep slope (expected: 0 rows)
SELECT label, height_m, slope_deg FROM towers WHERE height_m > 35 AND slope_deg > 20;

-- Tall OR on a steep slope (expected: 13 rows)
SELECT label, height_m, slope_deg FROM towers WHERE height_m > 35 OR slope_deg > 20;

-- Towers whose lines value is exactly 'S' (expected: 5 rows; S01 is 'S,A,B,C')
SELECT label, lines FROM towers WHERE lines = 'S';
