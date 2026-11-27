---
title: "Lesson 3.1. Which towers are taller than 35 metres"
---

(en-ch03-l01-lesson)=
## Where we left off

In Chapter 2 we created the `towers` table and loaded 33 towers into it. The server confirmed it: 33 rows, no repeats. So far, all we've done is count rows. Now we start asking the table real questions.

## What we want to know

Which towers are taller than 35 metres? And are any of them on a steep slope, steeper than 20 degrees? A tall tower on a steep slope is the first candidate for an inspection before winter.

Let's think before we start. A typical 400 kV tower here is about 30 metres tall. How many towers are taller than 35? Probably not many: a handful. And ones that are tall and on a steep slope as well? Maybe one or two. We write down our guess.

## Step 1. Looking at the whole table

We connect to the database from the book's folder, as in Lesson 2.2:

```bash
cd ~/projects/field-to-code-spatial-sql
psql -d spatial_sql
```

We ask to see everything:

```sql
SELECT * FROM towers;
```

- `SELECT` means 'show';
- `*` means 'all the columns';
- `FROM towers` means 'from the towers table'.

The reply (the first rows are shown):

```
 label |  lines  |     x     |     y      | ground_z_m | height_m | slope_deg | anchor_candidate
-------+---------+-----------+------------+------------+----------+-----------+------------------
 N01   | N       | 274101.61 | 4766898.64 |    1124.15 |     28.6 |       7.5 | f
 N02   | N       | 274178.44 | 4766662.48 |    1060.78 |     36.1 |      18.0 | f
 N03   | N       | 274313.17 | 4766250.94 |    1067.22 |     29.3 |      25.2 | t
 ...
(33 rows)
```

All 33 towers, all the columns. psql shows 'yes/no' values in short form: `t` (true) and `f` (false).

If the table doesn't fit on the screen, psql shows it page by page and puts a colon `:` at the bottom. The space bar moves on to the next page, and the `q` key takes us back to the prompt.

## Step 2. Choosing only the columns we need

Reading everything at once is awkward. Let's ask for just the label, the line and the height:

```sql
SELECT label, lines, height_m FROM towers;
```

Instead of the asterisk, we've listed the columns, separated by commas. The reply:

```
 label |  lines  | height_m
-------+---------+----------
 N01   | N       |     28.6
 N02   | N       |     36.1
 N03   | N       |     29.3
 ...
(33 rows)
```

There are still 33 rows, but only three columns, in the order we named them.

## Step 3. Keeping only the tall towers

Now for the main part: let's ask the server to show us not every row, but only the ones where the height is more than 35 metres.

```sql
SELECT label, height_m FROM towers WHERE height_m > 35;
```

- `WHERE` sets a condition that a row has to meet to make it into the answer;
- `height_m > 35` means 'the height is more than 35'.

The reply:

```
 label | height_m
-------+----------
 N02   |     36.1
 N06   |     78.9
 A02   |     36.1
 A04   |     36.1
 B03   |     36.3
 B04   |     36.1
 B06   |     36.1
 C02   |     36.1
 C04   |     36.0
 C06   |     36.0
(10 rows)
```

Ten towers. More than we thought. Nearly all of them are just over 36 metres, and they're towers on lines A, B and C: it looks as though the towers there are all of one type.

And one stands out: **N06, at 78.9 metres**, twice the height of the rest. Perhaps it really is that tall, say because it stands over a deep valley. Or perhaps the lidar picked up something else nearby. We make a note of it. We'll come back to it once we've learned to sort the data and find outliers.

We can compare in other ways, not just 'more than':

| Sign | Meaning | Example |
|---|---|---|
| `=` | equal to | `lines = 'S'` |
| `<>` | not equal to | `lines <> 'S'` |
| `>` / `<` | more than / less than | `height_m > 35` |
| `>=` / `<=` | more than or equal to / less than or equal to | `slope_deg >= 20` |

## Step 4. Two conditions at once: AND

Now a harder question: tall towers on a steep slope. We need both conditions at once:

```sql
SELECT label, height_m, slope_deg FROM towers WHERE height_m > 35 AND slope_deg > 20;
```

`AND` means a row makes it into the answer only if it meets **both** conditions. The reply:

```
 label | height_m | slope_deg
-------+----------+-----------
(0 rows)
```

None at all. That's a result too, and it doesn't match our guess. The tall towers stand on gentle ground: all ten have a slope of less than 20 degrees. An empty answer isn't an error. The server is telling us honestly that there are no such rows.

## Step 5. At least one condition: OR

And what if, before winter, we want to inspect the towers that are **either** tall **or** on a steep slope?

```sql
SELECT label, height_m, slope_deg FROM towers WHERE height_m > 35 OR slope_deg > 20;
```

`OR` means a row makes it into the answer if it meets **at least one** of the conditions. The reply:

```
 label | height_m | slope_deg
-------+----------+-----------
 N02   |     36.1 |      18.0
 N03   |     29.3 |      25.2
 N06   |     78.9 |      10.8
 S04   |     34.6 |      24.7
 S05   |     26.1 |      23.2
 A02   |     36.1 |       8.5
 A04   |     36.1 |       9.6
 B03   |     36.3 |       4.1
 B04   |     36.1 |      13.8
 B06   |     36.1 |      14.1
 C02   |     36.1 |       7.6
 C04   |     36.0 |      15.9
 C06   |     36.0 |      11.5
(13 rows)
```

13 towers: the 10 tall ones and another 3 on a steep slope (N03, S04, S05). `AND` narrows the answer; `OR` widens it.

## Step 6. A condition on text

Which towers stand on line S?

```sql
SELECT label, lines FROM towers WHERE lines = 'S';
```

We write text in a condition in **single quotes**: `'S'`. The reply:

```
 label | lines
-------+-------
 S02   | S
 S03   | S
 S04   | S
 S05   | S
 S06   | S
(5 rows)
```

Five towers. But where's S01? It stands on line S too, but its `lines` column says `S,A,B,C`. And `=` looks for an exact match, letter for letter, and `'S,A,B,C'` isn't equal to `'S'`. We'll see how to find text that only **contains** S in Lesson 3.3.

## What we found

Let's compare with our guess. There are 10 towers taller than 35 metres, not a handful. There are no tall towers on a steep slope at all, although we expected one or two. And among the tall ones we found the odd N06, at 78.9 metres. Every one of these results is something we now know about the line that we didn't know before the query.

A query now reads like a sentence: **show** these columns **from** this table **where** this condition is met.

## If something goes wrong

- **`ERROR: column "s" does not exist`** after `WHERE lines = S`. Without quotes, the server takes `S` to be a column name, and there's no such column. We always write text in single quotes: `'S'`.
- **`ERROR: column "hight_m" does not exist`** with the hint `HINT: Perhaps you meant to reference the column "towers.height_m".` A typo in the column name. The server suggested the right name itself.
- **`(0 rows)`.** This isn't an error: there are no such rows. We check the condition: perhaps the sign points the wrong way (`<` instead of `>`), or there's an `AND` where we need an `OR`.
- **There's a colon `:` at the bottom of the screen, rows are repeating and the prompt has disappeared.** psql is showing a long answer page by page. We press `q` to get back to the prompt. If paging gets in the way, we can switch it off with `\pset pager off`: then psql prints the whole answer at once. To switch it back on: `\pset pager on`.

## Your data

On our own table, everything works the same way: `SELECT` with the columns we need, `FROM` with the table name, `WHERE` with the condition. We write numbers as they are (`35`), and text in single quotes (`'S'`).

## Summary

**Terms:** choosing columns, a condition on rows, comparisons, 'and', 'or', an empty answer.
**Code:** `SELECT * FROM towers;`, `SELECT label, lines, height_m FROM towers;`, `WHERE height_m > 35`, `AND`, `OR`, `WHERE lines = 'S'`, `\pset pager off`.
**Key point:** `SELECT` chooses the columns, `WHERE` chooses the rows. `AND` narrows the answer; `OR` widens it.

The queries from this lesson are in the file `code/ch03_queries.sql`.

## Questions for an engineer

1. *The query with `AND` returned 0 rows. Does that mean we made a mistake?*

   :::{dropdown} Answer

   Not necessarily. An empty answer is a result too: there are no rows that meet both conditions. We just need to check that the condition is written the way we meant it.
   :::

2. *Why didn't S01 come up in the answer to `WHERE lines = 'S'`, even though it stands on line S?*

   :::{dropdown} Answer

   `=` looks for an exact match. The column for S01 says `S,A,B,C`, and that isn't the same as `S`.
   :::

## Exercises

1. **Recall.** Which word in a query keeps only the rows that meet a condition?

2. **Fix.** A colleague is looking for the towers on line N and writes `SELECT label FROM towers WHERE lines = N;`. The server replied with an error. What needs fixing?

3. **Look back (Lesson 2.2).** Which query did we use to check that the table has 33 towers?

[Answers](#en-ch03-l01)

## The open question

We've found the tall towers and the towers on steep slopes. But the height of a tower came from the lidar, and the height of the ground from the terrain model. How high above sea level is the top of each tower? Can we ask the server to work that out right in the query?

## Sources

- PostgreSQL 18 Documentation, SELECT – https://www.postgresql.org/docs/18/sql-select.html (checked 27 November 2026)
- PostgreSQL 18 Documentation, Comparison Functions and Operators – https://www.postgresql.org/docs/18/functions-comparison.html (checked 27 November 2026)
- PostgreSQL 18 Documentation, Logical Operators – https://www.postgresql.org/docs/18/functions-logical.html (checked 27 November 2026)
- Data: `data/towers.csv`, Pajares project; © OpenStreetMap contributors, ODbL 1.0; 'PNOA cedido por © IGN'.
