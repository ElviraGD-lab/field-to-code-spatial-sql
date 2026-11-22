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

