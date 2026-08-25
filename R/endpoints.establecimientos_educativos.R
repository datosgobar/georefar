#' Obtener Establecimientos Educativos
#'
#' Permite realizar búsquedas sobre el listado de establecimientos educativos.
#' Realiza la consulta GET al endpoint /establecimientos-educativos de georef-ar-api.
#' Para aumentar la cuota de uso, se puede configurar un token JWT en la variable
#' de entorno \code{GEOREFAR_TOKEN} (ver \url{https://datosgobar.github.io/georef-ar-api/jwt-token/}).
#' @param id text Filtrar por ID. Se pueden especificar varios IDs separados por comas.
#' @param nombre text Filtrar por Nombre.
#' @param provincia text Filtrar por nombre o ID de Provincia.
#' @param departamento text Filtrar por nombre o ID de Departamento.
#' @param gestion text Filtrar por tipo de gestión. Valores posibles: Estatal, Privada
#' @param orden text Campo por el cual ordenar los resultados. (Por ID o nombre)
#' @param aplanar boolean Cuando está presente, muestra el resultado JSON con una estructura plana.
#' @param campos text Campos a incluir en la respuesta separados por comas, sin espacios. Algunos campos siempre serán incluidos, incluso si no se agregaron en la lista. Para incluir campos de sub-entidades, separar los nombres con un punto, por ejemplo: provincia.id. También se pueden especificar los valores especiales basico, estandar y completo.
#' @param max integer Cantidad máxima de resultados a devolver. Si no se especifica, la API muestra 10 resultados por defecto.
#' @param inicio integer Cantidad de resultados a omitir desde el principio.
#' @param exacto boolean Cuando está presente, se activa el modo de búsqueda por texto exacto. Sólo tiene efecto cuando se usan campos de búsqueda por texto (por ejemplo, nombre).
#'
#' @export
#' @rdname get_establecimientos_educativos
#'
#' @references [georef-ar-api/establecimientos-educativos](https://datosgobar.github.io/georef-ar-api/open-api/#/Recursos/get_establecimientos-educativos)
#' @return Un Data Frame con el listado de Establecimientos Educativos
#' @examples
#' \donttest{
#' # Requiere conexion a internet. Se usa try() para que una caida o un
#' # rate limit del servicio no haga fallar R CMD check (politica de CRAN
#' # sobre paquetes que dependen de recursos de internet).
#' try(get_establecimientos_educativos(provincia = "cordoba", max = 10))
#' }
get_establecimientos_educativos <- function(
    id = NULL,
    nombre = NULL,
    provincia = NULL,
    departamento = NULL,
    gestion = NULL,
    orden = NULL,
    aplanar = TRUE,
    campos = NULL,
    max = NULL,
    inicio = NULL,
    exacto = NULL
  ){
    get_endpoint(endpoint = "establecimientos-educativos", args = as.list(environment()))
}

#' @rdname post_endpoints
#' @export
post_establecimientos_educativos <- function(queries_list){
  bulk_post_request(endpoint = "establecimientos-educativos", queries_list = queries_list)
}
