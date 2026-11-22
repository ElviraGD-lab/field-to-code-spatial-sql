---
title: "How to work with this book"
---

## Who this book is for

It's for engineers and technicians who have worked in the field and want to handle spatial data the way companies do it today. For surveyors, foresters, power engineers and GIS specialists: people who know their own field well but have never worked with a database.

We don't need to know anything beforehand. We start with how PostgreSQL works and how to install it on our own computer. We explain every command in full, and when it comes up again, we explain it again.

## What we learn

The book has four parts. Each part works with its own data, and new data only appears at the start of a new part.

1. **Part I. SQL basics.** Tables of the towers and spans of the 400 kV lines over the Pajares Pass. We install PostgreSQL, create our first database and tables, and load the data. Then we learn to ask questions: selecting rows, counting, grouping, joining tables, and breaking a complicated question down into simple steps.
2. **Part II. PostGIS.** We give the same towers a geometry, and add the forests, terrain, roads, municipalities and wildfires of Asturias. We learn to work with coordinate reference systems, distances, intersections, buffers, rasters and geometry validation. At the end of the part we build a risk table for every span.
3. **Part III. A storm catalogue.** How to set up a database for a real project: loading data through one repeatable pipeline, schemas, user permissions and a backup.
4. **Part IV. The same queries in other tools.** DuckDB, QGIS and Python. This is where we see that SQL, once learned, works everywhere.

After Parts I and II come two **tests** on unfamiliar data: 'Asturias Fire Service' and 'Asturias Wildfires 2012–2025'. In them we solve the problems ourselves, with no hints, on data that never appeared in the lessons.

What the book doesn't cover: routing (pgRouting), topology, publishing maps with GeoServer, and commercial software such as FME. Those are the next step once we have the basics.

## The tools we use

Only the ones people work with today:

- PostgreSQL 18, the database server;
- PostGIS 3.6, the extension for geometry and rasters;
- psql, the text client in the Terminal;
- VS Code, an editor for our query files, with a built-in Terminal;
- QGIS, to see the database tables on a map;
- ogr2ogr from GDAL, to load ready-made layers;
- later on, DuckDB and Python.

They're all free and run on Mac, Windows and Linux. The data is open.

## How a lesson works

Each lesson answers one engineer's question and introduces one or two new things. If there's more than that, the lesson is split in two. Every lesson has the same structure, so after a few lessons we already know where to find everything:

1. **Where we left off** – what we can already do and what data we have.
2. **What we want to know** – the question of the lesson. This is where we write down our guess, before we've worked anything out.
3. **Steps.** Each step follows the same pattern: what we're doing → the code → what the server replied → the code explained line by line.
4. **What we found** – the answer to the lesson's question, compared with our guess.
5. **If something goes wrong** – common errors and what to do about them.
6. **Your data** – what to change to do the same thing with our own data. **Your computer** – where things are done differently on Mac, Windows and Linux.
7. **Summary** – new terms, new code and the key idea of the lesson.
8. **Questions for an engineer** – two or three questions, each with its answer straight underneath.
9. **Exercises** – exactly three.
10. **The open question** – one worth thinking about, although it has no right answer.
11. **Sources.**

## How we work through a lesson

- **One lesson at a time.** A lesson takes about an hour. One lesson a day is better than five at the weekend.
- **We type the code ourselves.** Copying is fine, but code typed by hand sticks far better. We run each command as soon as we reach it and compare the server's reply with the one in the book.
- **Errors are normal.** The server nearly always tells us what it didn't like. We read the message calmly, look at 'If something goes wrong' and try again. Every error like this teaches us more than a command that works first time.
- **We don't memorise names.** What matters is understanding what a command does. The name will come back by itself once we've typed it ten times.

## Exercises

Every lesson ends with three short exercises, always in the same order:

1. **Recall** – the main point of this lesson.
2. **Complete or fix** – a short piece of code or a sentence.
3. **Look back** – a question on the lesson one, three or seven lessons earlier. That way nothing we've learned gets lost.

We solve them ourselves first and only then check the answers. The answers are collected on a separate page.

## Code and data

The code for each chapter is in the `code` folder of the repository, one file per chapter. The data, with a description of where it comes from, is in the `data` folder. The text of the book is licensed under CC BY 4.0 and the code under Apache 2.0.

This is the fourth book in the From Field to Code series. It can be read on its own: everything we need for SQL is explained here. Python only appears in Part IV, and it's explained from scratch in the first book of the series, *PyQGIS from Scratch*.
