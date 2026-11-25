---
title: "Answers to the exercises"
---

(en-ch01-l01)=
## Lesson 1.1. How PostgreSQL works

1. **Recall.** Let's put the five levels in order, from largest to smallest: table, server, row, database, schema.

   **Answer:** server → database → schema → table → row.

2. **Complete.** For each command, we write down whether it only asks or changes something. If it changes something, what does it change: the structure, the rows or the permissions? `CREATE TABLE`, `SELECT`, `DELETE`, `GRANT`.

   **Answer:** `CREATE TABLE` changes the structure (it creates a table); `SELECT` only asks; `DELETE` changes the rows (it deletes them); `GRANT` changes the permissions.

3. **Link to the project.** This is the first lesson, so there are no earlier lessons to look back on yet, and the question is about Pajares instead. We'll put the spans of the line into the database too. What will the full address of the future spans table, `spans`, be if it sits in the same schema as the towers?

   **Answer:** `public.spans` in the `spatial_sql` database.

[Back to the lesson](#en-ch01-l01-lesson)

(en-ch01-l02)=
## Lesson 1.2. Installing PostgreSQL on our computer

1. **Recall.** Which psql command shows which database we're connected to, as which user and through which port?

   **Answer:** `\conninfo`.

2. **Fix.** We typed `SELECT version()` and pressed Enter. The server says nothing, and the prompt has changed to `admin-#`. What do we need to type?

   **Answer:** `;` and Enter: a question in SQL ends with a semicolon.

3. **Look back (Lesson 1.1).** What's the number of the 'door' that clients knock on to reach the PostgreSQL server, and what is that door called?

   **Answer:** port 5432.

[Back to the lesson](#en-ch01-l02-lesson)

(en-ch01-l03)=
## Lesson 1.3. Our first database

1. **Recall.** Which psql command shows the list of all the databases on the server?

   **Answer:** `\l`.

2. **Fix.** A colleague typed `CREATE DATABASE Pajares Risk;` and got an error. How should the command be written, following our rule for names?

   **Answer:** `CREATE DATABASE pajares_risk;`: in lower case, with an underscore instead of a space.

3. **Look back (Lesson 1.2).** Which psql command shows which database we're connected to, as which user and through which port?

   **Answer:** `\conninfo`.

[Back to the lesson](#en-ch01-l03-lesson)

(en-ch02-l01)=
## Lesson 2.1. Describing a tower: our first table

1. **Recall.** Which type did we choose for the column that stores a 'yes or no' answer?

   **Answer:** `boolean`.

2. **Fix.** A colleague described the spans table like this: `CREATE TABLE spans (span_label text PRIMARY KEY, length_m text);`. We're going to add up and compare span lengths. What needs fixing?

   **Answer:** the type of the length: `length_m numeric`.

3. **Look back (Lesson 1.1).** How do we write the full address of our towers table, the one `\d` showed us?

   **Answer:** `public.towers`.

[Back to the lesson](#en-ch02-l01-lesson)

