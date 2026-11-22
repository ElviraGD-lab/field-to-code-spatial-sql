---
title: "Prólogo. Una pregunta y muchos archivos"
---

## Octubre de 2018 en el puerto de Pajares

A finales de octubre de 2018 el invierno llegó pronto a Pajares. Nevó con fuerza cuando los árboles todavía tenían las hojas. La nieve se acumulaba en las copas, y los árboles se partían y caían sobre las líneas. También cortaron las carreteras, y a las brigadas les costaba incluso llegar al lugar de la avería [1, 2]. Al tercer día, Viesgo todavía tenía 679 clientes sin luz [1].

En la montaña, un árbol caído hace dos cosas a la vez: rompe el conductor y corta el camino para llegar hasta él.

## La pregunta del ingeniero

Pongamos que somos los responsables de revisar las líneas de alta tensión del puerto. Por aquí pasan cinco líneas de 400 kV: 33 apoyos y 34 vanos, unos 9,5 km en total. Antes del invierno no hay tiempo ni gente para todo. Tenemos que decidir qué vanos revisamos primero.

La norma de líneas aéreas, la ITC-LAT 07, en su apartado 5.12.1, exige talar los árboles que al caer puedan alcanzar los conductores [3]. Es decir, la norma plantea una pregunta de **distancia**: lo cerca que está el árbol del conductor y la altura que tiene.

Pero para responder con honestidad, la distancia sola no basta. También necesitamos saber:

- qué bosque hay a lo largo del vano y qué altura tiene;
- qué pendiente tiene la ladera que hay debajo;
- si ese bosque ha ardido en los últimos años: los árboles quemados se parten y caen con el primer viento fuerte [4];
- si hay cerca una carretera por la que la brigada pueda llegar al apoyo;
- en qué municipio está el vano y qué ha pasado allí con los cortes de suministro.

## Dónde están las respuestas

Todos estos datos existen y todos son abiertos. Pero cada conjunto vive en su propio archivo, con su propio formato y, a menudo, en su propio sistema de coordenadas:

- los apoyos y los vanos, en tablas CSV y en archivos GeoPackage;
- los usos del suelo y el bosque, en una capa aparte;
- el relieve, en un ráster de 2 metros de resolución;
- los 78 municipios de Asturias y los 14 847 tramos de carretera, de OpenStreetMap;
- los incendios detectados por satélite: 13 388 puntos de 2012–2025 del archivo de NASA FIRMS [5];
- los indicadores de cortes de suministro, en tablas Excel.

Mientras hay dos archivos, podemos abrirlos en QGIS y mirarlos. Cuando hay diez, empiezan los problemas. Cada vez lo abrimos todo de nuevo y repetimos los mismos pasos a mano. Al mes llegan datos nuevos y hay que recalcularlo todo. Un compañero trabaja con su propia copia del archivo, y nos salen números distintos. Y para comprobar el resultado de otra persona, hay que reconstruir de memoria qué se hizo exactamente.

## Los datos también engañan

Hay un segundo problema. En el archivo original de FIRMS hay más de 31 000 puntos en Asturias para esos mismos años. Más de la mitad los marca el propio archivo como fuentes de calor persistentes: son las fábricas de la costa industrial, que están calientes todos los días [5]. En nuestro archivo esos puntos ya están quitados, y por eso quedan 13 388. Si no los quitáramos, el lugar con más «riesgo de incendio» de Asturias sería una planta siderúrgica.

Así que, antes de responder a la pregunta, hay que comprobar los datos. Y hacerlo de forma que la comprobación se pueda repetir.

## Qué nos da una base de datos

Una base de datos resuelve los dos problemas a la vez:

- **todos los datos en un solo sitio.** Apoyos, bosque, relieve, carreteras e incendios están juntos, en el mismo sistema de coordenadas, y todos los ven: psql, QGIS, Python y el compañero;
- **el servidor mantiene el orden.** No nos deja escribir texto en la columna de la altura ni perder la relación entre un vano y sus apoyos;
- **la pregunta queda escrita.** Una consulta SQL es, en sí misma, la descripción de lo que hemos hecho. Podemos releerla, pasársela a un compañero y volver a ejecutarla con datos nuevos;
- **la geometría, dentro del SQL.** Con la extensión PostGIS, la pregunta «qué árboles están más cerca del conductor que su propia altura» se convierte en una sola consulta.

## Cómo vamos a avanzar

Primero instalamos PostgreSQL y aprendemos a hacer preguntas a tablas normales: apoyos y vanos. Después añadimos la geometría y, paso a paso, reunimos para cada vano el bosque, la pendiente, los incendios y las carreteras. Luego organizamos la base de datos del catálogo de temporales tal como se hace en los proyectos reales. Y al final vemos que las mismas consultas funcionan en DuckDB, QGIS y Python.

## Nuestra pregunta

**¿Qué vanos de las líneas del puerto de Pajares están más amenazados por el bosque y los incendios, y cómo nos ayuda una base de datos a encontrarlos y a comprobarlo?**

Vamos a responder paso a paso, uno por lección. Y empezamos por el principio: cómo funciona PostgreSQL.

## Preguntas de repaso

1. **¿Qué pregunta plantea la norma ITC-LAT 07 y por qué es una pregunta de distancia?**

   :::{dropdown} Respuesta
   Si un árbol, al caer, puede alcanzar el conductor. Para responder hay que saber a qué distancia del conductor está el árbol y qué altura tiene.
   :::

2. **¿Por qué diez archivos son incómodos, aunque cada uno sea bueno?**

   :::{dropdown} Respuesta
   Cada vez hay que abrirlo todo y repetir los pasos a mano, las copias de los compañeros dejan de coincidir y es difícil comprobar un resultado, porque los pasos no están escritos en ningún sitio.
   :::

3. **¿Qué pasa si usamos todos los puntos de FIRMS sin comprobarlos?**

   :::{dropdown} Respuesta
   Las fuentes de calor persistentes, es decir, las fábricas, parecen incendios, y el lugar con más riesgo de incendio resulta ser una fábrica.
   :::

## Fuentes

1. OKDiario, 30.10.2018. https://okdiario.com/espana/temporal-deja-sin-luz-tres-dias-mas-4-500-personas-asturias-3291859
2. La Voz del Trubia, 29.10.2018. https://lavozdeltrubia.es/2018/10/29/somiedo-teverga-y-parte-de-quiros-siguen-sin-luz-por-el-temporal/
3. ITC-LAT 07 (RD 223/2008), apartado 5.12.1. https://normatia.com/es/normativa/reglamento-lineas-alta-tension/2025/instruccion-tecnica-complementaria-itc-lat-07-lineas-aereas-con-conductores/
4. BPA, How wildfires can contribute to power outages. https://www.bpa.gov/learn-and-participate/community-education/wildfires-and-public-safety
5. NASA FIRMS, archivo VIIRS S-NPP 375 m, Asturias, 2012–2025; campo TYPE = 2 (fuente de calor persistente). https://firms.modaps.eosdis.nasa.gov/download/
