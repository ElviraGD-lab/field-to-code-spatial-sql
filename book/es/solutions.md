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

