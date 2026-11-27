---
title: "Lesson 2.1. Describing a tower: our first table"
---

(en-ch02-l01-lesson)=
## Where we left off

In Chapter 1 we installed PostgreSQL and created our own database, `spatial_sql`. The database is there, but it's empty: it has no tables. And the towers of the Pajares lines are still sitting in a CSV file.

## What we want to know

How to describe a tower to the server: which columns it has and what type each one is. And how to make sure the table never ends up with two towers carrying the same label.

Let's think before we start. In the CSV file, every tower has a label, a line, coordinates and a height. Which of these values are numbers, and which are text? And is there a value that's different for every tower and never repeats? We write down our guess.

## Step 1. Looking at what we know about a tower

The project's source file has 28 columns. For the book we take eight, the ones we'll need in the next few chapters. Here are the first three towers:

| label | lines | x | y | ground_z_m | height_m | slope_deg | anchor_candidate |
|---|---|---|---|---|---|---|---|
| N01 | N | 274101.61 | 4766898.64 | 1124.15 | 28.6 | 7.5 | False |
| N02 | N | 274178.44 | 4766662.48 | 1060.78 | 36.1 | 18.0 | False |
| N03 | N | 274313.17 | 4766250.94 | 1067.22 | 29.3 | 25.2 | True |

What's in the columns:

- `label` is the tower's label: the letter of the line and a number;
- `lines` is the line the tower stands on. There are five lines: N, A, B, C, S;
- `x`, `y` are the coordinates in metres, in ETRS89 / UTM zone 30N (code EPSG:25830). It's the same system Spain's maps use;
- `ground_z_m` is the ground elevation at the foot of the tower, in metres above sea level;
- `height_m` is the height of the tower itself in metres, measured from lidar;
- `slope_deg` is the slope of the ground at the tower, in degrees;
- `anchor_candidate` tells us whether this tower could be an anchor tower, that is, one that holds the conductors fixed. Towers like this usually stand where the line changes direction.

The column names are in English, in lower case, with `_` between the words. It's the same rule as for the database name (Lesson 1.3).

## Step 2. Choosing a type for each column

In Lesson 1.1 we saw that every column has a type, and the server won't let a value of the wrong type into a column. Three types are enough for our towers:

| Type | What it stores | Our columns |
|---|---|---|
| `text` | any text of any length | `label`, `lines` |
| `numeric` | a number, including decimals, with no loss of precision | `x`, `y`, `ground_z_m`, `height_m`, `slope_deg` |
| `boolean` | 'yes' or 'no': `true` / `false` | `anchor_candidate` |

Why are the coordinates `numeric` and not `text`? Because we'll be doing sums with them: comparing them, subtracting them, working out distances. The server won't do arithmetic with the text `'274101.61'`. And `numeric` stores a number exactly as we wrote it: 274101.61 stays 274101.61, down to the last digit.

## Step 3. Choosing what tells one tower from another

Each tower has its own label: N01, N02… Our file has 33 towers and 33 different labels. If a second N01 slipped into the table by mistake, we'd have no way of telling later which one was the real one.

So we make `label` the **primary key**. A primary key is a column whose value:

- is different in every row, with no repeats;
- is always there, and is never empty.

The server enforces both rules by itself. A table can only have one primary key.

## Step 4. Creating the table

We connect to our database:

```bash
psql -d spatial_sql
```

And create the table:

```sql
CREATE TABLE towers (
    label             text PRIMARY KEY,
    lines             text,
    x                 numeric,
    y                 numeric,
    ground_z_m        numeric,
    height_m          numeric,
    slope_deg         numeric,
    anchor_candidate  boolean
);
```

Let's read it line by line:

- `CREATE TABLE towers (` means 'create a table called `towers`'. The list of columns follows in brackets;
- each line inside is one column: first the name, then the type. The columns are separated by commas;
- `label text PRIMARY KEY` is the column `label`, of type `text`, and it's the primary key;
- the last column has no comma, because the list ends after it;
- `);` closes the bracket and ends the command.

While we're typing the lines inside the brackets, the psql prompt looks like this: `spatial_sql(#`. The bracket in place of the `=` sign means psql has seen an open bracket and is waiting for us to close it. That's normal.

The spaces that line the types up in a column aren't for the server. They're for us: they make the table easier to read. We could type the same command on a single line, and the server would understand it just the same:

```sql
CREATE TABLE towers (label text PRIMARY KEY, lines text, x numeric, y numeric, ground_z_m numeric, height_m numeric, slope_deg numeric, anchor_candidate boolean);
```

The server's reply:

```
CREATE TABLE
```

As in Lesson 1.3, the server repeats the name of the command: 'done'.

## Step 5. Checking the result

Let's ask psql to describe our table:

```
\d towers
```

`\d` (describe) is a command for the client. The reply:

```
                    Table "public.towers"
      Column      |  Type   | Collation | Nullable | Default
------------------+---------+-----------+----------+---------
 label            | text    |           | not null |
 lines            | text    |           |          |
 x                | numeric |           |          |
 y                | numeric |           |          |
 ground_z_m       | numeric |           |          |
 height_m         | numeric |           |          |
 slope_deg        | numeric |           |          |
 anchor_candidate | boolean |           |          |
Indexes:
    "towers_pkey" PRIMARY KEY, btree (label)
```

What matters here:

- `Table "public.towers"` is the full address of the table: the `public` schema, the `towers` table. That's how we wrote it in Lesson 1.1;
- `Column` and `Type` show the eight columns with the types we chose;
- `Nullable` tells us whether a column can be empty. For `label` it says `not null`: a primary key can't be empty, and the server added this rule by itself;
- `Indexes`: at the bottom, the server tells us the table has a primary key, `towers_pkey`, on the `label` column. The server made up the name itself: the table name plus `_pkey` (primary key). The word `btree` describes how the server looks up key values quickly; there's more on that in the chapter on indexes.

## What we found

Let's compare with our guess. The label and the line are text; the coordinates, heights and slope are numbers; the anchor tower flag is a 'yes or no'. Every tower has its own label, so the label became the primary key. The `spatial_sql` database now has a `towers` table with eight columns. It has no rows yet.

## If something goes wrong

- **The prompt has changed to `spatial_sql(#`, and we haven't finished yet or we've made a mistake.** psql is waiting for the closing bracket. If there's a mistake in the command we've started (say we typed `CREATE TABLE (` and forgot the table name), there's no point finishing it: we cancel everything we've typed with `\r` (reset) or Ctrl+C. psql replies `Query buffer reset (cleared).`, and the prompt goes back to `spatial_sql=#`.
- **`ERROR: relation "towers" already exists`.** The table is already there: we created it earlier. `relation` is the server's word for a table. We look at it with `\d towers`.
- **`ERROR: type "numbr" does not exist`.** A typo in the type. The server only knows the real type names: `numeric`, `text`, `boolean`.
- **`ERROR: multiple primary keys for table "towers" are not allowed`.** We wrote `PRIMARY KEY` on two columns. A table has only one primary key.
- **`ERROR: syntax error at or near ")"`.** Most often this is a stray comma after the last column. We remove it.
- **The table was created in the `admin` database.** We forgot to connect to `spatial_sql`. We check the prompt: it should be `spatial_sql=#`.

## Your data

For our own data we do the same thing: we open our CSV file, list the columns we need, choose a type for each one and look for a column whose value never repeats. That column will be the primary key.

## Your computer

On Windows we connect like this: `psql -U postgres -d spatial_sql`. On Linux, like this: `sudo -u postgres psql -d spatial_sql`.

## Summary

**Terms:** table, column, type (`text`, `numeric`, `boolean`), primary key.
**Code:** `CREATE TABLE towers (...)`, `PRIMARY KEY`, `\d towers`, `\r`.
**Key point:** we describe a table once: its name, columns, types and key. From then on, the server makes sure the data matches that description.

## Questions for an engineer

1. *Why did we make the label the primary key, and not the tower's height?*

   :::{dropdown} Answer

   Heights can repeat: in our data, several towers are 36.1 m tall. But every tower has its own label, and it never repeats.
   :::

2. *A colleague suggests storing the coordinates as `text`: 'it's simpler, they're just the figures from the file.' What would we lose?*

   :::{dropdown} Answer

   The server won't do arithmetic with text: it won't compare, subtract or work out a distance. On top of that, anything at all could end up in the column, even 'no data'. The `numeric` type only lets a number in.
   :::

## Exercises

1. **Recall.** Which type did we choose for the column that stores a 'yes or no' answer?

2. **Fix.** A colleague described the spans table like this: `CREATE TABLE spans (span_label text PRIMARY KEY, length_m text);`. We're going to add up and compare span lengths. What needs fixing?

3. **Look back (Lesson 1.1).** How do we write the full address of our towers table, the one `\d` showed us?

[Answers](#en-ch02-l01)

## The open question

The table is ready, but there isn't a single tower in it. How do we load the 33 towers from the CSV file and make sure none of them goes missing?

## Sources

- PostgreSQL 18 Documentation, CREATE TABLE – https://www.postgresql.org/docs/18/sql-createtable.html (checked 27 November 2026)
- PostgreSQL 18 Documentation, Data Types – https://www.postgresql.org/docs/18/datatype.html (checked 27 November 2026)
- PostgreSQL 18 Documentation, Constraints – https://www.postgresql.org/docs/18/ddl-constraints.html (checked 27 November 2026)
- Data: towers of the Pajares 400 kV lines, Pajares project (derived data; © OpenStreetMap contributors, ODbL; lidar PNOA cedido por © IGN).
