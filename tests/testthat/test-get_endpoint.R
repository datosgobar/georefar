test_that("get_endpoint lanza error con parámetro inválido", {
  expect_error(
    get_endpoint("provincias", list(nombre = "Buenos Aires", param_falso = "x")),
    regexp = "no reconocido|param_falso",
    ignore.case = TRUE
  )
})

test_that("get_endpoint lanza error con parámetro NA", {
  expect_error(
    get_endpoint("provincias", list(nombre = NA_character_)),
    regexp = "NA|nombre",
    ignore.case = TRUE
  )
})

test_that("get_endpoint lanza error sin internet (simulado)", {
  withr::with_envvar(c(GEOREFAR_TOKEN = ""), {
    # Forzar fallo de red apuntando a host inválido
    old_url <- base_url
    withr::defer(assign("base_url", old_url, envir = .GlobalEnv))
    assign("base_url", "https://host.invalido.georefar.test/api/v2.0/", envir = .GlobalEnv)
    expect_error(get_endpoint("provincias", list(nombre = "Buenos Aires")))
  })
})

# Tests de integración (requieren internet)
skip_if_offline <- function() {
  skip_if_not(curl::has_internet(), "Sin acceso a internet")
}

test_that("get_provincias devuelve tibble con columnas esperadas", {
  skip_if_offline()
  result <- get_provincias(max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
  expect_true("id"     %in% names(result))
  expect_true("nombre" %in% names(result))
})

test_that("get_provincias filtra por nombre correctamente", {
  skip_if_offline()
  result <- get_provincias(nombre = "Córdoba", exacto = TRUE)
  expect_equal(nrow(result), 1)
  expect_true(grepl("C.rdoba", result$nombre[1], ignore.case = TRUE))
})

test_that("get_provincias devuelve 24 provincias en total", {
  skip_if_offline()
  result <- get_provincias(max = 24)
  expect_equal(nrow(result), 24)
})

test_that("get_departamentos filtra por provincia", {
  skip_if_offline()
  result <- get_departamentos(provincia = "06", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("get_municipios devuelve tibble con id y nombre", {
  skip_if_offline()
  result <- get_municipios(nombre = "Rosario", max = 3)
  expect_s3_class(result, "tbl_df")
  expect_true("id"     %in% names(result))
  expect_true("nombre" %in% names(result))
})

test_that("get_localidades filtra por provincia y nombre", {
  skip_if_offline()
  result <- get_localidades(provincia = "82", nombre = "Rosario", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("get_aglomerados devuelve resultados", {
  skip_if_offline()
  result <- get_aglomerados(max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("get_asentamientos filtra por provincia", {
  skip_if_offline()
  result <- get_asentamientos(provincia = "22", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("get_calles filtra por provincia y departamento", {
  skip_if_offline()
  result <- get_calles(provincia = "82", departamento = "82028", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("get_localidades_censales devuelve resultados", {
  skip_if_offline()
  result <- get_localidades_censales(nombre = "Rosario", max = 3)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("get_fracciones_censales filtra por provincia", {
  skip_if_offline()
  result <- get_fracciones_censales(provincia = "82", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("get_radios_censales filtra por provincia", {
  skip_if_offline()
  result <- get_radios_censales(provincia = "82", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("get_gobiernos_locales devuelve resultados", {
  skip_if_offline()
  result <- get_gobiernos_locales(provincia = "14", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("get_establecimientos_educativos devuelve resultados", {
  skip_if_offline()
  result <- get_establecimientos_educativos(provincia = "82", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("get_instituciones_universitarias devuelve resultados", {
  skip_if_offline()
  result <- get_instituciones_universitarias(max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("normalizar_direccion normaliza una dirección conocida", {
  skip_if_offline()
  result <- normalizar_direccion(direccion = "Corrientes 1200", provincia = "82", max = 3)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("get_ubicacion devuelve unidades territoriales para coordenadas conocidas", {
  skip_if_offline()
  # Centro de Rosario, Santa Fe
  result <- get_ubicacion(lat = -32.9468, lon = -60.6393)
  expect_s3_class(result, "tbl_df")
  expect_gt(nrow(result), 0)
})

test_that("parámetro 'inicio' funciona como paginación", {
  skip_if_offline()
  pag1 <- get_provincias(max = 5, inicio = 0)
  pag2 <- get_provincias(max = 5, inicio = 5)
  expect_equal(nrow(pag1), 5)
  expect_equal(nrow(pag2), 5)
  # Las páginas no deben tener los mismos IDs
  expect_false(any(pag1$id %in% pag2$id))
})

test_that("parámetro 'campos' limita las columnas devueltas", {
  skip_if_offline()
  result <- get_provincias(campos = "id,nombre", max = 3)
  expect_true("id"     %in% names(result))
  expect_true("nombre" %in% names(result))
  # centroide no debería estar si no se pidió
  expect_false("centroide_lat" %in% names(result))
})

test_that("parámetro 'exacto' hace búsqueda exacta", {
  skip_if_offline()
  # "Buenos" sin exacto devuelve varias; con exacto y nombre completo devuelve 1
  result_exacto <- get_provincias(nombre = "Buenos Aires", exacto = TRUE)
  expect_equal(nrow(result_exacto), 1)
})
