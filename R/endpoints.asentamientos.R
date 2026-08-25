#' Obtener Asentamientos
#'
#' Permite realizar búsquedas sobre el listado de asentamientos.
#' Realiza la consulta GET al endpoint /asentamientos de georef-ar-api.
#' Para aumentar la cuota de uso, se puede configurar un token JWT en la variable
#' de entorno \code{GEOREFAR_TOKEN} (ver \url{https://datosgobar.github.io/georef-ar-api/jwt-token/}).
#' @param id text Filtrar por ID. Se pueden especificar varios IDs separados por comas.
#' @param nombre text Filtrar por Nombre.
#' @param provincia text Filtrar por nombre o ID de Provincia.
#' @param departamento text Filtrar por nombre o ID de Departamento.
#' @param gobierno_local text Filtrar por nombre o ID de Gobierno Local.
#' @param localidad_censal text Filtrar por nombre o ID de localidad censal. Se pueden especificar varios IDs separados por comas
#' @param categoria text Permite filtrar por tipo de asentamiento. Valores posibles: Paraje, Localidad, Base Antártica, Entidad.
#' @param orden text Campo por el cual ordenar los resultados (por ID o nombre)
#' @param aplanar boolean Cuando está presente, muestra el resultado JSON con una estructura plana.
#' @param campos text Campos a incluir en la respuesta separados por comas, sin espacios. Algunos campos siempre serán incluidos, incluso si no se agregaron en la lista. Para incluir campos de sub-entidades, separar los nombres con un punto, por ejemplo: provincia.id. También se pueden especificar los valores especiales basico, estandar y completo.
#' @param max integer Cantidad máxima de resultados a devolver. Si no se especifica, la API muestra 10 resultados por defecto.
#' @param inicio integer Cantidad de resultados a omitir desde el principio.
#' @param exacto boolean Cuando está presente, se activa el modo de búsqueda por texto exacto. Sólo tiene efecto cuando se usan campos de búsqueda por texto (por ejemplo, nombre).
#'
#' @export
#' @rdname get_asentamientos
#'
#' @references [georef-ar-api/asentamientos](https://datosgobar.github.io/georef-ar-api/open-api/#/Recursos/get_asentamientos)
#' @return Un Data Frame con el listado de Asentamientos.
#' @examples
#' \donttest{
#' # Requiere conexion a internet. Se usa try() para que una caida o un
#' # rate limit del servicio no haga fallar R CMD check (politica de CRAN
#' # sobre paquetes que dependen de recursos de internet).
#' try(get_asentamientos(provincia = "22", departamento = "007"))
#' }
get_asentamientos <- function(
    id = NULL,
    nombre = NULL,
    provincia = NULL,
    departamento = NULL,
    gobierno_local = NULL,
    localidad_censal = NULL,
    categoria = NULL,
    orden = NULL,
    aplanar = TRUE,
    campos = NULL,
    max = NULL,
    inicio = NULL,
    exacto = NULL
  ){
  get_endpoint(endpoint = "asentamientos", args = as.list(environment()))
}

#' @rdname post_endpoints
#' @export
post_asentamientos <- function(queries_list){
  bulk_post_request(endpoint = "asentamientos", queries_list = queries_list)
}
