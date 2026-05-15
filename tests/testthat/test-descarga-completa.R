skip_if_offline <- function() {
  skip_if_not(curl::has_internet(), "Sin acceso a internet")
}

test_that("get_geodata_dump lanza error con entidad inválida", {
  expect_error(get_geodata_dump("entidad_falsa", "json"), "v.lida")
})

test_that("get_geodata_dump lanza error con formato inválido", {
  expect_error(get_geodata_dump("provincias", "xml"), "v.lido")
})

test_that("get_geodata_dump descarga provincias en CSV como data.frame", {
  skip_if_offline()
  result <- get_geodata_dump("provincias", "csv")
  expect_s3_class(result, "data.frame")
  expect_gte(nrow(result), 24)
  expect_true("nombre" %in% tolower(names(result)))
})

test_that("get_geodata_dump descarga provincias en JSON como lista", {
  skip_if_offline()
  result <- get_geodata_dump("provincias", "json")
  expect_true(is.list(result))
})

test_that("get_geodata_dump guarda archivo en disco con path_to_save", {
  skip_if_offline()
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp))
  path_result <- get_geodata_dump("provincias", "csv", path_to_save = tmp)
  expect_true(file.exists(tmp))
  expect_equal(path_result, tmp)
  expect_gt(file.size(tmp), 0)
})

test_that("get_geodata_dump acepta entidades válidas (smoke test CSV)", {
  skip_if_offline()
  # provincias es la entidad más pequeña y siempre disponible
  result <- get_geodata_dump("provincias", "csv")
  expect_s3_class(result, "data.frame")
  expect_gte(nrow(result), 24)
})
