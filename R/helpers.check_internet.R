check_internet <- function() {
  if (!curl::has_internet()) {
    stop("No se detect\u00f3 acceso a internet. Por favor chequea tu conexi\u00f3n.", call. = FALSE)
  }
}
