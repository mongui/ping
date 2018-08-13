## Qué es

Se trata de un fichero de procesamiento por lotes de Windows (*batch*) que ejecuta un ping de forma indefinida a unos servidores localizados en el archivo HOSTS (o cualquier otro archivo) según un filtro dado.

## Por qué

Trabajar para una administración pública regional puede resultar, a veces, un dolor de cabeza. Te ves obligado a utilizar unas enrevesadas herramientas para cumplir los requisitos y, en otros casos, aplicaciones simples pero tediosas de ejecutar en el día a día.

Este script en batch surgió como una necesidad de automatizar un ping continuo a los servidores de esta administración. Una lista larga de nombres de máquinas pueblan mi archivo HOSTS y la de mis compañeros y un servicio VPN al que debemos conectarnos todos los días nos echa cada 5 minutos si no recibe tráfico. Es por ello que mucha gente en mi empresa se ha acostumbrado a buscar cada día uno de estos servidores dentro de la red virtual y a realizarle un PING contínuo evitando así el tener que meter a cada momento el usuario y la contraseña para reconectarse.

El proceso batch filtra el listado de servidores del archivo HOSTS por las palabras (dominios) deseadas y les realiza un ping cada cierto número de segundos determinado y te indica si el resultado es correcto o no. Ya está. Eso es todo lo que hace. Ejecutar y listo. De hecho, este texto contiene más palabras de las que hay en el propio archivo.

## Configuración

Es configurable mediante unos simples parámetros situados en la cabecera del fichero:

```
SET hosts=C:\Windows\System32\drivers\etc\hosts # Ruta al archivo HOSTS. Puede sustituirse por otro archivo con un formato similar si se desea.

SET filtro=dominio1.com dominio2.com dominio3.com # Filtros a aplicar en la búsqueda de las máquinas a las que realizar el ping.

SET listar=SI # Mostrar el listado de máquinas encontradas en el fichero antes de iniciar el ping.

SET timeout=5 # Lapso de tiempo de espera en segundos entre un PING y otro.
```
