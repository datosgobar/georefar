#' Obtener Ubicacion
#'
#' Permite realizar una georreferenciación inversa para un punto, informando cuales unidades territoriales lo contienen, además de la calle y altura más cercana.
#' Realiza la consulta GET al endpoint /ubicacion de georef-ar-api.
#' Para aumentar la cuota de uso, se puede configurar un token JWT en la variable
#' de entorno \code{GEOREFAR_TOKEN} (ver \url{https://datosgobar.github.io/georef-ar-api/jwt-token/}).
#' @param lat numeric Latitud del punto, en forma de número real con grados decimales.
#' @param lon numeric Longitud del punto, en forma de número real con grados decimales.
#' @param division text Tipo de división territorial que define las unidades territoriales que se devolverán. Valores disponibles : politica, geoestadistica
#' @param aplanar boolean Cuando está presente, muestra el resultado JSON con una estructura plana.
#' @param campos text Campos a incluir en la respuesta separados por comas, sin espacios. Algunos campos siempre serán incluidos, incluso si no se agregaron en la lista. Para incluir campos de sub-entidades, separar los nombres con un punto, por ejemplo: provincia.id. También se pueden especificar los valores especiales basico, estandar y completo.
#'
#' @export
#' @rdname get_ubicacion
#'
#' @references [georef-ar-api/ubicacion](https://datosgobar.github.io/georef-ar-api/open-api/#/Recursos/get_ubicacion)
#' @return Un Data Frame con las unidades territoriales que contienen el punto.
#' @examples
#' \dontrun{
#' get_ubicacion(lat = -34.6037, lon = -58.3816)
#' }
get_ubicacion <- function(lat, lon, division = NULL, aplanar = TRUE, campos = NULL){
  get_endpoint(endpoint = "ubicacion", args = as.list(environment()))
}

#' @rdname post_endpoints
#' @export
post_ubicacion <- function(queries_list){
  bulk_post_request(endpoint = "ubicacion", queries_list = queries_list)
}
