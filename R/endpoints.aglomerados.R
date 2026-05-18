#' Obtener aglomerados
#'
#' Permite realizar búsquedas sobre el listado de aglomerados.
#' Realiza la consulta GET al endpoint /aglomerados de georef-ar-api.
#' Para aumentar la cuota de uso, se puede configurar un token JWT en la variable
#' de entorno \code{GEOREFAR_TOKEN} (ver \url{https://datosgobar.github.io/georef-ar-api/jwt-token/}).
#' @param id text Filtrar por ID. Se pueden especificar varios IDs separados por comas.
#' @param nombre text Filtrar por Nombre.
#' @param orden text Campo por el cual ordenar los resultados (por ID o nombre)
#' @param aplanar boolean Cuando está presente, muestra el resultado JSON con una estructura plana.
#' @param campos text Campos a incluir en la respuesta separados por comas, sin espacios. Algunos campos siempre serán incluidos, incluso si no se agregaron en la lista. Para incluir campos de sub-entidades, separar los nombres con un punto, por ejemplo: provincia.id. También se pueden especificar los valores especiales basico, estandar y completo.
#' @param max integer Cantidad máxima de resultados a devolver. Si no se especifica, la API muestra 10 resultados por defecto.
#' @param inicio integer Cantidad de resultados a omitir desde el principio.
#' @param exacto boolean Cuando está presente, se activa el modo de búsqueda por texto exacto. Sólo tiene efecto cuando se usan campos de búsqueda por texto (por ejemplo, nombre).
#'
#' @export
#' @rdname get_aglomerados
#'
#' @references [georef-ar-api/aglomerados](https://datosgobar.github.io/georef-ar-api/open-api/#/Recursos/get_aglomerados)
#' @return Un Data Frame con el listado de Aglomerados
#' @examples
#' \dontrun{
#' get_aglomerados(nombre = "GRAN ROSARIO", provincia = "SANTA FE")
#' }
get_aglomerados <- function(
    id = NULL,
    nombre = NULL,
    orden = NULL,
    aplanar = TRUE,
    campos = NULL,
    max = NULL,
    inicio = NULL,
    exacto = NULL
  ){
    get_endpoint(endpoint = "aglomerados", args = as.list(environment()))
}

#' Consultar aglomerados en lote (POST)
#'
#' Realiza múltiples consultas al endpoint /aglomerados en una sola llamada usando POST.
#' @param queries_list Lista de listas, donde cada elemento es una consulta con los mismos
#'   parámetros aceptados por \code{get_aglomerados}.
#' @return Un tibble con los resultados combinados de todas las consultas.
#' @export
post_aglomerados <- function(queries_list){
  bulk_post_request(endpoint = "aglomerados", queries_list = queries_list)
}
