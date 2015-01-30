# Instalación

Para utilizar Riak, vamos a necesitar instalar el gestor de DB, la forma más sencilla de lograrlo es mediante Homebrew, basta con ejecutar

`brew install riak`

En caso de que tengamos una versión instalada previamente, lo ideal es actualizar a la versión 2, que introduce mejoras en la búsqueda (y mantiene la compatibilidad con las versiones 1.4+ en la mayoría de situaciones).

Podemos comprobar que Riak está funcionando con este comando:

`riak start`

El servicio riak funciona por defecto en el puerto 8087. Posteriormente para comprobar la salud del nodo:

`riak-admin member-status`

También vamos a necesitar una librería cliente para usarlo desde Ruby, en este caso, la mejor es la ofrecida directamente por los creadores de Riak:

`gem install riak-client`

# Configuración

Por defecto los buckets de Riak vienen con un backend (cuando mencionamos backend, es muy similar a cómo MySQL trabaja con InnoDB o ISAM) Bitcask que fue hecho por los mismos muchachos de Basho, sin embargo para la mayoría de aplicaciones lo recomendable es usar LevelDB de los amigos de Google.

Para hacer este cambio, vamos a editar el archivo `riak.conf` dentro de `HOMEBREW_HOME/riak/2.0.2/libexec/etc`:

`storage_backend = leveldb`

Hablemos un poco sobre las capacidades de búsqueda en Riak. Por defecto están desactivadas. No, lo que acaban de leer no es un error, el motivo de esto es porque un bucket puede tener sus datos repartidos entre muchos nodos en múltiples lugares diferentes, de forma que las búsquedas pueden ser una operación costosa, pero desde la versión 2 se ha puesto mucho énfasis en mejorar el rendimiento de la búsqueda y los creadores recomiendan usarla en vez de los índices secundarios. Para habilitarla basta con cambiar la línea de `search = off` a esto:

`search = on`

Si tenemos iniciado ya Riak, podemos detenerlo con:

`riak stop` e iniciarlo nuevamente para que cambie el backend de los nodos.

Lo más seguro es que nos muestre un error quejándose sobre el valor de `ulimit` en el sistema, esto se debe a que Riak por defecto funciona con archivos de datos que va incorporando a la base de datos posteriormente, entonces utiliza una gran cantidad de file descriptors, pero podemos ignorarlo por el momento.
