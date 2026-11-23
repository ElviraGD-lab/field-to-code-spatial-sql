---
title: "Lección 1.2. Instalamos PostgreSQL en el ordenador"
---

(es-ch01-l02-lesson)=
## Dónde lo dejamos

En la lección 1.1 vimos que PostgreSQL es un servidor: un programa que está siempre funcionando en segundo plano y responde a preguntas. Las preguntas las hacen los clientes, y nuestro cliente principal es psql. Hasta ahora todo esto estaba solo en un esquema. Ahora instalamos el servidor en el ordenador y le hacemos la primera pregunta de verdad.

## Qué queremos saber

Cómo instalar el servidor PostgreSQL junto con PostGIS y comprobar que nos oye.

Antes de empezar, pensemos: ¿cómo sabremos que todo ha salido bien? Anotamos nuestra hipótesis sobre lo que deberíamos ver. Al final lo comparamos.

## Paso 1. Instalamos el servidor

Es el único punto de la lección en el que los pasos cambian según el sistema. A partir de aquí, todo es igual.

**Mac.** Instalamos Postgres.app. Es el servidor PostgreSQL en forma de programa normal, y ya trae PostGIS.

1. Descargamos de postgresapp.com/downloads el archivo «Postgres.app with PostgreSQL 18».
2. Movemos Postgres.app a la carpeta Applications y lo abrimos con un doble clic.
3. En la ventana del programa pulsamos **Initialize**. Postgres.app crea un servidor PostgreSQL 18 y lo arranca.

**Windows.** Instalamos el instalador de EDB y añadimos PostGIS aparte.

1. En postgresql.org/download/windows abrimos «Download the installer» y descargamos PostgreSQL 18.
2. Ejecutamos la instalación. En la lista de componentes dejamos marcados PostgreSQL Server, Command Line Tools y Stack Builder.
3. El programa nos pide una contraseña para el usuario `postgres`. La apuntamos: la vamos a necesitar cada vez que nos conectemos. El puerto lo dejamos en 5432.
4. Al final de la instalación se abre Stack Builder. Ahí elegimos nuestro servidor PostgreSQL 18, luego Spatial Extensions → PostGIS 3.6 Bundle for PostgreSQL 18, y lo instalamos.

**Linux (Ubuntu, Debian).** Añadimos el repositorio oficial de PostgreSQL e instalamos el servidor junto con PostGIS:

```bash
sudo apt install -y postgresql-common
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
sudo apt update
sudo apt install postgresql-18 postgresql-18-postgis-3
```

Línea a línea:

- `sudo` (superuser do, «ejecutar como administrador»): el sistema nos pide la contraseña del ordenador;
- `apt install`: «instala el programa»; `-y`: «sí a todo»;
- la segunda línea ejecuta un script ya preparado que añade el repositorio oficial de PostgreSQL. Así nos aseguramos de tener la versión 18;
- `apt update`: «actualiza la lista de programas»;
- la última línea instala el servidor (`postgresql-18`) y su PostGIS (`postgresql-18-postgis-3`).

En Linux el servidor arranca solo nada más instalarlo.

## Paso 2. Comprobamos que el servidor funciona

El servidor trabaja en segundo plano, así que es importante saber comprobar que está en marcha.

En Mac lo vemos en la ventana de Postgres.app. Junto al servidor PostgreSQL 18 pone **Running**, y debajo aparecen sus bases de datos: `postgres`, `template1` y una base con nuestro nombre de usuario. El puerto es el 5432, la misma «puerta» de la lección 1.1.

En Windows el servidor se instala como servicio y arranca junto con el ordenador. En Linux también arranca solo.

O sea, el servidor está ahí y escucha en su puerta. Ahora nos hace falta un cliente.

## Paso 3. Enseñamos al Terminal a encontrar psql (solo en Mac)

psql ya está dentro de Postgres.app. Pero el Terminal todavía no sabe dónde buscarlo. Se lo indicamos con un solo comando:

```bash
sudo mkdir -p /etc/paths.d && echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp
```

Por partes:

- `sudo mkdir -p /etc/paths.d`: crea (make directory) la carpeta del sistema `/etc/paths.d` si todavía no existe. `-p` significa «no protestes si la carpeta ya existe»;
- `&&`: «si la primera parte ha salido sin errores, ejecuta la segunda»;
- `echo /Applications/.../bin`: escribe la ruta de la carpeta donde están psql y los demás comandos de PostgreSQL;
- `|`: pasa lo que se ha escrito al comando siguiente;
- `sudo tee /etc/paths.d/postgresapp`: guarda esa ruta en el archivo `postgresapp`. De esta carpeta saca el Terminal dónde tiene que buscar los comandos.

El Terminal solo lee estos archivos al arrancar. Por eso cerramos todas las ventanas del Terminal y abrimos una nueva.

En Windows podemos abrir un cliente que ya viene preparado: en el menú Inicio está **SQL Shell (psql)**. En Linux, psql se instala junto con el servidor.

## Paso 4. Abrimos el Terminal en VS Code

Vamos a trabajar en VS Code: en una parte de la ventana escribimos las consultas y en otra tenemos el Terminal, donde las ejecutamos. Abrimos VS Code y en el menú elegimos **Terminal → New Terminal**. En la parte de abajo de la ventana aparece el Terminal.

Comprobamos que el Terminal encuentra psql:

```bash
psql --version
```

Respuesta:

```
psql (PostgreSQL) 18.6 (Postgres.app)
```

`--version` significa «muestra la versión». La respuesta nos dice dos cosas: el cliente psql está localizado, y es la versión 18. En Windows y Linux, entre paréntesis aparecerá otro nombre de compilación, pero el número 18 será el mismo.

## Paso 5. Nos conectamos al servidor

Ahora el cliente llama a la puerta del servidor:

```bash
psql
```

En Mac, la primera vez que nos conectamos, Postgres.app puede preguntarnos si dejamos que VS Code se conecte al servidor. Pulsamos **OK**: así el servidor recuerda que puede fiarse de este cliente.

El prompt del Terminal cambia:

```
psql (18.6 (Postgres.app))
Type "help" for help.

admin=#
```

Veamos qué tenemos aquí:

- `admin` es la base de datos a la que nos hemos conectado. Si no le decimos a psql a qué base ir, va a la que tiene nuestro nombre de usuario. En Mac la ha creado Postgres.app. En nuestro ordenador el usuario se llama `admin`; en otro ordenador aquí saldrá otro nombre;
- `=#` significa que psql está esperando un comando. El signo `#` indica que hemos entrado como el usuario principal del servidor, el que puede hacerlo todo.

En Windows nos conectamos así: `psql -U postgres`. Aquí `-U` (user) significa «entra como el usuario `postgres`», y psql nos pide la contraseña del paso 1. El prompt será `postgres=#`. En Linux: `sudo -u postgres psql`, y el prompt también será `postgres=#`.

## Paso 6. Preguntamos a qué estamos conectados

psql tiene sus propios comandos. Empiezan por una barra invertida `\` y no forman parte de SQL: son órdenes para el propio cliente. El primero es este:

```
\conninfo
```

`\conninfo` (connection information, «información de la conexión») nos dice cómo estamos conectados. La respuesta en nuestro ordenador:

```
    Connection Information
      Parameter       | Value
----------------------+-------
 Database             | admin
 Client User          | admin
 Socket Directory     | /tmp
 Server Port          | 5432
 Options              |
 Protocol Version     | 3.0
 Password Used        | false
 GSSAPI Authenticated | false
 Backend PID          | 90513
 SSL Connection       | false
 Superuser            | on
 Hot Standby          | off
(12 rows)
```

Hay doce filas, pero ahora solo nos interesan cinco:

- `Database | admin`: la base de datos en la que estamos;
- `Client User | admin`: el usuario con el que hemos entrado;
- `Server Port | 5432`: la puerta del servidor por la que hemos entrado;
- `Password Used | false`: no nos han pedido contraseña. Postgres.app viene configurado así por defecto: solo pueden conectarse los programas de este mismo ordenador, y solo los que hemos autorizado. En Windows aquí saldrá `true`, porque hemos escrito la contraseña;
- `Superuser | on`: somos el usuario principal del servidor. Es lo mismo que indica el signo `#` del prompt.

Las demás filas son detalles técnicos de la conexión. Los necesitaremos más adelante, o puede que nunca.

Ahora le hacemos al servidor la primera pregunta en SQL:

```sql
SELECT version();
```

Respuesta:

```
                                                         version
--------------------------------------------------------------------------------------------------------------------------
 PostgreSQL 18.6 (Postgres.app) on aarch64-apple-darwin23.6.0, compiled by Apple clang version 15.0.0 (clang-1500.3.9.4), 64-bit
(1 row)
```

- `SELECT`: «muestra». Es un comando que solo pregunta y no cambia nada (lección 1.1);
- `version()`: una función del servidor que devuelve su versión. Los paréntesis indican que es una función;
- `;`: la pregunta ha terminado.

La respuesta es una tabla pequeña: una columna, `version`, y una fila, `(1 row)`. Lo que nos importa es el principio: PostgreSQL 18.6. El resto de la línea cuenta cómo se compiló el programa. En otro ordenador y en otra compilación será distinto, y es normal.

Fijémonos en la diferencia. `\conninfo` es una orden para el cliente y no necesita punto y coma. `SELECT version();` es una pregunta en SQL para el servidor, y sin punto y coma el servidor se queda esperando a que sigamos.

Salimos de psql:

```
\q
```

`\q` (quit) significa «salir». El prompt del Terminal vuelve a ser el de siempre. Los comandos de psql los vemos con más detalle en la lección 1.3.

## Qué ha salido

Comparamos con nuestra hipótesis. Hemos visto tres señales de que todo funciona:

- en la ventana del servidor pone **Running**;
- `psql --version` responde con la versión 18;
- psql se ha conectado, `\conninfo` ha mostrado la base de datos, el usuario y el puerto 5432, y el servidor ha respondido a la primera pregunta.

El servidor y el cliente están instalados en nuestro ordenador y hablan entre ellos.

## Si algo falla

- **`zsh: command not found: psql`.** El Terminal no sabe dónde está psql. Comprobamos que el comando del paso 3 ha salido sin errores y abrimos una ventana nueva del Terminal: la antigua no vuelve a leer la configuración.
- **Después de `SELECT version()` el servidor no dice nada y el prompt ha pasado a `admin-#`.** Se nos ha olvidado el punto y coma, y psql está esperando el final de la pregunta. Escribimos `;` y pulsamos Enter.
- **`Postgres.app rejected "trust" authentication`.** Cuando Postgres.app nos preguntó, contestamos que no. Abrimos Postgres.app → Settings → App Permissions y le damos permiso a VS Code (o al Terminal).
- **`Port 5432 is already in use`.** En el ordenador ya hay otro servidor PostgreSQL funcionando, por ejemplo uno que instalamos antes. Hay que pararlo o elegir otro puerto para el servidor nuevo.
- **Windows: `password authentication failed for user "postgres"`.** La contraseña no es la que pusimos al instalar. La escribimos otra vez; mientras la tecleamos no se ve en pantalla, y así tiene que ser.

## Tus datos

En esta lección todavía no hay datos. A partir del capítulo 2, aquí explicaremos qué cambiar para usar nuestros propios datos.

## Resumen

**Conceptos:** instalación del servidor, PostGIS incluido o mediante Stack Builder, ruta de los comandos en el Terminal, prompt de psql `=#`, comandos del cliente con `\`.
**Código:** `psql --version`, `psql`, `\conninfo`, `SELECT version();`, `\q`.
**Lo esencial:** el servidor trabaja en segundo plano, y psql se conecta a él por el puerto 5432. Los comandos con `\` son para el cliente; el SQL con `;`, para el servidor.

## Preguntas para un ingeniero

1. *Un compañero ha cerrado la ventana de Postgres.app. ¿Se ha parado el servidor?*

   :::{dropdown} Respuesta

   No. La ventana es solo un panel de control. El servidor sigue funcionando en segundo plano hasta que lo paramos con el botón Stop o apagamos el ordenador.
   :::

2. *¿Por qué `\conninfo` funciona sin punto y coma y `SELECT version()` no?*

   :::{dropdown} Respuesta

   `\conninfo` es una orden para el propio cliente psql, y la ejecuta al momento. `SELECT` es una pregunta en SQL para el servidor, y psql solo se la envía cuando ve el `;`.
   :::

## Ejercicios

1. **Recordar.** ¿Con qué comando nos muestra psql a qué base de datos, con qué usuario y por qué puerto estamos conectados?

2. **Corregir.** Hemos escrito `SELECT version()` y hemos pulsado Enter. El servidor no dice nada y el prompt ha pasado a `admin-#`. ¿Qué tenemos que escribir?

3. **Recordar lo anterior (lección 1.1).** ¿Qué número tiene la «puerta» por la que los clientes llaman al servidor PostgreSQL y cómo se llama esa puerta?

[Respuestas](#es-ch01-l02)

## Pregunta abierta

El servidor funciona y psql se conecta a él. Pero nuestra base `admin` la ha creado el programa, no nosotros, y todavía no tiene apoyos. ¿Cómo creamos nuestra propia base de datos para el libro y cómo entramos en ella?

## Fuentes

- Postgres.app, Installing Postgres.app — https://postgresapp.com/documentation/install.html
- PostgreSQL, Windows installers — https://www.postgresql.org/download/windows/
- PostGIS, Windows installation (released versions) — https://postgis.net/documentation/getting_started/install_windows/released_versions/
- PostgreSQL, Linux downloads (Ubuntu) — https://www.postgresql.org/download/linux/ubuntu/
- PostgreSQL 18 Documentation, psql — https://www.postgresql.org/docs/18/app-psql.html
