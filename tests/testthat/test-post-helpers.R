test_that("check_list_of_lists acepta lista de listas válida", {
  expect_silent(check_list_of_lists(list(list(nombre = "a"), list(nombre = "b"))))
})

test_that("check_list_of_lists lanza error si no es lista de listas", {
  expect_error(check_list_of_lists(c("a", "b")))
  expect_error(check_list_of_lists(list("a", "b")))
  expect_error(check_list_of_lists("texto"))
})

test_that("check_list_of_lists emite warning con lista vacía", {
  expect_warning(check_list_of_lists(list()), regexp = "vac")
})

test_that("create_query_batches devuelve lista vacía para input vacío", {
  result <- create_query_batches(list())
  expect_equal(length(result), 0)
})

test_that("create_query_batches agrupa correctamente bajo el límite", {
  queries <- replicate(5, list(nombre = "test"), simplify = FALSE)
  result  <- create_query_batches(queries, max_queries_per_batch = 10)
  expect_equal(length(result), 1)
  expect_equal(length(result[[1]]), 5)
})

test_that("create_query_batches divide cuando supera max_queries_per_batch", {
  queries <- replicate(15, list(nombre = "test"), simplify = FALSE)
  result  <- create_query_batches(queries, max_queries_per_batch = 10)
  expect_equal(length(result), 2)
  expect_equal(length(result[[1]]), 10)
  expect_equal(length(result[[2]]), 5)
})

test_that("create_query_batches divide cuando la suma de 'max' supera el límite", {
  # 3 queries de max=2000 → suma=6000 > 5000, debe dividir
  queries <- replicate(3, list(max = 2000), simplify = FALSE)
  result  <- create_query_batches(
    queries,
    max_queries_per_batch = 1000,
    max_sum_of_a_param    = 5000,
    param_name_for_sum    = "max"
  )
  expect_gte(length(result), 2)
})

test_that("create_query_batches respeta exactamente el límite de suma", {
  # 2 queries de max=2500 → suma=5000 = límite, debe caber en 1 lote
  queries <- replicate(2, list(max = 2500), simplify = FALSE)
  result  <- create_query_batches(
    queries,
    max_queries_per_batch = 1000,
    max_sum_of_a_param    = 5000,
    param_name_for_sum    = "max"
  )
  expect_equal(length(result), 1)
})

test_that("create_query_batches ignora param_name_for_sum si es NULL", {
  queries <- replicate(3, list(max = 9999), simplify = FALSE)
  result  <- create_query_batches(
    queries,
    max_queries_per_batch = 1000,
    max_sum_of_a_param    = 5000,
    param_name_for_sum    = NULL
  )
  # Sin suma, todo entra en un lote
  expect_equal(length(result), 1)
})

test_that("create_query_batches preserva todas las queries", {
  n       <- 25
  queries <- lapply(seq_len(n), function(i) list(nombre = paste0("q", i)))
  result  <- create_query_batches(queries, max_queries_per_batch = 10)
  total   <- sum(sapply(result, length))
  expect_equal(total, n)
})
