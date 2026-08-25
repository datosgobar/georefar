skip_if_not_installed("mockery")

test_that("replace_null_with_na reemplaza NULL por NA en lista plana", {
  input  <- list(a = 1, b = NULL, c = "x")
  result <- replace_null_with_na(input)
  expect_equal(result$a, 1)
  expect_true(is.na(result$b))
  expect_equal(result$c, "x")
})
test_that("replace_null_with_na trabaja recursivamente", {
  input  <- list(a = list(b = NULL, c = 2), d = NULL)
  result <- replace_null_with_na(input)
  expect_true(is.na(result$a$b))
  expect_equal(result$a$c, 2)
  expect_true(is.na(result$d))
})
test_that("replace_null_with_na devuelve NA para NULL directo", {
  expect_true(is.na(replace_null_with_na(NULL)))
})
test_that("replace_null_with_na no modifica valores no-NULL", {
  expect_equal(replace_null_with_na(42), 42)
  expect_equal(replace_null_with_na("texto"), "texto")
  expect_equal(replace_null_with_na(TRUE), TRUE)
})
test_that("check_internet lanza error sin internet", {
  mockery::stub(check_internet, "curl::has_internet", FALSE)
  expect_error(check_internet(), "internet")
})
test_that("check_internet no lanza error con internet disponible", {
  mockery::stub(check_internet, "curl::has_internet", TRUE)
  expect_silent(check_internet())
})
test_that("httr2_error_handler genera mensaje con status y URL", {
  mock_resp <- list(
    status  = 404,
    url     = "https://apis.datos.gob.ar/georef/api/v2.0/provincias",
    has_body = FALSE
  )
  # Simular un httr2_response mínimo
  fake_resp <- structure(mock_resp, class = "httr2_response")
  mockery::stub(httr2_error_handler, "httr2::resp_status",      function(r) 404)
  mockery::stub(httr2_error_handler, "httr2::resp_status_desc", function(r) "Not Found")
  mockery::stub(httr2_error_handler, "httr2::resp_url",         function(r) "https://apis.datos.gob.ar/georef/api/v2.0/provincias")
  mockery::stub(httr2_error_handler, "httr2::resp_has_body",    function(r) FALSE)
  expect_error(httr2_error_handler(fake_resp), "404")
  expect_error(httr2_error_handler(fake_resp), "Not Found")
})