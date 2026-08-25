# Tests de integración POST (bulk) contra la API pública
# La API pública tiene rate limiting, por eso se agrega Sys.sleep() entre tests.

# Todos los tests de este archivo pegan a la API pública de georef.
# Se saltean en CRAN (sin red / rate limits) y sin internet.
skip_if_offline <- function() {
  testthat::skip_on_cran()
  testthat::skip_if_not(curl::has_internet(), "Sin acceso a internet")
}
# Wrapper que convierte 429 en skip en lugar de fallo
# (la API pública tiene rate limiting agresivo cuando se corre el suite completo)
skip_on_rate_limit <- function(expr) {
  tryCatch(expr, error = function(e) {
    if (grepl("429|Too Many Requests|rate limit", conditionMessage(e), ignore.case = TRUE)) {
      skip("API rate limit alcanzado (429) - ejecutar este test en forma aislada")
    }
    stop(e)
  })
}

# ── post_provincias ───────────────────────────────────────────────────────────

test_that("post_provincias devuelve tibble para una query", {
  skip_if_offline()
  result <- post_provincias(list(list(nombre = "Buenos Aires", max = 1)))
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
  Sys.sleep(1)
})

test_that("post_provincias maneja múltiples queries", {
  skip_if_offline()
  result <- post_provincias(list(
    list(nombre = "Córdoba",  max = 1),
    list(nombre = "Santa Fe", max = 1),
    list(nombre = "Mendoza",  max = 1)
  ))
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 3)
  Sys.sleep(1)
})

test_that("post_provincias lanza error si no es lista de listas", {
  expect_error(post_provincias(list("Buenos Aires")))
})

test_that("post_provincias emite warning con lista vacía", {
  expect_warning(post_provincias(list()), regexp = "vac")
})

# ── post_departamentos ────────────────────────────────────────────────────────

test_that("post_departamentos devuelve tibble", {
  skip_if_offline()
  Sys.sleep(1)
  result <- post_departamentos(list(
    list(provincia = "14", max = 3),
    list(provincia = "82", max = 3)
  ))
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 2)
})

# ── post_municipios ───────────────────────────────────────────────────────────

test_that("post_municipios devuelve tibble", {
  skip_if_offline()
  Sys.sleep(1)
  result <- post_municipios(list(list(provincia = "06", max = 3)))
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

# ── post_localidades ──────────────────────────────────────────────────────────

test_that("post_localidades devuelve tibble", {
  skip_if_offline()
  Sys.sleep(1)
  result <- post_localidades(list(
    list(nombre = "Rosario", max = 2),
    list(nombre = "Córdoba", max = 2)
  ))
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 2)
})

# ── post_aglomerados ──────────────────────────────────────────────────────────

test_that("post_aglomerados devuelve tibble", {
  skip_if_offline()
  Sys.sleep(1)
  result <- post_aglomerados(list(list(nombre = "Gran Rosario", max = 1)))
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

# ── post_asentamientos ────────────────────────────────────────────────────────

test_that("post_asentamientos devuelve tibble", {
  skip_if_offline()
  Sys.sleep(1)
  result <- post_asentamientos(list(list(provincia = "22", max = 3)))
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

# ── post_calles ───────────────────────────────────────────────────────────────

test_that("post_calles devuelve tibble", {
  skip_if_offline()
  Sys.sleep(5)
  skip_on_rate_limit(
    result <- post_calles(list(list(nombre = "Corrientes", provincia = "82", max = 3)))
  )
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

# ── post_localidades_censales ─────────────────────────────────────────────────

test_that("post_localidades_censales devuelve tibble", {
  skip_if_offline()
  Sys.sleep(5)
  skip_on_rate_limit(
    result <- post_localidades_censales(list(list(nombre = "Córdoba", max = 2)))
  )
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

# ── post_fracciones_censales ──────────────────────────────────────────────────

test_that("post_fracciones_censales devuelve tibble", {
  skip_if_offline()
  Sys.sleep(5)
  skip_on_rate_limit(
    result <- post_fracciones_censales(list(list(provincia = "06", max = 3)))
  )
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

# ── post_radios_censales ──────────────────────────────────────────────────────

test_that("post_radios_censales devuelve tibble", {
  skip_if_offline()
  Sys.sleep(5)
  skip_on_rate_limit(
    result <- post_radios_censales(list(list(provincia = "02", max = 3)))
  )
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

# ── post_gobiernos_locales ────────────────────────────────────────────────────

test_that("post_gobiernos_locales devuelve tibble", {
  skip_if_offline()
  Sys.sleep(5)
  skip_on_rate_limit(
    result <- post_gobiernos_locales(list(list(provincia = "14", max = 3)))
  )
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

# ── post_establecimientos_educativos ──────────────────────────────────────────

test_that("post_establecimientos_educativos devuelve tibble", {
  skip_if_offline()
  Sys.sleep(5)
  skip_on_rate_limit(
    result <- post_establecimientos_educativos(list(list(provincia = "06", max = 3)))
  )
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

# ── post_instituciones_universitarias ─────────────────────────────────────────

test_that("post_instituciones_universitarias devuelve tibble", {
  skip_if_offline()
  Sys.sleep(5)
  skip_on_rate_limit(
    result <- post_instituciones_universitarias(list(list(provincia = "14", max = 3)))
  )
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

# ── batching (lógica interna, sin API) ────────────────────────────────────────

test_that("bulk POST divide correctamente en lotes de 1000 (lógica interna)", {
  # Verificar que create_query_batches divide 1001 queries en 2 lotes
  queries <- replicate(1001, list(nombre = "test", max = 1), simplify = FALSE)
  batches <- create_query_batches(queries, max_queries_per_batch = 1000)
  expect_equal(length(batches), 2)
  expect_equal(length(batches[[1]]), 1000)
  expect_equal(length(batches[[2]]), 1)
})
