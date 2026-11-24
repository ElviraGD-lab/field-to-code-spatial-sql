---
title: "Lesson 1.3. Our first database"
---

(en-ch01-l03-lesson)=
## Where we left off

In Lesson 1.2 we installed PostgreSQL, connected to it with psql and asked our first question: `SELECT version();`. But we connected to the `admin` database, and that was created by the app during installation, not by us. For the book, we need a database of our own.

## What we want to know

How to create our own database for the book and switch to it.

Let's think before we start. In Lesson 1.1 we split commands into the ones that ask and the ones that change something. Creating a database changes something on the server. What exactly? We write down our guess, and at the end we compare.

## Step 1. Seeing which databases are already there

We connect to the server, as in Lesson 1.2:

```bash
psql
```

And ask for the list of databases:

```
\l
```

`\l` (list) is a command for the psql client, so it starts with `\` and doesn't need a semicolon. The reply:

```
                                                    List of databases
   Name    |  Owner   | Encoding | Locale Provider |   Collate   |    Ctype    | Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+-------------+-------------+--------+-----------+-----------------------
 admin     | admin    | UTF8     | icu             | en_US.UTF-8 | en_US.UTF-8 | en-US  |           |
 postgres  | postgres | UTF8     | icu             | en_US.UTF-8 | en_US.UTF-8 | en-US  |           |
 template0 | postgres | UTF8     | icu             | en_US.UTF-8 | en_US.UTF-8 | en-US  |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | icu             | en_US.UTF-8 | en_US.UTF-8 | en-US  |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
(4 rows)
```

On our computer the list also has databases from other work. We've taken them out here, so that we see what a freshly installed server has.

The table is wide, but for now we need three columns:

- `Name` is the name of the database;
- `Owner` is the user the database belongs to;
- `Encoding`: `UTF8` means the database can store the letters of any language. That matters to us: Pajares, Cangas de Onís, Tuiza.

What are these four databases?

- `admin` is the database with our user name. psql goes into it when we don't say where to go (Lesson 1.2). On Windows and Linux it may not exist;
- `postgres` is a housekeeping database that every server has. It's a handy place to connect to when we don't have a database of our own yet;
- `template0` and `template1` are templates. A new database is created as a copy of `template1`. We leave the templates themselves alone.

## Step 2. Creating our own database

```sql
CREATE DATABASE spatial_sql;
```

Piece by piece:

- `CREATE DATABASE` means 'create a database'. It's a command that changes the structure of the server (Lesson 1.1);
- `spatial_sql` is the name of the new database;
- `;` means the command ends here.

The server's reply is short:

```
CREATE DATABASE
```

The server repeats the name of the command: that's its way of saying 'done'. There's no error message, so everything went through.

Why this particular name, in lower-case Latin letters with an underscore instead of a space? The server treats a space as the end of a word, so it won't understand a name with a space in it. And PostgreSQL turns capital letters into small ones by itself: if we write `Spatial_SQL`, we get a database called `spatial_sql`. So let's agree right now to write names in lower case, with `_` between the words. That's what most companies do.

## Step 3. Checking that the database is there

We ask for the list again:

```
\l
```

A new row has appeared in the reply:

```
 spatial_sql | admin    | UTF8     | icu             | en_US.UTF-8 | en_US.UTF-8 | en-US  |           |
```

The owner of the database is `admin`, which means us: whoever creates a database owns it.

## Step 4. Switching to the new database

We're still in the `admin` database, as the `admin=#` prompt shows. Let's switch to ours:

```
\c spatial_sql
```

`\c` (connect) is a command for the client: 'disconnect from the current database and connect to this one'. The reply:

```
You are now connected to database "spatial_sql" as user "admin".
```

So we're now in `spatial_sql`, logged in as `admin`. The prompt has changed too:

```
spatial_sql=#
```

Let's ask the server once more, to be sure:

```sql
SELECT current_database();
```

`current_database()` is a server function: 'which database am I in right now?' The reply:

```
 current_database
------------------
 spatial_sql
(1 row)
```

## Step 5. Quitting and coming straight back to our database

We quit psql:

```
\q
```

`\q` (quit) means 'exit' (Lesson 1.2). Our database stays on the server. It lives on the server, not in the Terminal window.

Next time, we don't need to go into `admin` first and then switch with `\c`. We can tell psql straight away which database to go to:

```bash
psql -d spatial_sql
```

`-d` (database) means 'connect to this database'. The reply:

```
psql (18.6 (Postgres.app))
Type "help" for help.

spatial_sql=#
```

The prompt is `spatial_sql=#` from the start. This is how we'll begin every lesson.

## What we found

Let's compare with our guess. The `CREATE DATABASE` command added a new, still empty database to the server. We can see it in the `\l` list, and we're its owner. Now we can:

- see the list of databases: `\l`;
- create a database: `CREATE DATABASE`;
- switch to it from inside psql with `\c`, or go straight there from the Terminal with `psql -d`.

## If something goes wrong

- **`ERROR: database "spatial_sql" already exists`.** The database is already there: we created it earlier. No harm done, we just switch to it: `\c spatial_sql`.
- **`ERROR: syntax error at or near "sql"`** after `CREATE DATABASE spatial sql;`. There's a space in the name, and the server didn't understand what `sql` was. We use an underscore: `spatial_sql`.
- **After `\c spatial_sq`, the error `FATAL: database "spatial_sq" does not exist`.** A typo in the name. psql stays in the database it was in; we check the exact name in `\l` and try again.
- **The new database isn't in `\l`.** Most likely we forgot the `;` after `CREATE DATABASE spatial_sql`, and the prompt has changed to `admin-#`: the server is waiting for the end of the command. We type `;` and press Enter.

## Your data

For our own project, we create a database in exactly the same way, just with a different name, for example `CREATE DATABASE my_project;`. One database per project: that way, the tables from different jobs don't get mixed up.

## Your computer

On Windows and Linux we logged in as the `postgres` user (Lesson 1.2), so the owner of `spatial_sql` there will be `postgres`. To get back into the database:

- on Windows: `psql -U postgres -d spatial_sql`;
- on Linux: `sudo -u postgres psql -d spatial_sql`.

## Summary

**Terms:** the list of databases, the database owner, UTF8 encoding, the `postgres` housekeeping database, templates, the current database.
**Code:** `\l`, `CREATE DATABASE spatial_sql;`, `\c spatial_sql`, `SELECT current_database();`, `\q`, `psql -d spatial_sql`.
**Key point:** a database is a world of its own on the server. We create it once, and then we go into it every time.

The commands from this lesson are in the book's repository, in the file `code/ch01_first_database.sql`. We'll see how to run a file like this in one go in Chapter 2.

## Questions for an engineer

1. *Why do we create our own database for the book instead of putting the tables in `admin`?*

   :::{dropdown} Answer

   A database is a world of its own. The project's tables stay together and don't get mixed up with other work, and we can back up, move or delete the whole project database without touching anything else.
   :::

2. *We've closed the Terminal. What's happened to the `spatial_sql` database?*

   :::{dropdown} Answer

   Nothing. The database is stored on the server, and the server runs in the background. The Terminal was only the client.
   :::

## Exercises

1. **Recall.** Which psql command shows the list of all the databases on the server?

2. **Fix.** A colleague typed `CREATE DATABASE Pajares Risk;` and got an error. How should the command be written, following our rule for names?

3. **Look back (Lesson 1.2).** Which psql command shows which database we're connected to, as which user and through which port?

[Answers](#en-ch01-l03)

## The open question

The `spatial_sql` database exists, but it's empty. To put the towers into it, we need a table. How do we tell the server which columns a tower has, and what type each one is?

## Sources

- PostgreSQL 18 Documentation, CREATE DATABASE – https://www.postgresql.org/docs/18/sql-createdatabase.html
- PostgreSQL 18 Documentation, Template Databases – https://www.postgresql.org/docs/18/manage-ag-templatedbs.html
- PostgreSQL 18 Documentation, psql – https://www.postgresql.org/docs/18/app-psql.html
