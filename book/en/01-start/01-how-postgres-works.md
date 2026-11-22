---
title: "Lesson 1.1. How PostgreSQL works"
---

(en-ch01-l01-lesson)=
## Where we left off

This is the first lesson, so we're starting from zero. We have the Pajares project, and in it a table of the towers of the 400 kV line: 33 rows. Each tower has a label (N01, N02…), a line (N, A, B, C) and a height from the nDSM. Right now the table sits in a CSV file. We want to learn how to keep data like this in a database and ask it questions.

## What we want to know

What PostgreSQL is made of, and where inside it our towers table will live.

Before reading on, let's think for a minute: how is a 'database' different from a folder of CSV files? We write down one sentence, and we'll compare at the end of the lesson.

## Step 1. The server: a program that runs all the time

A CSV file sits on the disk and does nothing by itself. A program (Excel, QGIS) opens it, reads the whole thing and closes it.

PostgreSQL works differently. It's a **server** program: it starts once and then keeps running in the background. It's the server that stores the data, looks after it and answers questions. We never touch its files directly.

The server listens at a numbered 'door'. That door is called a **port**, and for PostgreSQL it's usually **5432**. Anyone who wants to ask something knocks on that door.

## Step 2. The client: the one who asks the questions

A program that knocks on the server's door is called a **client**. We'll use several in this book:

- **psql**, the text client in the Terminal. This is the one we'll use most;
- **QGIS**, which shows the database tables on a map;
- **Python**, later on, in Part IV.

All clients talk to the server in the same language: **SQL**.

Let's look at how the conversation goes. It's always the same:

```
client (psql)  ──  question in SQL  ──►  PostgreSQL server (port 5432)
client (psql)  ◄──  answer: a table  ──  PostgreSQL server
```

This diagram gives us the key idea of the lesson: we don't open a data file, we **ask** the server. That's why QGIS, psql and a script can all look at the same towers at the same time, and they all see exactly the same thing.

## Step 3. Five levels: from the server down to a cell

Inside the server, everything fits inside everything else, like Russian dolls. Let's lay out our towers level by level:

```
PostgreSQL server           (one program on the computer)
└── database spatial_sql    (one database per book or project)
    └── schema public       (a folder inside the database)
        └── table towers    (the towers)
            ├── row: N01 | N | 28.6
            ├── row: N02 | N | 36.1
            └── ... 33 rows in all
```

Let's go through the levels from the top down:

1. **Server.** One program. A single server can hold many databases.
2. **Database.** A world of its own: the tables in one database can't see the tables in another. For this book we'll create a database called `spatial_sql`.
3. **Schema.** A folder inside the database. Every new database already has a schema called `public`, and for now that's the only one we work in. In Part III we'll create our own schemas, for example a separate one for storms.
4. **Table.** A set of rows of the same kind: towers in one table, spans in another.
5. **Row and column.** A row is one tower. A column is one attribute of all the towers, such as height. Every column has a **type**, and the server won't let us put the word 'tall' into the height column. That's our first difference from CSV, where we can write anything we like.

The full address of a table is written with a dot: `public.towers`. It's like a file path: first the folder, then the name.

## Step 4. What a question and an answer look like

We'll install the software in Lesson 1.2. For now, let's just see what a conversation in psql will look like. There's no need to memorise anything: we'll write this many more times.

```sql
SELECT label, height_ndsm_m
FROM towers
WHERE height_ndsm_m > 35;
```

Let's read it line by line:

- `SELECT label, height_ndsm_m` means 'show the label and height columns';
- `FROM towers` means 'from the towers table';
- `WHERE height_ndsm_m > 35;` means 'only the rows where the height is more than 35 metres'. The semicolon means 'the question ends here'.

The server's answer will look something like this (the numbers are real, from our data):

```
 label | height_ndsm_m
-------+---------------
 N02   |          36.1
 N06   |          78.9
 A02   |          36.1
 ...
(10 rows)
```

The server returned a table of 10 rows, and nobody opened a file.

## Step 5. What a command does to the data

It's handy to group SQL commands by what they do. These groups have names made of letters, and we'll come across them in the documentation. We don't need to learn the letters by heart. What matters is the idea: does a command only ask, or does it change something?

| What the command does | Example | Group name | Where in the book |
|---|---|---|---|
| builds and changes the structure: databases, tables, columns | `CREATE TABLE` | DDL (Data Definition Language) | Chapter 2 |
| adds, changes and deletes rows | `INSERT`, `UPDATE`, `DELETE` | DML (Data Manipulation Language) | Chapters 2–5 |
| asks questions without changing anything | `SELECT` | DQL (Data Query Language) | Chapters 3–7 and beyond |
| decides who is allowed to do what | `GRANT` | DCL (Data Control Language) | Chapter 21 |

Let's get into a habit: before running a command, we ask ourselves whether it changes anything. `SELECT` is safe, because it only looks. `DELETE` changes the data, so we'll be more careful with it.

## Step 6. Where PostGIS fits in

PostGIS is an **extension**: an add-on that teaches the server to understand geometry. Without it, a column holds numbers and text. With it, a column can also hold the point of a tower or the line of a span. Then we can ask in SQL, for example, 'which spans are within 50 m of forest?'

PostGIS isn't a separate program or a separate server. We'll switch it on inside our database with a single command (`CREATE EXTENSION postgis`) in Part II.

## What we found

Let's pull together what we've learned:

- the data lives inside the **server**, and we ask our questions through a **client**;
- the nesting goes: server → database → schema → table → row and column;
- our future table is `public.towers` in the `spatial_sql` database.

Now let's compare this with our guess from the start. The main difference from a folder of CSV files: a database is a running program that stores the data itself, checks the types and answers many clients at once.

## If something isn't clear

- *'Is the server a separate computer?'* No, it's a program. It can run on our own computer, and that's how we'll do it in this book. In a company the server usually sits on a separate machine, but it works the same way.
- *'Are a schema and a database the same thing?'* No. A schema is a folder *inside* a database. From one database we can read tables in different schemas, but we can't read the tables of another database like that.

## Your computer

There's nothing to install yet. In Lesson 1.2 we'll install PostgreSQL together with PostGIS on our computer (Mac, Windows or Linux) and connect to it with psql.

## Summary

**Terms:** server, client, port 5432, database, the `public` schema, table, row, column, column type, the PostGIS extension; commands that ask and commands that change.
**Code:** so far, just the example `SELECT … FROM … WHERE …;`.
**Key point:** we don't open the data, we ask the server.

## Questions for an engineer

1. *A colleague has opened the towers table in QGIS, and at the same moment we're looking at it in psql. Are we seeing different copies?*

   :::{dropdown} Answer

   No. Both clients are asking the same server, so they see the same rows.
   :::

2. *Why won't the server let us write 'tall' into the height column?*

   :::{dropdown} Answer

   The column has a type (a number), and the server checks every value. That protects the data from mistakes that slip through unnoticed in a CSV file.
   :::

## Exercises

1. **Recall.** Let's put the five levels in order, from largest to smallest: table, server, row, database, schema.

2. **Complete.** For each command, we write down whether it only asks or changes something. If it changes something, what does it change: the structure, the rows or the permissions? `CREATE TABLE`, `SELECT`, `DELETE`, `GRANT`.

3. **Link to the project.** This is the first lesson, so there are no earlier lessons to look back on yet, and the question is about Pajares instead. We'll put the spans of the line into the database too. What will the full address of the future spans table, `spans`, be if it sits in the same schema as the towers?

[Answers](#en-ch01-l01)

## The open question

If we were running the Pajares project together with a colleague from a power utility, what would we keep in one database, and what would we split into separate schemas?

## Sources

- PostgreSQL 18 Documentation, Chapter 1 'Getting Started', 1.2 'Architectural Fundamentals' – https://www.postgresql.org/docs/18/tutorial-arch.html
- PostGIS 3.6 Manual – https://postgis.net/docs/
