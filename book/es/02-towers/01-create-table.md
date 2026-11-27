---
title: "Lección 2.1. Describimos un apoyo: la primera tabla"
---

(es-ch02-l01-lesson)=
## Dónde lo dejamos

En el capítulo 1 instalamos PostgreSQL y creamos nuestra base de datos, `spatial_sql`. La base existe, pero está vacía: no tiene tablas. Y los apoyos de las líneas de Pajares siguen en un archivo CSV.

## Qué queremos saber

Cómo le describimos al servidor un apoyo: qué columnas tiene y de qué tipo son. Y cómo conseguimos que en la tabla no haya dos apoyos con la misma etiqueta.

Antes de empezar, pensemos: en el CSV cada apoyo tiene una etiqueta, una línea, unas coordenadas y una altura. ¿Cuáles de estos valores son números y cuáles son texto? ¿Y hay algún valor que sea distinto en cada apoyo y no se repita nunca? Anotamos nuestra hipótesis.

## Paso 1. Vemos lo que sabemos de un apoyo

El archivo original del proyecto tiene 28 columnas. Para el libro nos quedamos con ocho, las que vamos a necesitar en los próximos capítulos. Estos son los tres primeros apoyos:

| label | lines | x | y | ground_z_m | height_m | slope_deg | anchor_candidate |
|---|---|---|---|---|---|---|---|
| N01 | N | 274101.61 | 4766898.64 | 1124.15 | 28.6 | 7.5 | False |
| N02 | N | 274178.44 | 4766662.48 | 1060.78 | 36.1 | 18.0 | False |
| N03 | N | 274313.17 | 4766250.94 | 1067.22 | 29.3 | 25.2 | True |

Qué hay en cada columna:

- `label`: la etiqueta del apoyo, con la letra de la línea y un número;
- `lines`: la línea en la que está el apoyo. Hay cinco líneas: N, A, B, C, S;
- `x`, `y`: las coordenadas en metros, en el sistema ETRS89 / UTM zona 30N (código EPSG:25830). Es el mismo sistema que usan los mapas de España;
- `ground_z_m`: la cota del terreno en la base del apoyo, en metros sobre el nivel del mar;
- `height_m`: la altura del propio apoyo en metros, medida con LiDAR;
- `slope_deg`: la pendiente del terreno junto al apoyo, en grados;
- `anchor_candidate`: si este apoyo puede ser de amarre, es decir, si sujeta el conductor de forma fija. Los apoyos de amarre suelen estar en los cambios de dirección de la línea.

Los nombres de las columnas van en inglés, en minúsculas y con `_` entre palabras. Es la misma regla que usamos para el nombre de la base de datos (lección 1.3).

## Paso 2. Elegimos el tipo de cada columna

En la lección 1.1 vimos que cada columna tiene un tipo, y que el servidor no deja entrar en una columna un valor del tipo equivocado. Para los apoyos nos bastan tres tipos:

| Tipo | Qué guarda | Nuestras columnas |
|---|---|---|
| `text` | cualquier texto, de cualquier longitud | `label`, `lines` |
| `numeric` | un número, también con decimales, sin perder precisión | `x`, `y`, `ground_z_m`, `height_m`, `slope_deg` |
| `boolean` | «sí» o «no»: `true` / `false` | `anchor_candidate` |

¿Por qué las coordenadas son `numeric` y no `text`? Porque con ellas vamos a hacer cálculos: comparar, restar, buscar distancias. Con el texto `'274101.61'` el servidor no calcula. Además, `numeric` guarda el número exactamente como lo escribimos: 274101.61 sigue siendo 274101.61 hasta la última cifra.

## Paso 3. Elegimos qué distingue un apoyo de otro

Cada apoyo tiene su propia etiqueta: N01, N02… En nuestro archivo hay 33 apoyos y 33 etiquetas distintas. Si en la tabla se cuela por error un segundo N01, luego no podremos saber cuál de los dos es el bueno.

Por eso hacemos de `label` la **clave primaria** (primary key). La clave primaria es una columna cuyo valor:

- es distinto en cada fila, sin repeticiones;
- existe siempre, nunca está vacío.

El servidor vigila por sí mismo estas dos reglas. Una tabla solo puede tener una clave primaria.

## Paso 4. Creamos la tabla

Nos conectamos a nuestra base de datos:

```bash
psql -d spatial_sql
```

Y creamos la tabla:

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

Lo leemos línea a línea:

- `CREATE TABLE towers (`: «crea la tabla `towers`», es decir, «apoyos». Después, entre paréntesis, va la lista de columnas;
- cada línea de dentro es una columna: primero el nombre y luego el tipo. Las columnas se separan con comas;
- `label text PRIMARY KEY`: la columna `label`, de tipo `text`, que además es la clave primaria;
- la última columna no lleva coma: con ella se acaba la lista;
- `);`: cerramos el paréntesis y terminamos el comando.

Mientras escribimos las líneas de dentro del paréntesis, el prompt de psql es así: `spatial_sql(#`. El paréntesis en lugar del signo `=` significa que psql ve un paréntesis abierto y espera a que lo cerremos. Es normal.

Los espacios que alinean los tipos en columna no le hacen falta al servidor. Nos hacen falta a nosotros: así la tabla se lee mejor. El mismo comando se puede escribir en una sola línea, y el servidor lo entiende igual:

```sql
CREATE TABLE towers (label text PRIMARY KEY, lines text, x numeric, y numeric, ground_z_m numeric, height_m numeric, slope_deg numeric, anchor_candidate boolean);
```

La respuesta del servidor:

```
CREATE TABLE
```

Igual que en la lección 1.3, el servidor repite el nombre del comando: «hecho».

## Paso 5. Comprobamos lo que ha salido

Le pedimos a psql que describa nuestra tabla:

```
\d towers
```

`\d` (describe, «describe») es una orden para el cliente. La respuesta:

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

Lo importante aquí:

- `Table "public.towers"`: la dirección completa de la tabla, esquema `public` y tabla `towers`. Es tal como la escribimos en la lección 1.1;
- `Column` y `Type`: las ocho columnas, con los tipos que elegimos;
- `Nullable`: si la columna puede quedar vacía. En `label` pone `not null`: la clave primaria no puede estar vacía, y el servidor ha añadido esta regla por su cuenta;
- `Indexes`: abajo, el servidor nos dice que la tabla tiene una clave primaria, `towers_pkey`, sobre la columna `label`. El nombre lo ha puesto el servidor: el nombre de la tabla más `_pkey` (primary key). La palabra `btree` describe cómo encuentra rápido el servidor los valores de la clave; lo vemos con más detalle en el capítulo de los índices.

## Qué ha salido

Comparamos con nuestra hipótesis. La etiqueta y la línea son texto; las coordenadas, las alturas y la pendiente son números; si el apoyo es de amarre es un «sí o no». La etiqueta es distinta en cada apoyo, y por eso se ha convertido en la clave primaria. En la base `spatial_sql` ya tenemos la tabla `towers`, con ocho columnas. De momento no tiene filas.

## Si algo falla

- **El prompt ha pasado a `spatial_sql(#` y todavía no hemos terminado, o nos hemos equivocado.** psql está esperando el paréntesis de cierre. Si el comando que hemos empezado tiene un error (por ejemplo, hemos escrito `CREATE TABLE (` y se nos ha olvidado el nombre de la tabla), no hace falta terminarlo: borramos todo lo escrito con `\r` (reset, «reiniciar») o con Ctrl+C. psql responde `Query buffer reset (cleared).`, y el prompt vuelve a ser `spatial_sql=#`.
- **`ERROR: relation "towers" already exists`.** La tabla ya existe: la creamos antes. `relation` es como llama el servidor a las tablas. La miramos con `\d towers`.
- **`ERROR: type "numbr" does not exist`.** Hay una errata en el tipo. El servidor solo conoce los nombres reales de los tipos: `numeric`, `text`, `boolean`.
- **`ERROR: multiple primary keys for table "towers" are not allowed`.** Hemos escrito `PRIMARY KEY` en dos columnas. Una tabla tiene una sola clave primaria.
- **`ERROR: syntax error at or near ")"`.** Casi siempre es una coma de más después de la última columna. La quitamos.
- **La tabla se ha creado en la base `admin`.** Se nos olvidó conectarnos a `spatial_sql`. Miramos el prompt: tiene que ser `spatial_sql=#`.

## Tus datos

Con nuestros propios datos hacemos lo mismo: abrimos nuestro CSV, apuntamos las columnas que necesitamos, elegimos un tipo para cada una y buscamos una columna cuyo valor no se repita nunca. Esa será la clave primaria.

## Tu ordenador

En Windows nos conectamos así: `psql -U postgres -d spatial_sql`. En Linux, así: `sudo -u postgres psql -d spatial_sql`.

## Resumen

**Conceptos:** tabla, columna, tipo (`text`, `numeric`, `boolean`), clave primaria.
**Código:** `CREATE TABLE towers (...)`, `PRIMARY KEY`, `\d towers`, `\r`.
**Lo esencial:** una tabla la describimos una sola vez: nombre, columnas, tipos y clave. A partir de ahí, el servidor vigila por sí mismo que los datos cumplan esa descripción.

## Preguntas para un ingeniero

1. *¿Por qué hemos hecho clave primaria la etiqueta y no la altura del apoyo?*

   :::{dropdown} Respuesta

   Porque la altura se puede repetir: en nuestros datos hay varios apoyos de 36,1 m. En cambio, la etiqueta es distinta en cada apoyo y no se repite nunca.
   :::

2. *Un compañero propone guardar las coordenadas como `text`: «es más fácil, son solo las cifras del archivo». ¿Qué perdemos?*

   :::{dropdown} Respuesta

   Con texto el servidor no calcula: no compara, no resta, no encuentra distancias. Y además en la columna puede acabar cualquier cosa, hasta «sin datos». El tipo `numeric` solo deja entrar números.
   :::

## Ejercicios

1. **Recordar.** ¿Qué tipo elegimos para la columna que guarda una respuesta de «sí o no»?

2. **Corregir.** Un compañero ha descrito la tabla de vanos así: `CREATE TABLE spans (span_label text PRIMARY KEY, length_m text);`. La longitud de los vanos la vamos a sumar y comparar. ¿Qué hay que corregir?

3. **Recordar lo anterior (lección 1.1).** ¿Cómo se escribe la dirección completa de nuestra tabla de apoyos, la que nos ha mostrado `\d`?

[Respuestas](#es-ch02-l01)

## La pregunta abierta

La tabla está lista, pero no tiene ni un apoyo. ¿Cómo cargamos los 33 apoyos desde el archivo CSV y nos aseguramos de que no se ha perdido ninguno?

## Fuentes

- PostgreSQL 18 Documentation, CREATE TABLE — https://www.postgresql.org/docs/18/sql-createtable.html (consultado el 27.11.2026)
- PostgreSQL 18 Documentation, Data Types — https://www.postgresql.org/docs/18/datatype.html (consultado el 27.11.2026)
- PostgreSQL 18 Documentation, Constraints — https://www.postgresql.org/docs/18/ddl-constraints.html (consultado el 27.11.2026)
- Datos: apoyos de las líneas de 400 kV de Pajares, proyecto Pajares (datos derivados; © colaboradores de OpenStreetMap, ODbL; LiDAR PNOA cedido por © IGN).
