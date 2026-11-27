---
title: "Lección 3.1. Qué apoyos miden más de 35 metros"
---

(es-ch03-l01-lesson)=
## Dónde lo dejamos

En el capítulo 2 creamos la tabla `towers` y cargamos en ella 33 apoyos. El servidor lo confirmó: 33 filas, sin repeticiones. Hasta ahora solo hemos contado filas. A partir de aquí le vamos a hacer a la tabla preguntas de verdad.

## Qué queremos saber

¿Qué apoyos miden más de 35 metros? ¿Y hay alguno de ellos en una ladera empinada, de más de 20 grados? Un apoyo alto en una ladera empinada es el primer candidato para revisarlo antes del invierno.

Antes de empezar, pensemos. Aquí, un apoyo típico de 400 kV mide unos 30 metros. ¿Cuántos pasarán de 35? Seguramente pocos: unos cuantos. Y altos y además en una ladera empinada, quizá uno o dos. Anotamos nuestra hipótesis.

## Paso 1. Miramos la tabla entera

Nos conectamos a la base de datos desde la carpeta del libro, como en la lección 2.2:

```bash
cd ~/projects/field-to-code-spatial-sql
psql -d spatial_sql
```

Pedimos que nos lo enseñe todo:

```sql
SELECT * FROM towers;
```

- `SELECT`: «muestra»;
- `*`: «todas las columnas»;
- `FROM towers`: «de la tabla de apoyos».

La respuesta (aquí se ven las primeras filas):

```
 label |  lines  |     x     |     y      | ground_z_m | height_m | slope_deg | anchor_candidate
-------+---------+-----------+------------+------------+----------+-----------+------------------
 N01   | N       | 274101.61 | 4766898.64 |    1124.15 |     28.6 |       7.5 | f
 N02   | N       | 274178.44 | 4766662.48 |    1060.78 |     36.1 |      18.0 | f
 N03   | N       | 274313.17 | 4766250.94 |    1067.22 |     29.3 |      25.2 | t
 ...
(33 rows)
```

Los 33 apoyos, con todas sus columnas. Los valores de «sí/no» psql los abrevia: `t` (true) y `f` (false).

Si la tabla no cabe en la pantalla, psql la enseña por páginas y abajo pone dos puntos `:`. Con la barra espaciadora pasamos de página, y con la tecla `q` volvemos al prompt.

## Paso 2. Elegimos solo las columnas que necesitamos

Leerlo todo de golpe es incómodo. Pedimos solo la etiqueta, la línea y la altura:

```sql
SELECT label, lines, height_m FROM towers;
```

En lugar del asterisco, hemos escrito las columnas separadas por comas. La respuesta:

```
 label |  lines  | height_m
-------+---------+----------
 N01   | N       |     28.6
 N02   | N       |     36.1
 N03   | N       |     29.3
 ...
(33 rows)
```

Siguen siendo 33 filas, pero ahora solo hay tres columnas, en el orden en que las hemos escrito.

## Paso 3. Nos quedamos solo con los apoyos altos

Ahora viene lo importante: le pedimos al servidor que no nos enseñe todas las filas, sino solo aquellas en las que la altura pasa de 35 metros.

```sql
SELECT label, height_m FROM towers WHERE height_m > 35;
```

- `WHERE`: «donde»: la condición que tiene que cumplir una fila para entrar en la respuesta;
- `height_m > 35`: «la altura es mayor que 35».

La respuesta:

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

Diez apoyos. Más de los que pensábamos. Casi todos pasan por poco de los 36 metros, y son apoyos de las líneas A, B y C: parece que allí los apoyos son del mismo tipo.

Y hay uno que destaca: **N06, con 78,9 metros**, el doble que los demás. Puede que de verdad sea así, por ejemplo, porque está sobre un valle profundo. O puede que el LiDAR haya captado algo más que había al lado. Lo apuntamos. Volveremos a él cuando aprendamos a ordenar y a encontrar valores atípicos.

No solo podemos comparar con «mayor que»:

| Signo | Significa | Ejemplo |
|---|---|---|
| `=` | igual | `lines = 'S'` |
| `<>` | distinto | `lines <> 'S'` |
| `>` / `<` | mayor / menor | `height_m > 35` |
| `>=` / `<=` | mayor o igual / menor o igual | `slope_deg >= 20` |

## Paso 4. Dos condiciones a la vez: AND

Ahora una pregunta más difícil: los apoyos altos en ladera empinada. Necesitamos que se cumplan las dos condiciones a la vez:

```sql
SELECT label, height_m, slope_deg FROM towers WHERE height_m > 35 AND slope_deg > 20;
```

`AND` significa «y»: entra en la respuesta la fila que cumple **las dos** condiciones. La respuesta:

```
 label | height_m | slope_deg
-------+----------+-----------
(0 rows)
```

Ninguno. Esto también es un resultado, y no coincide con nuestra hipótesis. Los apoyos altos están en terreno poco inclinado: los diez tienen una pendiente de menos de 20 grados. Una respuesta vacía no es un error. El servidor nos dice con honestidad que no hay filas así.

## Paso 5. Al menos una condición: OR

¿Y si antes del invierno queremos revisar los apoyos que **o** son altos **o** están en una ladera empinada?

```sql
SELECT label, height_m, slope_deg FROM towers WHERE height_m > 35 OR slope_deg > 20;
```

`OR` significa «o»: entra en la respuesta la fila que cumple **al menos una** de las condiciones. La respuesta:

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

13 apoyos: los 10 altos y otros 3 en ladera empinada (N03, S04, S05). `AND` estrecha la respuesta, y `OR` la amplía.

## Paso 6. Una condición sobre texto

¿Qué apoyos están en la línea S?

```sql
SELECT label, lines FROM towers WHERE lines = 'S';
```

El texto de una condición lo escribimos entre **comillas simples**: `'S'`. La respuesta:

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

Cinco apoyos. Pero ¿dónde está S01? También está en la línea S, pero en su columna `lines` pone `S,A,B,C`. Y `=` busca una coincidencia exacta, letra por letra, y `'S,A,B,C'` no es igual a `'S'`. Cómo encontrar un texto que simplemente **contiene** la S lo vemos en la lección 3.3.

## Qué ha salido

Comparamos con nuestra hipótesis. Los apoyos de más de 35 metros son 10, no unos pocos. Altos y en ladera empinada no hay ninguno, aunque esperábamos uno o dos. Y entre los altos ha aparecido uno raro, N06, con 78,9 metros. Cada uno de estos resultados ya es algo que sabemos de la línea y que no sabíamos antes de la consulta.

Ahora la consulta se lee como una frase: **muestra** estas columnas **de** esta tabla **donde** se cumple esta condición.

## Si algo falla

- **`ERROR: column "s" does not exist`** después de `WHERE lines = S`. Sin comillas, el servidor piensa que `S` es el nombre de una columna, y esa columna no existe. El texto siempre va entre comillas simples: `'S'`.
- **`ERROR: column "hight_m" does not exist`** con la pista `HINT: Perhaps you meant to reference the column "towers.height_m".` Hay una errata en el nombre de la columna. El servidor nos ha sugerido por su cuenta el nombre correcto.
- **`(0 rows)`.** No es un error: no hay filas así. Revisamos la condición: puede que el signo esté al revés (`<` en lugar de `>`) o que hayamos puesto `AND` donde hacía falta `OR`.
- **Abajo en la pantalla hay dos puntos `:`, las filas se repiten y no se ve el prompt.** psql está enseñando una respuesta larga por páginas. Pulsamos `q` para volver al prompt. Si la paginación nos molesta, la podemos desactivar con `\pset pager off` (pager, «paginador»): así psql saca toda la respuesta de una vez. Para volver a activarla: `\pset pager on`.

## Tus datos

En nuestra propia tabla todo funciona igual: `SELECT` con las columnas que queremos, `FROM` con el nombre de la tabla y `WHERE` con la condición. Los números los escribimos tal cual (`35`), y el texto, entre comillas simples (`'S'`).

## Resumen

**Conceptos:** elegir columnas, condición sobre las filas, comparaciones, «y», «o», respuesta vacía.
**Código:** `SELECT * FROM towers;`, `SELECT label, lines, height_m FROM towers;`, `WHERE height_m > 35`, `AND`, `OR`, `WHERE lines = 'S'`, `\pset pager off`.
**Lo esencial:** `SELECT` elige las columnas, y `WHERE` elige las filas. `AND` estrecha la respuesta, y `OR` la amplía.

Las consultas de esta lección están en el archivo `code/ch03_queries.sql`.

## Preguntas para un ingeniero

1. *La consulta con `AND` ha devuelto 0 filas. ¿Quiere decir que nos hemos equivocado?*

   :::{dropdown} Respuesta

   No necesariamente. Una respuesta vacía también es un resultado: no hay filas que cumplan las dos condiciones. Solo tenemos que comprobar que la condición está escrita como queríamos.
   :::

2. *¿Por qué S01 no ha salido en la respuesta a `WHERE lines = 'S'`, si está en la línea S?*

   :::{dropdown} Respuesta

   Porque `=` busca una coincidencia exacta. En la columna de S01 pone `S,A,B,C`, y eso no es lo mismo que `S`.
   :::

## Ejercicios

1. **Recordar.** ¿Qué palabra de la consulta deja solo las filas que cumplen una condición?

2. **Corregir.** Un compañero busca los apoyos de la línea N y escribe `SELECT label FROM towers WHERE lines = N;`. El servidor le ha respondido con un error. ¿Qué hay que corregir?

3. **Recordar lo anterior (lección 2.2).** ¿Con qué consulta comprobamos que la tabla tenía 33 apoyos?

[Respuestas](#es-ch03-l01)

## La pregunta abierta

Hemos encontrado los apoyos altos y los que están en laderas empinadas. Pero la altura del apoyo nos la ha dado el LiDAR, y la cota del terreno, el modelo del relieve. ¿A qué altura sobre el nivel del mar está la parte de arriba de cada apoyo? ¿Podemos pedirle al servidor que lo calcule directamente en la consulta?

## Fuentes

- PostgreSQL 18 Documentation, SELECT — https://www.postgresql.org/docs/18/sql-select.html (consultado el 27.11.2026)
- PostgreSQL 18 Documentation, Comparison Functions and Operators — https://www.postgresql.org/docs/18/functions-comparison.html (consultado el 27.11.2026)
- PostgreSQL 18 Documentation, Logical Operators — https://www.postgresql.org/docs/18/functions-logical.html (consultado el 27.11.2026)
- Datos: `data/towers.csv`, proyecto Pajares; © colaboradores de OpenStreetMap, ODbL 1.0; «PNOA cedido por © IGN».
