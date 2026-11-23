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

