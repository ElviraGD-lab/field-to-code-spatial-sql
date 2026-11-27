---
title: "Lección 2.2. Cargamos los apoyos y los contamos"
---

(es-ch02-l02-lesson)=
## Dónde lo dejamos

En la lección 2.1 le describimos un apoyo al servidor: creamos la tabla `towers`, con ocho columnas y la clave primaria `label`. La tabla existe, pero está vacía. Los apoyos están en el archivo `towers.csv`.

## Qué queremos saber

Cómo pasar los 33 apoyos del archivo a la tabla y asegurarnos de que no se pierde ninguno y de que ninguno entra dos veces.

Antes de empezar, pensemos: ¿qué debería salir si todo va bien? ¿Y qué hará el servidor si por error cargamos el archivo dos veces? Recordemos que la clave primaria no deja pasar repeticiones. Anotamos nuestra hipótesis.

## Paso 1. Miramos el archivo

El archivo `towers.csv` está en la carpeta `data` del repositorio del libro. Si todavía no tenemos el repositorio en el ordenador, lo descargamos entero: en la página del repositorio en GitHub pulsamos **Code → Download ZIP** y descomprimimos el archivo.

Las primeras líneas del archivo:

```
label,lines,x,y,ground_z_m,height_m,slope_deg,anchor_candidate
N01,N,274101.61,4766898.64,1124.15,28.6,7.5,false
N02,N,274178.44,4766662.48,1060.78,36.1,18.0,false
N03,N,274313.17,4766250.94,1067.22,29.3,25.2,true
```

Lo que vemos:

- CSV (comma-separated values, «valores separados por comas») es un archivo de texto normal. Cada línea es un apoyo, y los valores van separados por comas;
- la primera línea no es un apoyo, sino los nombres de las columnas. Coinciden con las columnas de nuestra tabla y van en el mismo orden;
- el archivo tiene 34 líneas: la de los nombres y 33 apoyos.

Hay otra línea en la que merece la pena fijarse:

```
N10,"N,A,B,C",275096.13,4764068.65,1401.22,30.4,10.2,true
```

El apoyo N10 está en cuatro líneas a la vez, y en la columna `lines` pone `N,A,B,C`. Dentro de este valor también hay comas, así que va entre comillas: es la forma que tiene el archivo de decir que se trata de un solo valor y no de cuatro. Estos apoyos los veremos en el capítulo 5.

## Paso 2. Abrimos psql en la carpeta del libro

`\copy` busca el archivo a partir de la carpeta desde la que hemos abierto psql. Por eso primero vamos a la carpeta del repositorio y luego nos conectamos:

```bash
cd ~/projects/field-to-code-spatial-sql
psql -d spatial_sql
```

- `cd` (change directory, «cambiar de carpeta»): vamos a la carpeta del libro. Cada uno puede tenerla en un sitio distinto; ponemos nuestra propia ruta;
- `psql -d spatial_sql`: nos conectamos a nuestra base de datos (lección 1.3).

## Paso 3. Comprobamos que la tabla está vacía

Antes de cargar nada, le preguntamos al servidor cuántas filas tiene ahora la tabla:

```sql
SELECT count(*) FROM towers;
```

- `SELECT`: «muestra»;
- `count(*)`: la función del servidor que «cuenta las filas». El asterisco significa «todas las filas que haya»;
- `FROM towers`: «en la tabla de apoyos».

La respuesta:

```
 count
-------
     0
(1 row)
```

Cero filas: la tabla está vacía, como esperábamos.

## Paso 4. Cargamos los apoyos

```
\copy towers FROM 'data/towers.csv' WITH (FORMAT csv, HEADER true)
```

Lo leemos por partes:

- `\copy`: una orden para el cliente psql: «copia las filas del archivo en la tabla». Empieza por `\`, así que no necesita punto y coma;
- `towers`: en qué tabla;
- `FROM 'data/towers.csv'`: desde qué archivo. La ruta va entre comillas simples y parte de la carpeta en la que hemos abierto psql;
- `WITH (...)`: las opciones para leer el archivo:
  - `FORMAT csv`: el archivo está en formato CSV, con los valores separados por comas, y los valores que llevan comas dentro van entre comillas;
  - `HEADER true`: «la primera línea es la cabecera, sáltatela».

La respuesta:

```
COPY 33
```

El servidor nos dice que ha copiado 33 filas. Son exactamente los apoyos que hay en el archivo.

¿Por qué `\copy` y no simplemente `COPY`? El servidor tiene su propio comando `COPY`, pero ese lee los archivos del ordenador en el que funciona el servidor. En cambio, `\copy` es una orden de psql: es psql quien lee el archivo en nuestro ordenador y le pasa las filas al servidor. Cuando el servidor está en otra máquina, como suele pasar en las empresas, solo funciona `\copy`.

## Paso 5. Volvemos a contar

```sql
SELECT count(*) FROM towers;
```

La respuesta:

```
 count
-------
    33
(1 row)
```

33 apoyos en el archivo, 33 filas en la tabla. No se ha perdido ninguno.

## Paso 6. Qué pasa si cargamos el archivo otra vez

Es un error muy frecuente en el trabajo: alguien ejecuta un script dos veces. Vamos a ver qué hace el servidor. Repetimos el mismo comando:

```
\copy towers FROM 'data/towers.csv' WITH (FORMAT csv, HEADER true)
```

La respuesta:

```
ERROR:  duplicate key value violates unique constraint "towers_pkey"
DETAIL:  Key (label)=(N01) already exists.
CONTEXT:  COPY towers, line 2
```

Desmontamos el mensaje:

- `ERROR: duplicate key value violates unique constraint "towers_pkey"`: «un valor de clave repetido incumple la regla de unicidad `towers_pkey`». Es nuestra clave primaria de la lección 2.1;
- `DETAIL: Key (label)=(N01) already exists.`: el apoyo N01 ya existe;
- `CONTEXT: COPY towers, line 2`: ha tropezado en la segunda línea del archivo, es decir, en el primer apoyo.

Contamos otra vez:

```sql
SELECT count(*) FROM towers;
```

```
 count
-------
    33
(1 row)
```

Siguen siendo 33. El servidor no ha añadido ni una fila de más, ni siquiera las que venían después de N01. El comando `\copy` funciona con la regla de «todo o nada»: si una sola fila no encaja, no se carga ninguna. Así la clave primaria nos ha protegido de los apoyos duplicados.

## Qué ha salido

Comparamos con nuestra hipótesis. En la tabla `towers` hay 33 apoyos, los mismos que en el archivo. La segunda carga no ha estropeado los datos: el servidor se ha negado a hacerla. Estas son las dos comprobaciones que vamos a hacer después de cada carga:

- contar las filas del archivo y de la tabla: los números tienen que coincidir;
- asegurarnos de que la clave primaria no ha dejado pasar repeticiones.

## Si algo falla

- **`data/towers.csv: No such file or directory`.** psql no ha encontrado el archivo. Lo más probable es que no hayamos abierto psql desde la carpeta del libro. Salimos (`\q`), vamos a la carpeta del libro con `cd` y nos conectamos de nuevo. También podemos quedarnos dentro y poner la ruta completa del archivo: `'/Users/.../field-to-code-spatial-sql/data/towers.csv'`.
- **`ERROR: invalid input syntax for type numeric: "x"`** y `CONTEXT: COPY towers, line 1, column x: "x"`. Se nos ha olvidado `HEADER true`, y el servidor ha intentado meter la línea de cabecera como si fuera un apoyo: en la columna numérica `x` ha entrado la palabra «x». Añadimos `HEADER true`. Por cierto, no se ha cargado ni una fila: «todo o nada».
- **`ERROR: duplicate key value violates unique constraint "towers_pkey"`.** Los apoyos ya están cargados. Contamos las filas: si son 33, todo está bien.
- **`ERROR: relation "towers" does not exist`.** La tabla no existe: estamos en otra base de datos o nos hemos saltado la lección 2.1. Miramos el prompt (`spatial_sql=#`) y ejecutamos `\d towers`.

## Tus datos

Nuestro propio CSV lo cargamos igual. Hace falta que:

- las columnas del archivo vayan en el mismo orden que en la tabla;
- los números estén escritos con punto (274101.61), no con coma;
- los «sí/no» estén escritos como `true`/`false`.

Si el archivo tiene una línea de cabecera, añadimos `HEADER true`. Después de cargarlo, comparamos el número de filas del archivo con el de la tabla.

## Tu ordenador

En Windows la carpeta suele ser algo así: `cd C:\Users\<nombre>\Downloads\field-to-code-spatial-sql-main`, y la conexión, `psql -U postgres -d spatial_sql`. En Linux: `sudo -u postgres psql -d spatial_sql`. Pero entonces psql funciona como el usuario `postgres`, y puede que no vea los archivos de nuestra carpeta personal. Lo más sencillo es poner en `\copy` la ruta completa del archivo.

## Resumen

**Conceptos:** archivo CSV, línea de cabecera, carga de «todo o nada», comprobación del número de filas.
**Código:** `\copy towers FROM 'data/towers.csv' WITH (FORMAT csv, HEADER true)`, `SELECT count(*) FROM towers;`.
**Lo esencial:** después de cada carga, contamos las filas. La clave primaria no deja pasar repeticiones, y si hay un error, `\copy` no carga nada.

Los comandos de las lecciones 2.1 y 2.2 están en el archivo `code/ch02_towers.sql`. Se puede ejecutar entero desde la carpeta del libro: `psql -d spatial_sql -f code/ch02_towers.sql`. Funciona en una base de datos vacía, en la que todavía no existe la tabla `towers`.

## Preguntas para un ingeniero

1. *Un compañero ha cargado el archivo, y el servidor ha respondido `COPY 33`. ¿Para qué contar también las filas con `count(*)`?*

   :::{dropdown} Respuesta

   `COPY 33` dice cuántas filas se han añadido ahora. `count(*)` dice cuántas hay en la tabla en total. Si la tabla ya tenía algo, los números no coinciden, y nos daremos cuenta.
   :::

2. *¿Por qué después de la segunda carga fallida no ha aparecido en la tabla ni un apoyo de más, si el error solo estaba en N01?*

   :::{dropdown} Respuesta

   Porque `\copy` funciona con la regla de «todo o nada». Al primer error, el servidor anula toda la carga y la tabla se queda como estaba.
   :::

## Ejercicios

1. **Recordar.** ¿Qué opción de `\copy` le dice al servidor que la primera línea del archivo es la cabecera?

2. **Corregir.** Un compañero quiere contar los apoyos y escribe `SELECT count FROM towers;`. ¿Qué falta?

3. **Recordar lo anterior (lección 1.3).** ¿Cómo nos conectamos a la base `spatial_sql` directamente desde el Terminal, sin pasar por `\c`?

[Respuestas](#es-ch02-l02)

## La pregunta abierta

Ya tenemos 33 apoyos en la base de datos. Ahora podemos hacerles preguntas. ¿Qué apoyos miden más de 35 metros, y cómo le pedimos al servidor que nos enseñe solo esos?

## Fuentes

- PostgreSQL 18 Documentation, COPY — https://www.postgresql.org/docs/18/sql-copy.html
- PostgreSQL 18 Documentation, psql — https://www.postgresql.org/docs/18/app-psql.html
- PostgreSQL 18 Documentation, Aggregate Functions — https://www.postgresql.org/docs/18/functions-aggregate.html
- Datos: `data/towers.csv`, proyecto Pajares; © colaboradores de OpenStreetMap, ODbL 1.0; «PNOA cedido por © IGN».
