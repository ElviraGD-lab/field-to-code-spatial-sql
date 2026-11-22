---
title: "Cómo trabajar con el libro"
---

## Para quién es este libro

Para ingenieros y técnicos que han trabajado en campo y quieren trabajar con datos espaciales como se hace hoy en las empresas. Para topógrafos, forestales, profesionales del sector eléctrico y especialistas en SIG: gente que conoce bien su campo pero nunca ha trabajado con bases de datos.

No hace falta saber nada de antemano. Empezamos por cómo funciona PostgreSQL y cómo instalarlo en nuestro ordenador. Cada comando lo explicamos entero, y cuando vuelve a aparecer, lo explicamos otra vez.

## Qué aprendemos

El libro tiene cuatro partes. Cada parte trabaja con sus propios datos, y los datos nuevos solo aparecen al principio de una parte nueva.

1. **Parte I. Fundamentos de SQL.** Tablas de apoyos y vanos de las líneas de 400 kV del puerto de Pajares. Instalamos PostgreSQL, creamos la primera base de datos y las primeras tablas, y cargamos los datos. Aprendemos a hacer preguntas: seleccionar filas, contar, agrupar, unir tablas y dividir una pregunta complicada en pasos sencillos.
2. **Parte II. PostGIS.** A esos mismos apoyos les añadimos geometría y, a su alrededor, el bosque, el relieve, las carreteras, los municipios y los incendios de Asturias. Aprendemos a trabajar con sistemas de coordenadas, distancias, intersecciones, buffers, rásteres y validación de geometrías. Al final de la parte montamos una tabla de riesgo para cada vano.
3. **Parte III. Catálogo de temporales.** Cómo organizar la base de datos de un proyecto real: cargar los datos con un único proceso que se puede repetir, esquemas, permisos de usuario y copia de seguridad.
4. **Parte IV. Las mismas consultas en otras herramientas.** DuckDB, QGIS y Python. Así vemos que el SQL, una vez aprendido, funciona en todas partes.

Después de las partes I y II nos esperan dos **pruebas** con datos que no conocemos: «Servicio de Extinción de Incendios de Asturias» e «Incendios de Asturias 2012–2025». En ellas resolvemos las tareas por nuestra cuenta, sin pistas, con datos que no han salido en las lecciones.

Lo que no está en el libro: el cálculo de rutas (pgRouting), la topología, la publicación de mapas con GeoServer y los programas comerciales como FME. Eso es el paso siguiente, cuando ya tenemos los fundamentos.

## Con qué herramientas

Solo con las que se usan hoy:

- PostgreSQL 18: el servidor de base de datos;
- PostGIS 3.6: la extensión para geometrías y rásteres;
- psql: el cliente de texto que usamos en el Terminal;
- VS Code: el editor para los archivos de consultas, con el Terminal integrado;
- QGIS: para ver en el mapa las tablas de la base de datos;
- ogr2ogr, de GDAL: para cargar capas ya hechas;
- más adelante, DuckDB y Python.

Todos los programas son gratuitos y funcionan en Mac, Windows y Linux. Los datos son abiertos.

## Cómo es cada lección

Cada lección responde a una pregunta de ingeniero e introduce una o dos cosas nuevas. Si hay más, la lección se divide en dos. Todas las lecciones siguen el mismo esquema, así que a las pocas lecciones ya sabemos dónde buscar cada cosa:

1. **Dónde lo dejamos**: lo que ya sabemos hacer y los datos que tenemos.
2. **Qué queremos saber**: la pregunta de la lección. Aquí anotamos nuestra hipótesis antes de calcular nada.
3. **Pasos.** Cada paso va en el mismo orden: qué hacemos → código → qué responde el servidor → explicación del código línea a línea.
4. **Qué ha salido**: la respuesta a la pregunta de la lección y la comparación con nuestra hipótesis.
5. **Si algo falla**: los errores más habituales y qué hacer con ellos.
6. **Tus datos**: qué cambiar para hacer lo mismo con nuestros propios datos. **Tu ordenador**: qué se hace de forma distinta en Mac, Windows y Linux.
7. **Resumen**: los conceptos nuevos, el código nuevo y la idea principal de la lección.
8. **Preguntas para un ingeniero**: dos o tres preguntas, con la respuesta justo debajo de cada una.
9. **Ejercicios**: exactamente tres.
10. **Pregunta abierta**: merece la pena pensar en ella, pero no tiene una respuesta correcta.
11. **Fuentes.**

## Cómo hacemos cada lección

- **Una lección cada vez.** Cada lección está pensada para una hora, más o menos. Mejor una lección al día que cinco el fin de semana.
- **El código lo tecleamos nosotros.** Se puede copiar, pero el código escrito a mano se recuerda mucho mejor. Ejecutamos cada comando en cuanto llegamos a él y comparamos la respuesta del servidor con la del libro.
- **Equivocarse es normal.** El servidor casi siempre explica qué no le ha gustado. Leemos el mensaje con calma, miramos la sección «Si algo falla» y volvemos a intentarlo. Cada error de estos enseña más que un comando que sale bien a la primera.
- **No memorizamos nombres.** Lo importante es entender qué hace cada comando. El nombre se nos quedará solo cuando lo hayamos escrito diez veces.

## Ejercicios

Después de cada lección hay tres ejercicios cortos, siempre en el mismo orden:

1. **Recordar**: lo esencial de esta lección.
2. **Completar o corregir**: un trocito de código o una frase.
3. **Recordar lo anterior**: una pregunta sobre la lección de hace una, tres o siete lecciones. Así no se nos olvida lo aprendido.

Los resolvemos por nuestra cuenta y solo después miramos las soluciones. Están todas juntas en una página aparte.

## Código y datos

El código de cada capítulo está en la carpeta `code` del repositorio, un archivo por capítulo. Los datos, con la descripción de su procedencia, están en la carpeta `data`. El texto del libro se distribuye con licencia CC BY 4.0, y el código, con licencia Apache 2.0.

Este es el cuarto libro de la serie From Field to Code. Se puede leer por separado: todo lo necesario para SQL se explica aquí mismo. Python solo aparece en la parte IV, y se explica desde cero en el primer libro de la serie, *PyQGIS from Scratch*.
