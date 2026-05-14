skip_if_offline <- function() {
  skip_if_not(curl::has_internet(), "Sin acceso a internet")
}

test_that("get_geodata_dump lanza error con entidad inválida", {
  expect_error(
    get_geodata_dump(entidad = "entidad_falsa", formato = "json"),
    regexp = "Entidad no v.lida",
    ignore.case = TRUE
  )
})

test_that("get_geodata_dump lanza error con formato inválido", {
  expect_error(
    get_geodata_dump(entidad = "provincias", formato = "xlsx"),
    regexp = "Formato no v.lido",
    ignore.case = TRUE
  )
})

test_that("get_geodata_dump descarga provincias en CSV como data.frame", {
  skip_if_offline()
  result <- get_geodata_dump(entidad = "provincias", formato = "csv")
  expect_s3_class(result, "data.frame")
  expect_gt(nrow(result), 0)
  expect_true("nombre" %in% tolower(names(result)))
})

test_that("get_geodata_dump descarga provincias en JSON como lista", {
  skip_if_offline()
  result <- get_geodata_dump(entidad = "provincias", formato = "json")
  expect_true(is.list(result))
})

test_that("get_geodata_dump guarda archivo en disco con path_to_save", {
  skip_if_offline()
  tmp <- tempfile(fileext = ".csv")
  withr::defer(unlink(tmp))
  result <- get_geodata_dump(entidad = "provincias", formato = "csv", path_to_save = tmp)
  expect_true(file.exists(tmp))
  expect_gt(file.size(tmp), 0)
  expect_equal(result, tmp)
})

test_that("get_geodata_dump descarga ndjson como lista de elementos", {
  skip_if_offline()
  result <- get_geodata_dump(entidad = "provincias", formato = "ndjson")
  expect_true(is.list(result))
  expect_gt(length(result), 0)
  # Cada elemento debe ser una lista (objeto JSON)
  expect_true(is.list(result[[1]]))
})
