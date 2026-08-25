skip_if_not_installed("mockery")

test_that("get_endpoint lanza error con parámetro NA", {
  mockery::stub(get_endpoint, "check_internet", invisible)
  expect_error(
    get_endpoint("provincias", list(nombre = NA)),
    regexp = "NA"
  )
})

test_that("get_endpoint lanza error con parámetro inválido", {
  mockery::stub(get_endpoint, "check_internet", invisible)
  expect_error(
    get_endpoint("provincias", list(parametro_falso = "x")),
    regexp = "no reconocido"
  )
})

test_that("get_endpoint lanza error con múltiples parámetros inválidos", {
  mockery::stub(get_endpoint, "check_internet", invisible)
  expect_error(
    get_endpoint("provincias", list(foo = "a", bar = "b")),
    regexp = "no reconocido"
  )
})

test_that("get_endpoint descarta parámetros NULL antes de validar", {
  # NULL se descarta → no debe lanzar error por parámetro inválido
  mockery::stub(get_endpoint, "check_internet", invisible)
  
  fake_resp <- structure(
    list(status_code = 200, body = chartr("", "", "")),
    class = "httr2_response"
  )
  
  mock_perform <- mockery::mock(fake_resp)
  mock_body    <- mockery::mock(list(provincias = list(list(id = "06", nombre = "Buenos Aires"))))
  
  mockery::stub(get_endpoint, "httr2::req_perform",   mock_perform)
  mockery::stub(get_endpoint, "httr2::resp_body_json", mock_body)
  
  # nombre = NULL debe descartarse sin error
  expect_no_error(
    get_endpoint("provincias", list(nombre = NULL, max = 1))
  )
})

test_that("get_endpoint emite warning cuando la respuesta está vacía", {
  mockery::stub(get_endpoint, "check_internet", invisible)
  
  mockery::stub(get_endpoint, "httr2::req_perform",    mockery::mock(structure(list(), class = "httr2_response")))
  mockery::stub(get_endpoint, "httr2::resp_body_json", mockery::mock(list(provincias = list())))
  
  expect_warning(
    get_endpoint("provincias", list(max = 1)),
    regexp = "vac"
  )
})

test_that("get_endpoint devuelve tibble con columnas esperadas para provincias", {
  mockery::stub(get_endpoint, "check_internet", invisible)
  
  fake_data <- list(
    list(id = "06", nombre = "Buenos Aires",
         centroide = list(lat = -36.6, lon = -60.5))
  )
  mockery::stub(get_endpoint, "httr2::req_perform",    mockery::mock(structure(list(), class = "httr2_response")))
  mockery::stub(get_endpoint, "httr2::resp_body_json", mockery::mock(list(provincias = fake_data)))
  
  result <- get_endpoint("provincias", list(max = 1))
  
  expect_s3_class(result, "tbl_df")
  expect_true("id"     %in% names(result))
  expect_true("nombre" %in% names(result))
})

test_that("get_endpoint usa token Bearer si GEOREFAR_TOKEN está definido", {
  mockery::stub(get_endpoint, "check_internet", invisible)
  
  captured_req <- NULL
  mockery::stub(get_endpoint, "httr2::req_perform", function(req) {
    captured_req <<- req
    structure(list(), class = "httr2_response")
  })
  mockery::stub(get_endpoint, "httr2::resp_body_json", mockery::mock(list(provincias = list())))
  
  withr::with_envvar(c(GEOREFAR_TOKEN = "mi-token-secreto"), {
    suppressWarnings(get_endpoint("provincias", list(max = 1)))
  })
  
  # httr2 almacena el header Authorization (aunque lo muestra como REDACTED)
  expect_true(
    "Authorization" %in% names(captured_req$headers),
    info = "El header Authorization no fue incluido en el request"
  )
})

test_that("get_endpoint NO agrega Authorization si GEOREFAR_TOKEN está vacío", {
  mockery::stub(get_endpoint, "check_internet", invisible)
  
  captured_req <- NULL
  mockery::stub(get_endpoint, "httr2::req_perform", function(req) {
    captured_req <<- req
    structure(list(), class = "httr2_response")
  })
  mockery::stub(get_endpoint, "httr2::resp_body_json", mockery::mock(list(provincias = list())))
  
  withr::with_envvar(c(GEOREFAR_TOKEN = ""), {
    suppressWarnings(get_endpoint("provincias", list(max = 1)))
  })
  
  expect_false(
    "Authorization" %in% names(captured_req$headers),
    info = "El header Authorization no debería estar presente sin token"
  )
})

test_that("prepare_post_batch_request incluye Authorization si GEOREFAR_TOKEN está definido", {
  withr::with_envvar(c(GEOREFAR_TOKEN = "mi-token-post"), {
    req <- prepare_post_batch_request("provincias", list(list(nombre = "test")))
  })
  expect_true("Authorization" %in% names(req$headers))
})

test_that("prepare_post_batch_request NO incluye Authorization si GEOREFAR_TOKEN está vacío", {
  withr::with_envvar(c(GEOREFAR_TOKEN = ""), {
    req <- prepare_post_batch_request("provincias", list(list(nombre = "test")))
  })
  expect_false("Authorization" %in% names(req$headers))
})