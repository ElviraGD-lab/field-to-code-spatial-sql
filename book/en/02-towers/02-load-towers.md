---
title: "Lesson 2.2. Loading the towers and counting them"
---

(en-ch02-l02-lesson)=
## Where we left off

In Lesson 2.1 we described a tower to the server: we created the `towers` table with eight columns and the primary key `label`. The table is there, but it's empty. The towers are sitting in the file `towers.csv`.

## What we want to know

How to move the 33 towers from the file into the table, and how to make sure none of them goes missing and none gets in twice.

Let's think before we start. What should we end up with if everything goes well? And what will the server do if we load the file a second time by mistake? Remember that the primary key doesn't let repeats in. We write down our guess.

## Step 1. Looking at the file

The file `towers.csv` is in the `data` folder of the book's repository. If we don't have the repository on our computer yet, we download the whole thing: on the repository's GitHub page we click **Code → Download ZIP** and unzip the archive.

The first lines of the file:

```
label,lines,x,y,ground_z_m,height_m,slope_deg,anchor_candidate
N01,N,274101.61,4766898.64,1124.15,28.6,7.5,false
N02,N,274178.44,4766662.48,1060.78,36.1,18.0,false
N03,N,274313.17,4766250.94,1067.22,29.3,25.2,true
```

What we see:

- CSV (comma-separated values) is an ordinary text file. One line is one tower, and the values are separated by commas;
- the first line isn't a tower: it's the column names. They match the columns of our table and come in the same order;
- the file has 34 lines: the line of names and 33 towers.

There's one more line worth looking at:

```
N10,"N,A,B,C",275096.13,4764068.65,1401.22,30.4,10.2,true
```

Tower N10 stands on four lines at once, and the `lines` column says `N,A,B,C`. That value has commas inside it too, so it's wrapped in quotation marks: that's how the file tells us it's one value, not four. We'll deal with towers like this in Chapter 5.

## Step 2. Opening psql in the book's folder

`\copy` will look for the file relative to the folder we started psql from. So first we go to the repository folder, and then we connect:

```bash
cd ~/projects/field-to-code-spatial-sql
psql -d spatial_sql
```

- `cd` (change directory) takes us to the book's folder. Everyone may keep it somewhere different, so we put in our own path;
- `psql -d spatial_sql` connects us to our database (Lesson 1.3).

## Step 3. Checking that the table is empty

Before we load anything, let's ask the server how many rows the table has right now:

```sql
SELECT count(*) FROM towers;
```

- `SELECT` means 'show';
- `count(*)` is a server function that means 'count the rows'. The asterisk means 'every row there is';
- `FROM towers` means 'in the towers table'.

The reply:

```
 count
-------
     0
(1 row)
```

Zero rows: the table is empty, just as we expected.

## Step 4. Loading the towers

```
\copy towers FROM 'data/towers.csv' WITH (FORMAT csv, HEADER true)
```

Let's read it piece by piece:

- `\copy` is a command for the psql client: 'copy rows from a file into a table'. It starts with `\`, so it doesn't need a semicolon;
- `towers` is the table to copy into;
- `FROM 'data/towers.csv'` is the file to copy from. The path is in single quotes and is relative to the folder where we started psql;
- `WITH (...)` gives the settings for reading the file:
  - `FORMAT csv` means the file is in CSV format: values separated by commas, and values with a comma inside them in quotation marks;
  - `HEADER true` means 'the first line is a header, skip it'.

The reply:

```
COPY 33
```

The server tells us it copied 33 rows. That's exactly as many towers as there are in the file.

Why `\copy` and not just `COPY`? The server has a `COPY` command of its own, but it reads files from the computer the server runs on. `\copy` is a psql command: psql reads the file on our computer itself and passes the rows to the server. When the server is on another machine, as it usually is in a company, only `\copy` works.

## Step 5. Counting again

```sql
SELECT count(*) FROM towers;
```

The reply:

```
 count
-------
    33
(1 row)
```

33 towers in the file, 33 rows in the table. None of them went missing.

## Step 6. What happens if we load the file a second time

This mistake happens a lot in real work: someone runs a script twice. Let's check what the server does. We repeat the same command:

```
\copy towers FROM 'data/towers.csv' WITH (FORMAT csv, HEADER true)
```

The reply:

```
ERROR:  duplicate key value violates unique constraint "towers_pkey"
DETAIL:  Key (label)=(N01) already exists.
CONTEXT:  COPY towers, line 2
```

Let's take the message apart:

- `ERROR: duplicate key value violates unique constraint "towers_pkey"`: a repeated key value breaks the uniqueness rule `towers_pkey`. That's our primary key from Lesson 2.1;
- `DETAIL: Key (label)=(N01) already exists.`: tower N01 is already there;
- `CONTEXT: COPY towers, line 2`: it tripped up on line 2 of the file, which is the first tower.

Let's count again:

```sql
SELECT count(*) FROM towers;
```

```
 count
-------
    33
(1 row)
```

Still 33. The server didn't add a single extra row, not even the ones after N01. The `\copy` command works on an 'all or nothing' basis: if even one row doesn't fit, none of them get loaded. That's how the primary key protected us from duplicate towers.

## What we found

Let's compare with our guess. The `towers` table has 33 towers, the same number as the file. Loading it a second time didn't spoil the data: the server refused to do it. Here are the two checks we'll make after every load:

- count the rows in the file and in the table: the numbers must match;
- make sure the primary key kept out any repeats.

## If something goes wrong

- **`data/towers.csv: No such file or directory`.** psql couldn't find the file. Most likely we didn't start psql from the book's folder. We quit (`\q`), go to the book's folder with `cd` and connect again. Or we can stay where we are and give the full path to the file: `'/Users/.../field-to-code-spatial-sql/data/towers.csv'`.
- **`ERROR: invalid input syntax for type numeric: "x"`** with `CONTEXT: COPY towers, line 1, column x: "x"`. We forgot `HEADER true`, and the server tried to load the header line as a tower: the word 'x' ended up in the numeric column `x`. We add `HEADER true`. Not a single row was loaded: 'all or nothing'.
- **`ERROR: duplicate key value violates unique constraint "towers_pkey"`.** The towers are already loaded. We count the rows: if there are 33, everything's fine.
- **`ERROR: relation "towers" does not exist`.** There's no table: we're in a different database, or we skipped Lesson 2.1. We check the prompt (`spatial_sql=#`) and run `\d towers`.

## Your data

We load our own CSV file in the same way. We need:

- the columns in the file to come in the same order as in the table;
- numbers written with a decimal point (274101.61), not a comma;
- 'yes/no' written as `true`/`false`.

If the file has a header line, we add `HEADER true`. After loading, we compare the number of rows in the file and in the table.

## Your computer

On Windows the folder usually looks like this: `cd C:\Users\<username>\Downloads\field-to-code-spatial-sql-main`, and we connect with `psql -U postgres -d spatial_sql`. On Linux: `sudo -u postgres psql -d spatial_sql`. But then psql runs as the `postgres` user, and it may not be able to see files in our home folder. The simplest fix is to give the full path to the file in `\copy`.

## Summary

**Terms:** CSV file, header line, 'all or nothing' loading, checking the row count.
**Code:** `\copy towers FROM 'data/towers.csv' WITH (FORMAT csv, HEADER true)`, `SELECT count(*) FROM towers;`.
**Key point:** after every load, we count the rows. The primary key doesn't let repeats in, and if there's an error, `\copy` loads nothing at all.

The commands from Lessons 2.1 and 2.2 are in the file `code/ch02_towers.sql`. We can run it in one go from the book's folder: `psql -d spatial_sql -f code/ch02_towers.sql`. This works in an empty database, where there's no `towers` table yet.

## Questions for an engineer

1. *A colleague loaded the file, and the server replied `COPY 33`. Why count the rows with `count(*)` as well?*

   :::{dropdown} Answer

   `COPY 33` tells us how many rows were added just now. `count(*)` tells us how many there are in the table altogether. If the table already had something in it, the numbers won't match, and we'll notice.
   :::

2. *Why didn't a single extra tower appear in the table after the failed second load, even though the error was only on N01?*

   :::{dropdown} Answer

   `\copy` works on an 'all or nothing' basis. At the very first error, the server cancels the whole load, and the table stays as it was.
   :::

## Exercises

1. **Recall.** Which setting in `\copy` tells the server that the first line of the file is a header?

2. **Fix.** A colleague wants to count the towers and writes `SELECT count FROM towers;`. What's missing?

3. **Look back (Lesson 1.3).** How do we connect to the `spatial_sql` database straight from the Terminal, without switching with `\c`?

[Answers](#en-ch02-l02)

## The open question

There are 33 towers in the database. Now we can start asking them questions. Which towers are taller than 35 metres, and how do we ask the server to show us only those?

## Sources

- PostgreSQL 18 Documentation, COPY – https://www.postgresql.org/docs/18/sql-copy.html
- PostgreSQL 18 Documentation, psql – https://www.postgresql.org/docs/18/app-psql.html
- PostgreSQL 18 Documentation, Aggregate Functions – https://www.postgresql.org/docs/18/functions-aggregate.html
- Data: `data/towers.csv`, Pajares project; © OpenStreetMap contributors, ODbL 1.0; 'PNOA cedido por © IGN'.
