#' Consultas POST por lotes a la georef-ar-api
#'
#' Familia de funciones que permiten realizar múltiples consultas a un mismo
#' endpoint de la georef-ar-api en una sola llamada, utilizando el método POST.
#' A diferencia de las funciones \code{get_*}, que resuelven una consulta por
#' vez, las funciones \code{post_*} reciben un conjunto de consultas, las
#' agrupan en lotes según los límites de la API, las envían en paralelo y
#' combinan las respuestas en un único resultado.
#'
#' Cada función corresponde al endpoint homónimo y acepta los mismos parámetros
#' de búsqueda que su equivalente \code{get_*}. Para aumentar la cuota de uso,
#' se puede configurar un token JWT en la variable de entorno
#' \code{GEOREFAR_TOKEN} (ver
#' \url{https://datosgobar.github.io/georef-ar-api/jwt-token/}).
#'
#' @param queries_list Lista de listas. Cada elemento es una consulta expresada
#'   como una lista nombrada, cuyos nombres se corresponden con los parámetros
#'   aceptados por la función \code{get_*} del mismo endpoint (por ejemplo
#'   \code{nombre}, \code{id}, \code{max}, \code{campos}).
#'
#' @return Un tibble con los resultados combinados de todas las consultas
#'   enviadas. Si ninguna consulta produce resultados, se devuelve un tibble
#'   vacío y se emite un \code{warning}.
#'
#' @references [georef-ar-api](https://datosgobar.github.io/georef-ar-api/)
#'
#' @examples
#' \dontrun{
#' consultas <- list(
#'   list(nombre = "Neuquen"),
#'   list(nombre = "Santa Fe", max = 1)
#' )
#' post_provincias(consultas)
#'
#' post_ubicacion(list(
#'   list(lat = -34.6037, lon = -58.3816),
#'   list(lat = -31.4201, lon = -64.1888)
#' ))
#' }
#'
#' @name post_endpoints
NULL
