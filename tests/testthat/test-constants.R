test_that("base_url apunta a la versión correcta de la API (v2.0)", {
  expect_equal(base_url, "https://apis.datos.gob.ar/georef/api/v2.0/")
})

test_that("DUMP_BASE_URL apunta al endpoint de descargas (sin versión)", {
  expect_equal(DUMP_BASE_URL, "https://apis.datos.gob.ar/georef/api/")
})

test_that("VALID$PARAMS contiene todos los endpoints esperados", {
  endpoints_esperados <- c(
    "aglomerados", "provincias", "departamentos", "municipios",
    "gobiernos-locales", "asentamientos", "localidades", "calles",
    "localidades-censales", "fracciones-censales", "radios-censales",
    "direcciones", "ubicacion", "establecimientos-educativos",
    "instituciones-universitarias"
  )
  for (ep in endpoints_esperados) {
    expect_true(ep %in% names(VALID$PARAMS),
                info = paste("Falta endpoint en VALID$PARAMS:", ep))
  }
})

test_that("VALID$PARAMS$ubicacion solo tiene los parámetros correctos", {
  # /ubicacion no acepta id, nombre, exacto, orden, inicio, max
  expect_setequal(VALID$PARAMS$ubicacion, c("campos", "aplanar", "lat", "lon", "division"))
})

test_that("VALID$PARAMS$direcciones incluye 'desplazar'", {
  expect_true("desplazar" %in% VALID$PARAMS$direcciones)
})

test_that("VALID$PARAMS$fracciones-censales NO incluye 'nombre' (no es parámetro del endpoint)", {
  # fracciones-censales no tiene búsqueda por nombre en la API
  expect_false("nombre" %in% VALID$PARAMS[["fracciones-censales"]])
})

test_that("GEOREFAR_API_MAX_QUERIES_PER_BATCH es 1000", {
  expect_equal(GEOREFAR_API_MAX_QUERIES_PER_BATCH, 1000)
})

test_that("GEOREFAR_API_MAX_SUM_MAX_PARAM_PER_BATCH es 5000", {
  expect_equal(GEOREFAR_API_MAX_SUM_MAX_PARAM_PER_BATCH, 5000)
})

test_that("LIMIT_MAX es 5000", {
  expect_equal(LIMIT_MAX, 5000)
})

test_that("ERR_MSGS tiene las claves principales", {
  expect_true(!is.null(ERR_MSGS$get_endpoint))
  expect_true(!is.null(ERR_MSGS$post))
  expect_true(!is.null(ERR_MSGS$helpers))
})
