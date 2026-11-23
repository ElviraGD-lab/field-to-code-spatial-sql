---
title: "Lesson 1.2. Installing PostgreSQL on our computer"
---

(en-ch01-l02-lesson)=
## Where we left off

In Lesson 1.1 we worked out that PostgreSQL is a server: a program that runs in the background all the time and answers questions. The questions come from clients, and our main client is psql. So far, all of this has only been a diagram. Now we install the server on our computer and ask it our first real question.

## What we want to know

How to install a PostgreSQL server together with PostGIS, and how to check that it can hear us.

Let's think before we start: how will we know it's all worked? We write down our guess about what we should see. At the end, we compare.

## Step 1. Installing the server

This is the only part of the lesson where the steps differ from one system to another. After this, everything is the same.

**Mac.** We install Postgres.app. It's a PostgreSQL server packaged as an ordinary app, and PostGIS is already included.

1. From postgresapp.com/downloads we download the file 'Postgres.app with PostgreSQL 18'.
2. We move Postgres.app into the Applications folder and double-click it to start it.
3. In the app window, we click **Initialize**. Postgres.app creates a PostgreSQL 18 server and starts it.

**Windows.** We install using the EDB installer and add PostGIS separately.

1. On postgresql.org/download/windows we open 'Download the installer' and download PostgreSQL 18.
2. We run the installer. In the list of components, we leave PostgreSQL Server, Command Line Tools and Stack Builder ticked.
3. The installer asks for a password for the `postgres` user. We write it down: we'll need it every time we connect. We leave the port as 5432.
4. At the end of the installation, Stack Builder starts. In it, we choose our PostgreSQL 18 server, then Spatial Extensions → PostGIS 3.6 Bundle for PostgreSQL 18, and install it.

**Linux (Ubuntu, Debian).** We add the official PostgreSQL repository and install the server together with PostGIS:

```bash
sudo apt install -y postgresql-common
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
sudo apt update
sudo apt install postgresql-18 postgresql-18-postgis-3
```

Line by line:

- `sudo` (superuser do: 'run as administrator') means the system will ask for our computer password;
- `apt install` means 'install a program'; `-y` means 'yes to every question';
- the second line runs a ready-made script that adds the official PostgreSQL repository. That's how we make sure we get version 18;
- `apt update` means 'refresh the list of programs';
- the last line installs the server (`postgresql-18`) and PostGIS for it (`postgresql-18-postgis-3`).

On Linux, the server starts by itself straight after installation.

## Step 2. Checking that the server is running

The server runs in the background, so it's important to know how to check that it's up.

On a Mac, we can see it in the Postgres.app window. Next to the PostgreSQL 18 server it says **Running**, and below that are its databases: `postgres`, `template1` and a database with our user name. The port is 5432, the same 'door' as in Lesson 1.1.

On Windows, the server is installed as a service and starts when the computer starts. On Linux, the server also starts by itself.

So the server is there and listening at its door. Now we need a client.

## Step 3. Teaching the Terminal to find psql (Mac only)

psql is already inside Postgres.app, but the Terminal doesn't know where to look for it yet. We point it there with one command:

```bash
sudo mkdir -p /etc/paths.d && echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp
```

Piece by piece:

- `sudo mkdir -p /etc/paths.d` means 'create (make directory) the system folder `/etc/paths.d` if it doesn't exist yet'. `-p` means 'don't complain if the folder is already there';
- `&&` means 'if the first part ran without an error, run the second';
- `echo /Applications/.../bin` prints the path to the folder that holds psql and the other PostgreSQL commands;
- `|` passes whatever was printed on to the next command;
- `sudo tee /etc/paths.d/postgresapp` writes that path into the file `postgresapp`. This folder is where the Terminal finds out where to look for commands.

The Terminal only reads these files when it starts. So we close every Terminal window and open a new one.

On Windows, we can open a ready-made client: the Start menu has **SQL Shell (psql)**. On Linux, psql is installed along with the server.

## Step 4. Opening the Terminal in VS Code

We'll work in VS Code: we write queries in one part of the window, and run them in the Terminal in another. We open VS Code and choose **Terminal → New Terminal** from the menu. A Terminal appears at the bottom of the window.

Let's check that the Terminal can find psql:

```bash
psql --version
```

The reply:

```
psql (PostgreSQL) 18.6 (Postgres.app)
```

`--version` means 'show the version'. The reply tells us two things: the psql client has been found, and it's version 18. On Windows and Linux the brackets will show a different build name, but the number 18 will be the same.

## Step 5. Connecting to the server

Now the client knocks on the server's door:

```bash
psql
```

On a Mac, the first time we connect, Postgres.app may ask whether to allow VS Code to connect to the server. We click **OK**: that way, the server remembers that this client can be trusted.

The Terminal prompt changes:

```
psql (18.6 (Postgres.app))
Type "help" for help.

admin=#
```

Let's look at what we're seeing:

- `admin` is the database we've connected to. If we don't tell psql which database to go to, it goes to the one with our user name. On a Mac, Postgres.app created it. On our computer the user is called `admin`; on another computer there'll be a different name here;
- `=#` means psql is waiting for a command. The `#` sign means we've logged in as the server's main user, who is allowed to do anything.

On Windows, we connect like this: `psql -U postgres`. Here `-U` (user) means 'log in as the user `postgres`', and psql asks for the password from Step 1. The prompt will be `postgres=#`. On Linux: `sudo -u postgres psql`, and the prompt is `postgres=#` there too.

## Step 6. Asking what we're connected to

psql has commands of its own. They start with a backslash `\` and aren't part of SQL: they're commands for the client itself. Here's the first:

```
\conninfo
```

`\conninfo` (connection information) shows how we're connected. The reply on our computer:

```
    Connection Information
      Parameter       | Value
----------------------+-------
 Database             | admin
 Client User          | admin
 Socket Directory     | /tmp
 Server Port          | 5432
 Options              |
 Protocol Version     | 3.0
 Password Used        | false
 GSSAPI Authenticated | false
 Backend PID          | 90513
 SSL Connection       | false
 Superuser            | on
 Hot Standby          | off
(12 rows)
```

There are twelve rows, but for now we need five:

- `Database | admin` is the database we're in;
- `Client User | admin` is the user we logged in as;
- `Server Port | 5432` is the server's door that we came in through;
- `Password Used | false` means no password was asked for. That's how Postgres.app is set up by default: only programs on this same computer can connect, and only the ones we've allowed. On Windows this will say `true`, because we typed in a password;
- `Superuser | on` means we're the server's main user. It's the same thing as the `#` sign in the prompt.

The other rows are technical details of the connection. We'll need them later, or not at all.

Now let's ask the server our first question in SQL:

```sql
SELECT version();
```

The reply:

```
                                                         version
--------------------------------------------------------------------------------------------------------------------------
 PostgreSQL 18.6 (Postgres.app) on aarch64-apple-darwin23.6.0, compiled by Apple clang version 15.0.0 (clang-1500.3.9.4), 64-bit
(1 row)
```

- `SELECT` means 'show'. It's a command that only asks and changes nothing (Lesson 1.1);
- `version()` is a server function that returns the server's version. The round brackets show that it's a function;
- `;` means the question ends here.

The reply is a small table: one column, `version`, and one row, `(1 row)`. What matters to us is the start: PostgreSQL 18.6. The rest of the line tells us how the program was built. On another computer or another build it will be different, and that's fine.

Let's notice the difference. `\conninfo` is a command for the client, and it doesn't need a semicolon. `SELECT version();` is a question in SQL for the server, and without the semicolon the server will wait for the rest of it.

We quit psql:

```
\q
```

`\q` (quit) means 'exit'. The Terminal prompt goes back to normal. There's more on psql commands in Lesson 1.3.

## What we found

Let's compare with our guess. We saw three signs that everything is working:

- the server window says **Running**;
- `psql --version` replies with version 18;
- psql connected, `\conninfo` showed the database, the user and port 5432, and the server answered our first question.

The server and the client are both on our computer, and they're talking to each other.

## If something goes wrong

- **`zsh: command not found: psql`.** The Terminal doesn't know where psql is. We check that the command from Step 3 ran without an error, and open a new Terminal window: an old one doesn't reread its settings.
- **After `SELECT version()` the server says nothing, and the prompt has changed to `admin-#`.** We forgot the semicolon, and psql is waiting for the end of the question. We type `;` and press Enter.
- **`Postgres.app rejected "trust" authentication`.** We answered 'no' when Postgres.app asked. We open Postgres.app → Settings → App Permissions and allow VS Code (or the Terminal).
- **`Port 5432 is already in use`.** Another PostgreSQL server is already running on the computer, perhaps one we installed earlier. We need to stop it or choose a different port for the new server.
- **Windows: `password authentication failed for user "postgres"`.** The password isn't the one we set during installation. We type it again; the password doesn't show on screen as we type, and that's how it should be.

## Your data

There's no data in this lesson yet. From Chapter 2 onwards, this is where we'll say what to replace to use our own data.

## Summary

**Terms:** installing the server, PostGIS included or added through Stack Builder, the path to commands in the Terminal, the psql prompt `=#`, client commands starting with `\`.
**Code:** `psql --version`, `psql`, `\conninfo`, `SELECT version();`, `\q`.
**Key point:** the server runs in the background, and psql connects to it through port 5432. Commands starting with `\` are for the client; SQL ending in `;` is for the server.

## Questions for an engineer

1. *A colleague has closed the Postgres.app window. Has the server stopped?*

   :::{dropdown} Answer

   No. The window is just a control panel. The server keeps running in the background until someone stops it with the Stop button or the computer is switched off.
   :::

2. *Why does `\conninfo` work without a semicolon, but `SELECT version()` doesn't?*

   :::{dropdown} Answer

   `\conninfo` is a command for the psql client itself, and it runs it straight away. `SELECT` is a question in SQL for the server, and psql only sends it to the server once it sees `;`.
   :::

## Exercises

1. **Recall.** Which psql command shows which database we're connected to, as which user and through which port?

2. **Fix.** We typed `SELECT version()` and pressed Enter. The server says nothing, and the prompt has changed to `admin-#`. What do we need to type?

3. **Look back (Lesson 1.1).** What's the number of the 'door' that clients knock on to reach the PostgreSQL server, and what is that door called?

[Answers](#en-ch01-l02)

## The open question

The server is running, and psql connects to it. But our `admin` database was created by the app, not by us, and there are no towers in it yet. How do we create our own database for the book and switch to it?

## Sources

- Postgres.app, Installing Postgres.app – https://postgresapp.com/documentation/install.html
- PostgreSQL, Windows installers – https://www.postgresql.org/download/windows/
- PostGIS, Windows installation (released versions) – https://postgis.net/documentation/getting_started/install_windows/released_versions/
- PostgreSQL, Linux downloads (Ubuntu) – https://www.postgresql.org/download/linux/ubuntu/
- PostgreSQL 18 Documentation, psql – https://www.postgresql.org/docs/18/app-psql.html
