#' Obtener Localidades
#'
#' Permite realizar búsquedas sobre el listado de localidades.
#' Realiza la consulta GET al endpoint /localidades de georef-ar-api.
#' Si existe GEOREFAR_TOKEN en el Renviron lo usará para hacer la consulta.
#' @param id text Filtrar por ID. Se pueden especificar varios IDs separados por comas.
#' @param nombre text Filtrar por Nombre.
#' @param provincia text Filtrar por nombre o ID de Provincia.
#' @param departamento text Filtrar por nombre o ID de Departamento.
#' @param gobierno_local text Filtrar por nombre o ID de Gobierno Local.
#' @param localidad_censal text Filtrar por nombre o ID de localidad censal. Se pueden especificar varios IDs separados por comas
#' @param orden text Campo por el cual ordenar los resultados (por ID o nombre)
#' @param aplanar boolean Cuando está presente, muestra el resultado JSON con una estructura plana.
#' @param campos text Campos a incluir en la respuesta separados por comas, sin espacios. Algunos campos siempre serán incluidos, incluso si no se agregaron en la lista. Para incluir campos de sub-entidades, separar los nombres con un punto, por ejemplo: provincia.id. También se pueden especificar los valores especiales basico, estandar y completo.
#' @param max integer Cantidad máxima de resultados a devolver. Si no se especifica, la API muestra 10 resultados por defecto.
#' @param inicio integer Cantidad de resultados a omitir desde el principio.
#' @param exacto boolean Cuando está presente, se activa el modo de búsqueda por texto exacto. Sólo tiene efecto cuando se usan campos de búsqueda por texto (por ejemplo, nombre).
#'
#' @export
#' @rdname get_localidades
#'
#' @references [georef-ar-api/localidades](https://datosgobar.github.io/georef-ar-api/open-api/#/Recursos/get_localidades)
#' @return Un Data Frame con el listado de Localidades
#' @examples
#' \dontrun{
#' get_localidades(nombre = "PALERMO", provincia = "CIUDAD AUTONOMA DE BUENOS AIRES")
#' }
get_localidades <- function(
    id = NULL,
    nombre = NULL,
    provincia = NULL,
    departamento = NULL,
    gobierno_local = NULL,
    localidad_censal = NULL,
    orden = NULL,
    aplanar = TRUE,
    campos = NULL,
    max = NULL,
    inicio = NULL,
    exacto = NULL
  ){
  get_endpoint(endpoint = "localidades", args = as.list(environment()))
}

#'@export
post_localidades <- function(queries_list){
  bulk_post_request(endpoint = "localidades", queries_list = queries_list)
}
