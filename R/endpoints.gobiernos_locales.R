#' Obtener Gobiernos Locales
#'
#' Permite realizar búsquedas sobre el listado de gobiernos locales.
#' Realiza la consulta GET al endpoint /gobiernos-locales de georef-ar-api.
#' Para aumentar la cuota de uso, se puede configurar un token JWT en la variable
#' de entorno \code{GEOREFAR_TOKEN} (ver \url{https://datosgobar.github.io/georef-ar-api/jwt-token/}).
#' @param id text Filtrar por ID. Se pueden especificar varios IDs separados por comas.
#' @param nombre text Filtrar por Nombre.
#' @param provincia text Filtrar por nombre o ID de Provincia.
#' @param departamento text Filtrar por nombre o ID de Departamento.
#' @param interseccion text Filtrar por intersección con otras entidades geográficas. El valor del campo debe tener el siguiente formato: < tipo de entidad A>:<id 1>:<id 2>, < tipo de entidad B>:<id 1>:<id 2>, ... Se incluye en la respuesta cualquier entidad que intereseccione con una o más de las entidades con los IDs especificados.
#' @param categoria text Permite filtrar por tipo de gobierno local. Valores posibles: Comisión de Fomento, Comisión Municipal, Comisión Municipal, Comuna, Comuna Rural, Junta de Gobierno, Municipio.
#' @param orden text Campo por el cual ordenar los resultados. (Por ID o nombre)
#' @param aplanar boolean Cuando está presente, muestra el resultado JSON con una estructura plana.
#' @param campos text Campos a incluir en la respuesta separados por comas, sin espacios. Algunos campos siempre serán incluidos, incluso si no se agregaron en la lista. Para incluir campos de sub-entidades, separar los nombres con un punto, por ejemplo: provincia.id. También se pueden especificar los valores especiales basico, estandar y completo.
#' @param max integer Cantidad máxima de resultados a devolver. Si no se especifica, la API muestra 10 resultados por defecto.
#' @param inicio integer Cantidad de resultados a omitir desde el principio.
#' @param exacto boolean Cuando está presente, se activa el modo de búsqueda por texto exacto. Sólo tiene efecto cuando se usan campos de búsqueda por texto (por ejemplo, nombre).
#'
#' @export
#' @rdname get_gobiernos_locales
#'
#' @references [georef-ar-api/gobiernos-locales](https://datosgobar.github.io/georef-ar-api/open-api/#/Recursos/get_gobiernos-locales)
#' @return Un Data Frame con el listado de Gobiernos Locales
#' @examples
#' \dontrun{
#' get_gobiernos_locales(provincia = "cordoba", max = 10)
#' }
get_gobiernos_locales <- function(
    id = NULL,
    nombre = NULL,
    provincia = NULL,
    departamento = NULL,
    interseccion = NULL,
    categoria = NULL,
    orden = NULL,
    aplanar = TRUE,
    campos = NULL,
    max = NULL,
    inicio = NULL,
    exacto = NULL
  ){
    get_endpoint(endpoint = "gobiernos-locales", args = as.list(environment()))
}

#' @rdname post_endpoints
#' @export
post_gobiernos_locales <- function(queries_list){
  bulk_post_request(endpoint = "gobiernos-locales", queries_list = queries_list)
}
