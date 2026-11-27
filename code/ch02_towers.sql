-- From Field to Code: Spatial SQL from Scratch
-- Chapter 2. Towers in the database
-- Lesson 2.1. The table of towers: columns, types and the primary key.
-- Lesson 2.2. Load the towers from data/towers.csv and check that none is lost.
--
-- Run from the Terminal, in the folder of the repository:
--   Mac:     psql -d spatial_sql -f code/ch02_towers.sql
--   Windows: psql -U postgres -d spatial_sql -f code/ch02_towers.sql
--   Linux:   sudo -u postgres psql -d spatial_sql -f code/ch02_towers.sql
-- Run it once. A second run stops with: relation "towers" already exists.
-- The file path data/towers.csv is relative to the folder where psql is started.

-- Stop at the first error
\set ON_ERROR_STOP on

-- One row per tower of the 400 kV lines on the Pajares pass.
-- x, y: ETRS89 / UTM zone 30N (EPSG:25830), metres.
CREATE TABLE towers (
    label             text PRIMARY KEY,   -- tower label, e.g. N01; never repeated
    lines             text,               -- line(s) the tower belongs to: N, A, B, C, S
    x                 numeric,            -- easting, m
    y                 numeric,            -- northing, m
    ground_z_m        numeric,            -- ground elevation at the tower base, m
    height_m          numeric,            -- tower height from lidar, m
    slope_deg         numeric,            -- terrain slope at the tower, degrees
    anchor_candidate  boolean             -- may be an anchor (dead-end) tower
);

-- Check the result
\d towers

-- Lesson 2.2: load the towers. HEADER true skips the first row (column names).
\copy towers FROM 'data/towers.csv' WITH (FORMAT csv, HEADER true)

-- Check: the file has 33 towers, so the table must have 33 rows
SELECT count(*) FROM towers;

