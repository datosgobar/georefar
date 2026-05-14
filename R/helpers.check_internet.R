check_internet <- function() {
  if (!curl::has_internet()) {
    stop("No se detectó acceso a internet. Por favor chequea tu conexión.", call. = FALSE)
  }
}
