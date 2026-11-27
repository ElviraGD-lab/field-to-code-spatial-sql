---
title: "Respuestas a los ejercicios"
---

(es-ch01-l01)=
## Lección 1.1. Cómo funciona PostgreSQL

1. **Recordar.** Ordenamos los cinco niveles de mayor a menor: tabla, servidor, fila, base de datos, esquema.

   **Respuesta:** servidor → base de datos → esquema → tabla → fila.

2. **Completar.** Para cada comando, escribimos si solo pregunta o si cambia algo. Y si cambia algo, ¿qué cambia: la estructura, las filas o los permisos? `CREATE TABLE`, `SELECT`, `DELETE`, `GRANT`.

   **Respuesta:** `CREATE TABLE` cambia la estructura (crea una tabla); `SELECT` solo pregunta; `DELETE` cambia las filas (las borra); `GRANT` cambia los permisos.

3. **Relación con el proyecto.** Es la primera lección y todavía no hay lecciones anteriores sobre las que preguntar, así que la pregunta es sobre Pajares. Los vanos de la línea también los vamos a meter en la base de datos. ¿Cuál será la dirección completa de la futura tabla de vanos `spans` si está en el mismo esquema que los apoyos?

   **Respuesta:** `public.spans`, en la base `spatial_sql`.

[Volver a la lección](#es-ch01-l01-lesson)

(es-ch01-l02)=
## Lección 1.2. Instalamos PostgreSQL en el ordenador

1. **Recordar.** ¿Con qué comando nos muestra psql a qué base de datos, con qué usuario y por qué puerto estamos conectados?

   **Respuesta:** `\conninfo`.

2. **Corregir.** Hemos escrito `SELECT version()` y hemos pulsado Enter. El servidor no dice nada y el prompt ha pasado a `admin-#`. ¿Qué tenemos que escribir?

   **Respuesta:** `;` y Enter: una pregunta en SQL termina con punto y coma.

3. **Recordar lo anterior (lección 1.1).** ¿Qué número tiene la «puerta» por la que los clientes llaman al servidor PostgreSQL y cómo se llama esa puerta?

   **Respuesta:** puerto 5432.

[Volver a la lección](#es-ch01-l02-lesson)

(es-ch01-l03)=
## Lección 1.3. Nuestra primera base de datos

1. **Recordar.** ¿Con qué comando nos muestra psql la lista de todas las bases de datos del servidor?

   **Respuesta:** `\l`.

2. **Corregir.** Un compañero ha escrito `CREATE DATABASE Pajares Risk;` y le ha dado error. ¿Cómo se escribe bien el comando, según nuestra regla de los nombres?

   **Respuesta:** `CREATE DATABASE pajares_risk;`: en minúsculas y con guion bajo en lugar del espacio.

3. **Recordar lo anterior (lección 1.2).** ¿Con qué comando nos muestra psql a qué base de datos, con qué usuario y por qué puerto estamos conectados?

   **Respuesta:** `\conninfo`.

[Volver a la lección](#es-ch01-l03-lesson)

(es-ch02-l01)=
## Lección 2.1. Describimos un apoyo: la primera tabla

1. **Recordar.** ¿Qué tipo elegimos para la columna que guarda una respuesta de «sí o no»?

   **Respuesta:** `boolean`.

2. **Corregir.** Un compañero ha descrito la tabla de vanos así: `CREATE TABLE spans (span_label text PRIMARY KEY, length_m text);`. La longitud de los vanos la vamos a sumar y comparar. ¿Qué hay que corregir?

   **Respuesta:** el tipo de la longitud: `length_m numeric`.

3. **Recordar lo anterior (lección 1.1).** ¿Cómo se escribe la dirección completa de nuestra tabla de apoyos, la que nos ha mostrado `\d`?

   **Respuesta:** `public.towers`.

[Volver a la lección](#es-ch02-l01-lesson)

(es-ch02-l02)=
## Lección 2.2. Cargamos los apoyos y los contamos

1. **Recordar.** ¿Qué opción de `\copy` le dice al servidor que la primera línea del archivo es la cabecera?

   **Respuesta:** `HEADER true`.

2. **Corregir.** Un compañero quiere contar los apoyos y escribe `SELECT count FROM towers;`. ¿Qué falta?

   **Respuesta:** los paréntesis con el asterisco: `SELECT count(*) FROM towers;`.

3. **Recordar lo anterior (lección 1.3).** ¿Cómo nos conectamos a la base `spatial_sql` directamente desde el Terminal, sin pasar por `\c`?

   **Respuesta:** `psql -d spatial_sql`.

[Volver a la lección](#es-ch02-l02-lesson)

(es-ch03-l01)=
## Lección 3.1. Qué apoyos miden más de 35 metros

1. **Recordar.** ¿Qué palabra de la consulta deja solo las filas que cumplen una condición?

   **Respuesta:** `WHERE`.

2. **Corregir.** Un compañero busca los apoyos de la línea N y escribe `SELECT label FROM towers WHERE lines = N;`. El servidor le ha respondido con un error. ¿Qué hay que corregir?

   **Respuesta:** poner el texto entre comillas simples: `WHERE lines = 'N'`.

3. **Recordar lo anterior (lección 2.2).** ¿Con qué consulta comprobamos que la tabla tenía 33 apoyos?

   **Respuesta:** `SELECT count(*) FROM towers;`.

[Volver a la lección](#es-ch03-l01-lesson)

