georefar es un paquete de R que funciona como wrapper del servicio de georreferenciación georef del Gobierno de Argentina. Permite consultar provincias, departamentos, municipios, localidades, calles y otras entidades territoriales, normalizar direcciones y descargar listados completos de datos geográficos, todo desde R y devolviendo los resultados como data.frame / tibble listos para analizar.

La API oficial está documentada en https://apis.datos.gob.ar/georef y https://datosgobar.github.io/georef-ar-api/.

Instalación

Próximamente en CRAN. Una vez publicado, se podrá instalar con:

r
install.packages("georefar")

Mientras tanto, se puede instalar la versión de desarrollo desde GitHub:

r
# install.packages("devtools")
devtools::install_github("datosgobar/georefar")
Uso
r
library(georefar)

El paquete ofrece tres familias de funciones.

1. Consultas individuales (get_*)

Cada función get_* realiza una consulta al endpoint correspondiente y devuelve un tibble. Aceptan los parámetros de filtrado de la API (nombre, id, provincia, max, exacto, etc.).

r
# Listar todas las provincias
get_provincias()

# Filtrar por nombre exacto
get_provincias(nombre = "Cordoba", exacto = TRUE)

# Departamentos de una provincia
get_departamentos(provincia = "02", max = 5)

# Municipios
get_municipios(provincia = "82", max = 10)

# Localidades
get_localidades(nombre = "Rosario", provincia = "82")

# Calles
get_calles(nombre = "Corrientes", provincia = "82", max = 5)

Normalización de direcciones y geolocalización inversa:

r
# Normalizar una dirección
normalizar_direccion(direccion = "Corrientes 1200", provincia = "82")

# Obtener las unidades territoriales que contienen un punto
get_ubicacion(lat = -34.6037, lon = -58.3816)

Otras entidades disponibles: get_asentamientos(), get_aglomerados(), get_localidades_censales(), get_fracciones_censales(), get_radios_censales(), get_gobiernos_locales(), get_establecimientos_educativos(), get_instituciones_universitarias().

2. Consultas por lotes (post_*)

Cuando hay que hacer muchas consultas, las funciones post_* permiten enviarlas todas juntas en una sola operación (batch), reduciendo la cantidad de solicitudes al servidor. Reciben una lista de consultas, donde cada elemento es a su vez una lista con los parámetros de esa consulta.

r
# Consultar varias provincias en una sola operación
post_provincias(list(
  list(nombre = "Cordoba"),
  list(nombre = "Santa Fe"),
  list(nombre = "Mendoza")
))

Existe una función post_* por cada endpoint (post_departamentos(), post_municipios(), post_localidades(), etc.).

3. Descarga de datos completos (get_geodata_dump)

Para obtener listados completos de una entidad (en lugar de consultas filtradas), get_geodata_dump() descarga el archivo entero en el formato elegido. Puede devolver el contenido parseado en R o guardarlo en disco.

r
# Obtener todas las provincias en formato GeoJSON como objeto de R
provincias <- get_geodata_dump(entidad = "provincias", formato = "geojson")

# Descargar y guardar en disco
get_geodata_dump(
  entidad     = "departamentos",
  formato     = "csv",
  path_to_save = "departamentos.csv"
)

Formatos disponibles: "csv", "json", "geojson", "ndjson".
