.libPaths(c(path.expand("~/R/library"), .libPaths()))

suppressPackageStartupMessages({
  library(httr2)
  library(dplyr)
  library(purrr)
  library(assertthat)
  library(curl)
  library(attempt)
  library(jsonlite)
  library(mockery)
  library(withr)
})

# Cargar source del paquete desde la raíz del proyecto
pkg_root <- normalizePath(file.path(testthat::test_path(), "..", ".."))

r_files <- c(
  "R/constants.R",
  "R/helpers.check_internet.R",
  "R/helpers.httr2_error_handler.R",
  "R/helpers.replace_null_with_na.R",
  "R/get_endpoint.R",
  "R/post.create_query_batches.R",
  "R/post.helpers.R",
  "R/post.prepare_post_batch_request.R",
  "R/post.process_single_post_response.R",
  "R/post.bulk_post_request.R",
  "R/endpoints.provincias.R",
  "R/endpoints.departamentos.R",
  "R/endpoints.municipios.R",
  "R/endpoints.localidades.R",
  "R/endpoints.aglomerados.R",
  "R/endpoints.asentamientos.R",
  "R/endpoints.calles.R",
  "R/endpoints.direcciones.R",
  "R/endpoints.ubicacion.R",
  "R/endpoints.fracciones_censales.R",
  "R/endpoints.radios_censales.R",
  "R/endpoints.localidades_censales.R",
  "R/endpoints.gobiernos_locales.R",
  "R/endpoints.establecimientos_educativos.R",
  "R/endpoints.instituciones_universitarias.R",
  "R/endpoints.descarga_completa.R"
)

for (f in r_files) {
  source(file.path(pkg_root, f), local = FALSE)
}
