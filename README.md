# From Field to Code: Spatial SQL from Scratch

**Del campo al código: SQL espacial desde cero**

An open book on **PostgreSQL and PostGIS**, written for engineers and field specialists who have never worked with a database. It starts with what a database is and how to install one, moves through the SQL that is used every day in companies, and then into spatial SQL with PostGIS: points, lines and polygons, distances, buffers, spatial joins and indexes.

Book 4 of the *From Field to Code* series. Written in Spanish and English.

**Read the book:** https://elviragd-lab.github.io/field-to-code-spatial-sql/ · [Español](https://elviragd-lab.github.io/field-to-code-spatial-sql/es/) · [English](https://elviragd-lab.github.io/field-to-code-spatial-sql/en/)

> Status: work in progress (started November 2026). Published so far: how to work with the book, the prologue and chapter 1 (lessons 1.1–1.3) and lesson 2.1.

## The data

Every chapter works on real open data from Asturias (Spain), most of it from the Pajares project on forests, storms and power lines: power line towers and spans, wildfire detections, land use, elevation models and municipal boundaries. Sources and licences are listed in [`data/README.md`](data/README.md).

## Run the code

Every SQL block in the book is also in a script in [`code/`](code/), one per chapter. Each script is run top to bottom on PostgreSQL 18 with PostGIS 3.6 before it is published. The first script, [`code/ch01_first_database.sql`](code/ch01_first_database.sql), goes with lesson 1.3.

## The series

*From Field to Code* is a series of open books for engineers and field specialists who want to work with spatial data the way the industry does today. All books: https://elviragd-lab.github.io

## Read and build

The book is written in [MyST Markdown](https://mystmd.org). To build it locally:

```bash
npm install -g mystmd@1.12.0
cd book
myst start
```

## Found a mistake?

Please tell us through an issue. How to do it: [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Licence

- Code: Apache License 2.0 (`LICENSE`)
- Text and figures: CC BY 4.0 (`LICENSE-docs`)
- Data attributions: see `data/README.md`

© 2026 Elvira Gayanova
