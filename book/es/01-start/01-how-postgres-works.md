---
title: "Lección 1.1. Cómo funciona PostgreSQL"
---

(es-ch01-l01-lesson)=
## Dónde lo dejamos

Es la primera lección, así que empezamos de cero. Tenemos el proyecto Pajares y, dentro, una tabla con los apoyos de la línea de 400 kV: 33 filas. Cada apoyo tiene una etiqueta (N01, N02…), una línea (N, A, B, C) y una altura según el nDSM. Ahora mismo esa tabla está en un archivo CSV. Queremos aprender a guardar estos datos en una base de datos y a hacerles preguntas.

## Qué queremos saber

De qué partes se compone PostgreSQL y en qué lugar de su interior va a vivir nuestra tabla de apoyos.

Antes de seguir, pensemos un minuto: ¿en qué se diferencia una «base de datos» de una carpeta llena de archivos CSV? Anotamos una frase y al final de la lección la comparamos.

## Paso 1. El servidor: un programa que está siempre funcionando

Un archivo CSV está en el disco y no hace nada por sí solo. Lo abre un programa (Excel, QGIS), lo lee entero y lo cierra.

PostgreSQL funciona de otra manera. Es un programa **servidor**: se arranca una vez y a partir de ahí sigue funcionando en segundo plano. Es él quien guarda los datos, los vigila y responde a las preguntas. Nosotros no tocamos directamente sus archivos.

El servidor escucha en una «puerta» con número. Esa puerta se llama **puerto**, y en PostgreSQL suele ser el **5432**. Quien quiere preguntar algo llama a esa puerta.

## Paso 2. El cliente: el que hace las preguntas

El programa que llama al servidor se llama **cliente**. En el libro vamos a usar varios:

- **psql**: el cliente de texto que usamos en el Terminal. Es con el que más vamos a trabajar;
- **QGIS**: nos enseña en el mapa las tablas de la base de datos;
- **Python**: más adelante, en la parte IV.

Todos los clientes hablan con el servidor en el mismo idioma: **SQL**.

Veamos el esquema de la conversación. Siempre es el mismo:

```
cliente (psql)  ──  pregunta en SQL  ──►  servidor PostgreSQL (puerto 5432)
cliente (psql)  ◄──  respuesta: tabla  ──  servidor PostgreSQL
```

De este esquema sale la idea principal de la lección: no abrimos el archivo con los datos, sino que le **preguntamos** al servidor. Por eso QGIS, psql y un script pueden ver los mismos apoyos a la vez, y todos ven exactamente lo mismo.

## Paso 3. Cinco niveles: del servidor a la celda

Dentro del servidor todo va encajado, como en una matrioska. Repartimos nuestros apoyos por niveles:

```
servidor PostgreSQL        (un programa en el ordenador)
└── base spatial_sql       (una base por libro o proyecto)
    └── esquema public     (carpeta dentro de la base)
        └── tabla towers   (apoyos)
            ├── fila: N01 | N | 28.6
            ├── fila: N02 | N | 36.1
            └── ... 33 filas en total
```

Recorremos los niveles de arriba abajo:

1. **Servidor.** Un solo programa. En un servidor pueden vivir muchas bases de datos.
2. **Base de datos** (database). Un mundo aparte: las tablas de una base no ven las tablas de otra. Para el libro vamos a crear la base `spatial_sql`.
3. **Esquema** (schema). Una carpeta dentro de la base de datos. Toda base nueva trae ya el esquema `public`, y de momento trabajamos solo en él. En la parte III crearemos nuestros propios esquemas, por ejemplo uno para los temporales.
4. **Tabla** (table). Un conjunto de filas del mismo tipo: los apoyos por un lado, los vanos por otro.
5. **Fila y columna.** Una fila es un apoyo. Una columna es una característica de todos los apoyos, por ejemplo la altura. Cada columna tiene un **tipo**, y el servidor no nos deja meter la palabra «alto» en la columna de la altura. Aquí tenemos la primera diferencia con un CSV: en un CSV se puede escribir cualquier cosa.

La dirección completa de una tabla se escribe con un punto: `public.towers`. Se parece a la ruta de un archivo: primero la carpeta y luego el nombre.

## Paso 4. Cómo son una pregunta y su respuesta

Los programas los instalamos en la lección 1.2. Ahora solo vamos a ver cómo será la conversación en psql. No hace falta memorizar nada: lo vamos a escribir muchas veces.

```sql
SELECT label, height_ndsm_m
FROM towers
WHERE height_ndsm_m > 35;
```

Lo leemos línea a línea:

- `SELECT label, height_ndsm_m`: «muéstrame las columnas etiqueta y altura»;
- `FROM towers`: «de la tabla de apoyos»;
- `WHERE height_ndsm_m > 35;`: «solo las filas en las que la altura pasa de 35 metros». El punto y coma significa «pregunta terminada».

La respuesta del servidor será más o menos así (los números son reales, de nuestros datos):

```
 label | height_ndsm_m
-------+---------------
 N02   |          36.1
 N06   |          78.9
 A02   |          36.1
 ...
(10 rows)
```

El servidor nos ha devuelto una tabla de 10 filas, y nadie ha abierto ningún archivo.

## Paso 5. Qué hace cada comando con los datos

Es práctico agrupar los comandos SQL según lo que hacen. Estos grupos tienen nombres en siglas, que veremos en la documentación. No hace falta aprenderse las siglas. Lo importante es entender la idea: si el comando solo pregunta o si cambia algo.

| Qué hace el comando | Ejemplo | Nombre del grupo | Dónde aparece en el libro |
|---|---|---|---|
| crea y cambia la estructura: bases de datos, tablas, columnas | `CREATE TABLE` | DDL (Data Definition Language, lenguaje de definición de datos) | capítulo 2 |
| añade, cambia y borra filas | `INSERT`, `UPDATE`, `DELETE` | DML (Data Manipulation Language, lenguaje de manipulación de datos) | capítulos 2–5 |
| hace preguntas sin cambiar nada | `SELECT` | DQL (Data Query Language, lenguaje de consulta de datos) | capítulos 3–7 y siguientes |
| decide quién puede hacer qué | `GRANT` | DCL (Data Control Language, lenguaje de control de datos) | capítulo 21 |

Vamos a coger una costumbre: antes de ejecutar un comando, nos preguntamos si cambia algo. `SELECT` es seguro, porque solo mira. `DELETE` cambia los datos, así que con él vamos con más cuidado.

## Paso 6. Dónde entra PostGIS

PostGIS es una **extensión** (extension): un complemento que enseña al servidor a entender la geometría. Sin PostGIS, una columna guarda números y texto. Con PostGIS, también puede guardar el punto de un apoyo o la línea de un vano. Así podemos preguntar en SQL, por ejemplo, «qué vanos están a menos de 50 m del bosque».

PostGIS no es un programa aparte ni un servidor aparte. Lo activamos dentro de nuestra base de datos con un solo comando (`CREATE EXTENSION postgis`) en la parte II.

## Qué ha salido

Repasamos lo que hemos aprendido:

- los datos viven dentro del **servidor**, y las preguntas las hacemos a través de un **cliente**;
- el orden de los niveles es este: servidor → base de datos → esquema → tabla → fila y columna;
- nuestra futura tabla es `public.towers`, en la base `spatial_sql`.

Ahora comparamos con la frase que anotamos al principio. La diferencia principal con una carpeta de archivos CSV es esta: una base de datos es un programa en marcha que guarda los datos por sí mismo, comprueba los tipos y responde a muchos clientes a la vez.

## Si algo no queda claro

- *«¿El servidor es otro ordenador?»* No, es un programa. Puede funcionar en nuestro propio ordenador, y en el libro lo haremos así. En una empresa el servidor suele estar en una máquina aparte, pero funciona igual.
- *«¿Esquema y base de datos son lo mismo?»* No. Un esquema es una carpeta *dentro* de una base de datos. Desde una base podemos leer tablas de distintos esquemas, pero no podemos leer así las tablas de otra base.

## Tu ordenador

De momento no hace falta instalar nada. En la lección 1.2 instalamos PostgreSQL junto con PostGIS en el ordenador (Mac, Windows o Linux) y nos conectamos a él con psql.

## Resumen

**Conceptos:** servidor, cliente, puerto 5432, base de datos, esquema `public`, tabla, fila, columna, tipo de columna, extensión PostGIS; comandos que preguntan y comandos que cambian.
**Código:** de momento, solo el ejemplo `SELECT … FROM … WHERE …;`.
**Lo esencial:** no abrimos los datos, le preguntamos al servidor.

## Preguntas para un ingeniero

1. *Un compañero ha abierto la tabla de apoyos en QGIS, y nosotros la estamos mirando en psql al mismo tiempo. ¿Estamos viendo copias distintas?*

   :::{dropdown} Respuesta

   No. Los dos clientes preguntan al mismo servidor, así que ven las mismas filas.
   :::

2. *¿Por qué el servidor no nos deja escribir «alto» en la columna de la altura?*

   :::{dropdown} Respuesta

   Porque la columna tiene un tipo (número), y el servidor comprueba cada valor. Así los datos quedan protegidos de errores que en un CSV pasan sin que nadie se dé cuenta.
   :::

## Ejercicios

1. **Recordar.** Ordenamos los cinco niveles de mayor a menor: tabla, servidor, fila, base de datos, esquema.

2. **Completar.** Para cada comando, escribimos si solo pregunta o si cambia algo. Y si cambia algo, ¿qué cambia: la estructura, las filas o los permisos? `CREATE TABLE`, `SELECT`, `DELETE`, `GRANT`.

3. **Relación con el proyecto.** Es la primera lección y todavía no hay lecciones anteriores sobre las que preguntar, así que la pregunta es sobre Pajares. Los vanos de la línea también los vamos a meter en la base de datos. ¿Cuál será la dirección completa de la futura tabla de vanos `spans` si está en el mismo esquema que los apoyos?

[Respuestas](#es-ch01-l01)

## Pregunta abierta

Si lleváramos el proyecto Pajares junto con un compañero de una empresa eléctrica, ¿qué dejaríamos en una misma base de datos y qué repartiríamos en esquemas distintos?

## Fuentes

- PostgreSQL 18 Documentation, Chapter 1 «Getting Started», 1.2 «Architectural Fundamentals» — https://www.postgresql.org/docs/18/tutorial-arch.html
- PostGIS 3.6 Manual — https://postgis.net/docs/
