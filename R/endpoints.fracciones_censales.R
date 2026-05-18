#' Obtener Fracciones Censales
#'
#' Permite realizar búsquedas sobre el listado de fracciones censales.
#' Realiza la consulta GET al endpoint /fracciones-censales de georef-ar-api.
#' Para aumentar la cuota de uso, se puede configurar un token JWT en la variable
#' de entorno \code{GEOREFAR_TOKEN} (ver \url{https://datosgobar.github.io/georef-ar-api/jwt-token/}).
#' @param id text Filtrar por ID. Se pueden especificar varios IDs separados por comas.
#' @param provincia text Filtrar por nombre o ID de Provincia.
#' @param departamento text Filtrar por nombre o ID de Departamento.
#' @param orden text Campo por el cual ordenar los resultados (por ID o nombre)
#' @param aplanar boolean Cuando está presente, muestra el resultado JSON con una estructura plana.
#' @param campos text Campos a incluir en la respuesta separados por comas, sin espacios. Algunos campos siempre serán incluidos, incluso si no se agregaron en la lista. Para incluir campos de sub-entidades, separar los nombres con un punto, por ejemplo: provincia.id. También se pueden especificar los valores especiales basico, estandar y completo.
#' @param max integer Cantidad máxima de resultados a devolver. Si no se especifica, la API muestra 10 resultados por defecto.
#' @param inicio integer Cantidad de resultados a omitir desde el principio.
#' @param exacto boolean Cuando está presente, se activa el modo de búsqueda por texto exacto. Sólo tiene efecto cuando se usan campos de búsqueda por texto (por ejemplo, nombre).
#'
#' @export
#' @rdname get_fracciones_censales
#'
#' @references [georef-ar-api/fracciones-censales](https://datosgobar.github.io/georef-ar-api/open-api/#/Recursos/get_fracciones_censales)
#' @return Un Data Frame con el listado de Fracciones Censales.
#' @examples
#' \dontrun{
#' get_fracciones_censales(id = "8208428")
#' }
get_fracciones_censales <- function(
    id = NULL,
    provincia = NULL,
    departamento = NULL,
    orden = NULL,
    aplanar = TRUE,
    campos = NULL,
    max = NULL,
    inicio = NULL,
    exacto = NULL
  ){
    get_endpoint(endpoint = "fracciones-censales", args = as.list(environment()))
}

#'@export
post_fracciones_censales <- function(queries_list){
  bulk_post_request(endpoint = "fracciones-censales", queries_list = queries_list)
}
