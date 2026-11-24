---
title: "Lección 1.3. Nuestra primera base de datos"
---

(es-ch01-l03-lesson)=
## Dónde lo dejamos

En la lección 1.2 instalamos PostgreSQL, nos conectamos con psql y le hicimos la primera pregunta: `SELECT version();`. Pero nos conectamos a la base `admin`, que creó el programa al instalarse, no nosotros. Para el libro necesitamos una base de datos propia.

## Qué queremos saber

Cómo crear nuestra propia base de datos para el libro y cómo entrar en ella.

Antes de empezar, pensemos: en la lección 1.1 separamos los comandos que preguntan de los que cambian algo. Crear una base de datos cambia algo en el servidor. ¿Qué cambia exactamente? Anotamos nuestra hipótesis y al final la comparamos.

## Paso 1. Vemos qué bases de datos hay ya

Nos conectamos al servidor, como en la lección 1.2:

```bash
psql
```

Y pedimos la lista de bases de datos:

```
\l
```

`\l` (list, «lista») es una orden para el cliente psql. Por eso empieza por `\` y no necesita punto y coma. La respuesta:

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

En nuestro ordenador la lista tiene además bases de datos de otros trabajos. Aquí las hemos quitado para ver lo que hay en un servidor recién instalado.

La tabla es ancha, pero ahora solo nos interesan tres columnas:

- `Name`: el nombre de la base de datos;
- `Owner` (propietario): el usuario al que pertenece la base;
- `Encoding` (codificación): `UTF8` significa que la base guarda letras de cualquier idioma. Para nosotros es importante: Pajares, Cangas de Onís, Tuiza.

Qué son estas cuatro bases de datos:

- `admin`: la base con nuestro nombre de usuario. psql entra en ella cuando no le decimos adónde ir (lección 1.2). En Windows y Linux puede que no exista;
- `postgres`: una base de servicio que existe en cualquier servidor. Es un buen sitio al que conectarse cuando todavía no tenemos una base propia;
- `template0` y `template1` (template, «plantilla»): bases de partida. Cada base nueva se crea como copia de `template1`. Las plantillas no las tocamos.

## Paso 2. Creamos nuestra base de datos

```sql
CREATE DATABASE spatial_sql;
```

Por partes:

- `CREATE DATABASE`: «crea una base de datos». Es un comando que cambia la estructura del servidor (lección 1.1);
- `spatial_sql`: el nombre de la base nueva;
- `;`: el comando ha terminado.

La respuesta del servidor es corta:

```
CREATE DATABASE
```

El servidor repite el nombre del comando: es su forma de decir «hecho». No hay ningún mensaje de error, así que todo ha ido bien.

¿Por qué este nombre, en minúsculas y con un guion bajo en lugar de un espacio? Para el servidor, un espacio marca el final de una palabra, así que un nombre con espacios no lo entiende. Y las mayúsculas PostgreSQL las convierte por su cuenta en minúsculas: si escribimos `Spatial_SQL`, la base se llamará `spatial_sql`. Por eso acordamos desde ya escribir los nombres en minúsculas, con `_` entre palabras. Es lo que se hace en la mayoría de las empresas.

## Paso 3. Comprobamos que la base de datos está ahí

Volvemos a pedir la lista:

```
\l
```

En la respuesta aparece una fila nueva:

```
 spatial_sql | admin    | UTF8     | icu             | en_US.UTF-8 | en_US.UTF-8 | en-US  |           |
```

El propietario de la base es `admin`, o sea, nosotros: una base pertenece a quien la crea.

## Paso 4. Entramos en la base nueva

Todavía estamos en la base `admin`, como se ve en el prompt `admin=#`. Pasamos a nuestra base:

```
\c spatial_sql
```

`\c` (connect, «conectar») es una orden para el cliente: «desconéctate de la base actual y conéctate a esta». La respuesta:

```
You are now connected to database "spatial_sql" as user "admin".
```

«Ahora estamos conectados a la base `spatial_sql` como usuario `admin`». El prompt también ha cambiado:

```
spatial_sql=#
```

Para quedarnos tranquilos, se lo preguntamos otra vez al servidor:

```sql
SELECT current_database();
```

`current_database()` es una función del servidor: «¿en qué base estoy ahora?». La respuesta:

```
 current_database
------------------
 spatial_sql
(1 row)
```

## Paso 5. Salimos y volvemos directamente a nuestra base

Salimos de psql:

```
\q
```

`\q` (quit) significa «salir» (lección 1.2). Nuestra base de datos sigue en el servidor. Vive en el servidor, no en la ventana del Terminal.

La próxima vez no hace falta entrar en `admin` y luego cambiar con `\c`. Podemos decirle a psql directamente a qué base ir:

```bash
psql -d spatial_sql
```

`-d` (database, «base de datos») significa «conéctate a esta base». La respuesta:

```
psql (18.6 (Postgres.app))
Type "help" for help.

spatial_sql=#
```

El prompt ya es `spatial_sql=#` desde el principio. Así empezaremos cada lección.

## Qué ha salido

Comparamos con nuestra hipótesis. El comando `CREATE DATABASE` ha añadido al servidor una base nueva, vacía de momento. La vemos en la lista de `\l`, y su propietario somos nosotros. Ya sabemos:

- ver la lista de bases de datos: `\l`;
- crear una base de datos: `CREATE DATABASE`;
- entrar en ella desde dentro de psql, con `\c`, o directamente desde el Terminal, con `psql -d`.

## Si algo falla

- **`ERROR: database "spatial_sql" already exists`.** La base ya existe: la creamos antes. No pasa nada, simplemente entramos en ella: `\c spatial_sql`.
- **`ERROR: syntax error at or near "sql"`** después de `CREATE DATABASE spatial sql;`. El nombre lleva un espacio, y el servidor no entiende qué es `sql`. Lo escribimos con guion bajo: `spatial_sql`.
- **Después de `\c spatial_sq` sale el error `FATAL: database "spatial_sq" does not exist`.** Hay una errata en el nombre. psql se queda en la base en la que estábamos; miramos el nombre exacto en `\l` y lo repetimos.
- **La base nueva no aparece en `\l`.** Lo más probable es que se nos olvidara el `;` después de `CREATE DATABASE spatial_sql` y el prompt pasara a `admin-#`: el servidor está esperando el final del comando. Escribimos `;` y pulsamos Enter.

## Tus datos

Para nuestro propio proyecto creamos una base de datos exactamente igual, solo que con otro nombre, por ejemplo `CREATE DATABASE my_project;`. Una base de datos por proyecto: así las tablas de distintos trabajos no se mezclan.

## Tu ordenador

En Windows y Linux entramos como el usuario `postgres` (lección 1.2), así que el propietario de `spatial_sql` será `postgres`. Para volver a la base, allí lo hacemos así:

- en Windows: `psql -U postgres -d spatial_sql`;
- en Linux: `sudo -u postgres psql -d spatial_sql`.

## Resumen

**Conceptos:** lista de bases de datos, propietario de una base, codificación UTF8, base de servicio `postgres`, plantillas, base de datos actual.
**Código:** `\l`, `CREATE DATABASE spatial_sql;`, `\c spatial_sql`, `SELECT current_database();`, `\q`, `psql -d spatial_sql`.
**Lo esencial:** una base de datos es un mundo aparte dentro del servidor. La creamos una vez y luego entramos en ella cada vez que trabajamos.

Los comandos de esta lección están en el repositorio del libro, en el archivo `code/ch01_first_database.sql`. Cómo ejecutar archivos así de una vez lo vemos en el capítulo 2.

## Preguntas para un ingeniero

1. *¿Por qué creamos una base de datos propia para el libro en lugar de meter las tablas en `admin`?*

   :::{dropdown} Respuesta

   Porque una base de datos es un mundo aparte. Las tablas del proyecto están juntas y no se mezclan con otros trabajos, y la base del proyecto se puede guardar, mover o borrar entera sin tocar nada más.
   :::

2. *Hemos cerrado el Terminal. ¿Qué le ha pasado a la base `spatial_sql`?*

   :::{dropdown} Respuesta

   Nada. La base se guarda en el servidor, y el servidor sigue funcionando en segundo plano. El Terminal era solo un cliente.
   :::

## Ejercicios

1. **Recordar.** ¿Con qué comando nos muestra psql la lista de todas las bases de datos del servidor?

2. **Corregir.** Un compañero ha escrito `CREATE DATABASE Pajares Risk;` y le ha dado error. ¿Cómo se escribe bien el comando, según nuestra regla de los nombres?

3. **Recordar lo anterior (lección 1.2).** ¿Con qué comando nos muestra psql a qué base de datos, con qué usuario y por qué puerto estamos conectados?

[Respuestas](#es-ch01-l03)

## La pregunta abierta

La base `spatial_sql` ya existe, pero está vacía. Para meter en ella los apoyos necesitamos una tabla. ¿Cómo le explicamos al servidor qué columnas tiene un apoyo y de qué tipo son?

## Fuentes

- PostgreSQL 18 Documentation, CREATE DATABASE — https://www.postgresql.org/docs/18/sql-createdatabase.html
- PostgreSQL 18 Documentation, Template Databases — https://www.postgresql.org/docs/18/manage-ag-templatedbs.html
- PostgreSQL 18 Documentation, psql — https://www.postgresql.org/docs/18/app-psql.html
