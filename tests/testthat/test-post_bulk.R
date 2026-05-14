skip_if_offline <- function() {
  skip_if_not(curl::has_internet(), "Sin acceso a internet")
}

test_that("post_provincias devuelve tibble con múltiples consultas", {
  skip_if_offline()
  queries <- list(
    list(nombre = "Buenos Aires"),
    list(nombre = "Córdoba"),
    list(nombre = "Santa Fe")
  )
  result <- post_provincias(queries)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("post_departamentos devuelve resultados para múltiples provincias", {
  skip_if_offline()
  queries <- list(
    list(provincia = "82", max = 3),
    list(provincia = "14", max = 3)
  )
  result <- post_departamentos(queries)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("post_municipios devuelve resultados", {
  skip_if_offline()
  queries <- list(
    list(nombre = "Rosario", max = 2),
    list(nombre = "Córdoba", max = 2)
  )
  result <- post_municipios(queries)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("post_localidades devuelve resultados", {
  skip_if_offline()
  queries <- list(
    list(nombre = "Palermo", provincia = "02", max = 3)
  )
  result <- post_localidades(queries)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("post_calles devuelve resultados", {
  skip_if_offline()
  queries <- list(
    list(nombre = "Corrientes", provincia = "82", max = 3)
  )
  result <- post_calles(queries)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("bulk_post_request lanza error si queries_list no es lista de listas", {
  expect_error(
    bulk_post_request("provincias", list("texto", "otro")),
    regexp = "lista de listas",
    ignore.case = TRUE
  )
})

test_that("bulk_post_request emite warning con lista vacía", {
  expect_warning(
    bulk_post_request("provincias", list()),
    regexp = "vacía",
    ignore.case = TRUE
  )
})

test_that("bulk_post_request devuelve tibble vacío con lista vacía", {
  result <- suppressWarnings(bulk_post_request("provincias", list()))
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("post_aglomerados devuelve resultados", {
  skip_if_offline()
  queries <- list(list(nombre = "Gran Rosario", max = 3))
  result <- post_aglomerados(queries)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("post_localidades_censales devuelve resultados", {
  skip_if_offline()
  queries <- list(list(nombre = "Rosario", max = 3))
  result <- post_localidades_censales(queries)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("post_ubicacion devuelve resultados (nombre corregido de port_ubicacion)", {
  skip_if_offline()
  queries <- list(list(lat = -32.9468, lon = -60.6393))
  result <- post_ubicacion(queries)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("post_normalizar_direccion normaliza múltiples direcciones", {
  skip_if_offline()
  queries <- list(
    list(direccion = "Corrientes 1200", provincia = "82", max = 1),
    list(direccion = "San Martin 100",  provincia = "14", max = 1)
  )
  result <- post_normalizar_direccion(queries)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})
