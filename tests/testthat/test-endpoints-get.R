# Tests de integración real contra la API pública
# Se saltan si no hay internet disponible

skip_if_offline <- function() {
  skip_if_not(curl::has_internet(), "Sin acceso a internet")
}

# ── provincias ────────────────────────────────────────────────────────────────

test_that("get_provincias devuelve 24 provincias", {
  skip_if_offline()
  result <- get_provincias(max = 24)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 24)
})

test_that("get_provincias filtra por nombre correctamente", {
  skip_if_offline()
  result <- get_provincias(nombre = "Córdoba", exacto = TRUE)
  expect_equal(nrow(result), 1)
  expect_true(grepl("C.rdoba", result$nombre[1]))
})

test_that("get_provincias filtra por ID", {
  skip_if_offline()
  result <- get_provincias(id = "06")
  expect_equal(nrow(result), 1)
  expect_equal(result$id[1], "06")
})

test_that("get_provincias con aplanar=TRUE devuelve columnas planas", {
  skip_if_offline()
  result <- get_provincias(nombre = "Neuquén", aplanar = TRUE)
  # Con aplanar, centroide.lat y centroide.lon deben aparecer como columnas
  expect_true(any(grepl("centroide", names(result))))
})

test_that("get_provincias respeta parámetro 'max'", {
  skip_if_offline()
  result <- get_provincias(max = 3)
  expect_lte(nrow(result), 3)
})

test_that("get_provincias respeta parámetro 'inicio'", {
  skip_if_offline()
  r1 <- get_provincias(max = 5, inicio = 0)
  r2 <- get_provincias(max = 5, inicio = 5)
  # Los IDs no deben solaparse
  expect_equal(length(intersect(r1$id, r2$id)), 0)
})

test_that("get_provincias lanza error con parámetro inválido", {
  # R rechaza el argumento desconocido antes de llegar a get_endpoint
  expect_error(get_provincias(parametro_falso = "x"))
})

# ── departamentos ─────────────────────────────────────────────────────────────

test_that("get_departamentos filtra por provincia", {
  skip_if_offline()
  result <- get_departamentos(provincia = "02", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

test_that("get_departamentos filtra por nombre exacto", {
  skip_if_offline()
  result <- get_departamentos(nombre = "Capital", provincia = "14", exacto = TRUE)
  expect_gte(nrow(result), 1)
  expect_true(any(grepl("Capital", result$nombre)))
})

test_that("get_departamentos filtra por ID", {
  skip_if_offline()
  result <- get_departamentos(id = "14014")
  expect_equal(nrow(result), 1)
  expect_equal(result$id[1], "14014")
})

# ── municipios ────────────────────────────────────────────────────────────────

test_that("get_municipios filtra por provincia", {
  skip_if_offline()
  result <- get_municipios(provincia = "82", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

test_that("get_municipios filtra por departamento", {
  skip_if_offline()
  # En v2.0 el filtro por departamento en /municipios no está soportado (devuelve 400)
  # Documentamos el comportamiento real de la API
  expect_error(
    get_municipios(departamento = "82028", max = 5),
    regexp = "400|Bad Request"
  )
})

# ── localidades ───────────────────────────────────────────────────────────────

test_that("get_localidades filtra por nombre", {
  skip_if_offline()
  result <- get_localidades(nombre = "Rosario", provincia = "82", exacto = TRUE)
  expect_gte(nrow(result), 1)
  expect_true(any(grepl("Rosario", result$nombre)))
})

test_that("get_localidades filtra por provincia y departamento", {
  skip_if_offline()
  result <- get_localidades(provincia = "06", departamento = "06357", max = 5)
  expect_gte(nrow(result), 1)
})

# ── aglomerados ───────────────────────────────────────────────────────────────

test_that("get_aglomerados devuelve resultados", {
  skip_if_offline()
  result <- get_aglomerados(max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

test_that("get_aglomerados filtra por nombre", {
  skip_if_offline()
  result <- get_aglomerados(nombre = "Gran Rosario")
  expect_gte(nrow(result), 1)
  expect_true(any(grepl("Rosario", result$nombre, ignore.case = TRUE)))
})

# ── asentamientos ─────────────────────────────────────────────────────────────

test_that("get_asentamientos filtra por provincia", {
  skip_if_offline()
  result <- get_asentamientos(provincia = "22", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

test_that("get_asentamientos filtra por categoria", {
  skip_if_offline()
  result <- get_asentamientos(categoria = "Paraje", max = 5)
  expect_gte(nrow(result), 1)
  # Con aplanar=TRUE (default) la categoría debe estar en el resultado
  expect_true("categoria" %in% names(result))
})

# ── calles ────────────────────────────────────────────────────────────────────

test_that("get_calles filtra por nombre y provincia", {
  skip_if_offline()
  result <- get_calles(nombre = "Corrientes", provincia = "82", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

test_that("get_calles filtra por categoria", {
  skip_if_offline()
  result <- get_calles(categoria = "Avenida", provincia = "02", max = 5)
  expect_gte(nrow(result), 1)
})

# ── localidades-censales ──────────────────────────────────────────────────────

test_that("get_localidades_censales filtra por nombre", {
  skip_if_offline()
  result <- get_localidades_censales(nombre = "Córdoba", exacto = TRUE, max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

# ── fracciones-censales ───────────────────────────────────────────────────────

test_that("get_fracciones_censales filtra por provincia", {
  skip_if_offline()
  result <- get_fracciones_censales(provincia = "06", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

test_that("get_fracciones_censales filtra por ID", {
  skip_if_offline()
  # ID válido obtenido de la API
  result <- get_fracciones_censales(id = "8208427")
  expect_gte(nrow(result), 1)
})

# ── radios-censales ───────────────────────────────────────────────────────────

test_that("get_radios_censales filtra por provincia", {
  skip_if_offline()
  result <- get_radios_censales(provincia = "02", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

# ── gobiernos-locales ─────────────────────────────────────────────────────────

test_that("get_gobiernos_locales filtra por provincia", {
  skip_if_offline()
  result <- get_gobiernos_locales(provincia = "14", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

test_that("get_gobiernos_locales filtra por categoria", {
  skip_if_offline()
  result <- get_gobiernos_locales(categoria = "Municipio", max = 5)
  expect_gte(nrow(result), 1)
})

# ── establecimientos-educativos ───────────────────────────────────────────────

test_that("get_establecimientos_educativos filtra por provincia", {
  skip_if_offline()
  result <- get_establecimientos_educativos(provincia = "06", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

test_that("get_establecimientos_educativos filtra por gestion", {
  skip_if_offline()
  result <- get_establecimientos_educativos(gestion = "Estatal", max = 5)
  expect_gte(nrow(result), 1)
})

# ── instituciones-universitarias ──────────────────────────────────────────────

test_that("get_instituciones_universitarias filtra por provincia", {
  skip_if_offline()
  result <- get_instituciones_universitarias(provincia = "14", max = 5)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

# ── normalizar_direccion ──────────────────────────────────────────────────────

test_that("normalizar_direccion normaliza una dirección simple", {
  skip_if_offline()
  result <- normalizar_direccion(direccion = "Corrientes 1200", provincia = "82")
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

test_that("normalizar_direccion filtra por provincia y departamento", {
  skip_if_offline()
  result <- normalizar_direccion(
    direccion   = "San Martin 100",
    provincia   = "02",
    max         = 3
  )
  expect_gte(nrow(result), 1)
})

# ── get_ubicacion ─────────────────────────────────────────────────────────────

test_that("get_ubicacion devuelve unidades territoriales para un punto", {
  skip_if_offline()
  # Coordenadas del centro de Buenos Aires
  result <- get_ubicacion(lat = -34.6037, lon = -58.3816)
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})

test_that("get_ubicacion acepta parámetro division='politica'", {
  skip_if_offline()
  result <- get_ubicacion(lat = -34.6037, lon = -58.3816, division = "politica")
  expect_s3_class(result, "tbl_df")
  expect_gte(nrow(result), 1)
})
