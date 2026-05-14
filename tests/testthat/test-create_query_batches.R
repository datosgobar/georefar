test_that("create_query_batches devuelve lista vacía con input vacío", {
  expect_equal(create_query_batches(list()), list())
})

test_that("create_query_batches agrupa consultas en un solo lote si caben", {
  queries <- replicate(5, list(nombre = "test", max = 10), simplify = FALSE)
  batches <- create_query_batches(queries)
  expect_length(batches, 1)
  expect_length(batches[[1]], 5)
})

test_that("create_query_batches divide cuando se supera max_queries_per_batch", {
  queries <- replicate(5, list(nombre = "test"), simplify = FALSE)
  batches <- create_query_batches(queries, max_queries_per_batch = 2)
  expect_length(batches, 3)  # 2 + 2 + 1
  expect_length(batches[[1]], 2)
  expect_length(batches[[2]], 2)
  expect_length(batches[[3]], 1)
})

test_that("create_query_batches divide cuando se supera max_sum_of_a_param", {
  # Cada consulta pide max=3000, el límite de suma es 5000 → 1 por lote
  queries <- replicate(3, list(max = 3000), simplify = FALSE)
  batches <- create_query_batches(
    queries,
    max_queries_per_batch = 1000,
    max_sum_of_a_param = 5000,
    param_name_for_sum = "max"
  )
  expect_length(batches, 3)
})

test_that("create_query_batches respeta ambos límites simultáneamente", {
  # 4 consultas con max=1000, límite suma=2500 → lotes de 2 (suma=2000 < 2500)
  queries <- replicate(4, list(max = 1000), simplify = FALSE)
  batches <- create_query_batches(
    queries,
    max_queries_per_batch = 1000,
    max_sum_of_a_param = 2500,
    param_name_for_sum = "max"
  )
  expect_length(batches, 2)
})

test_that("create_query_batches ignora param_name_for_sum si es NULL", {
  queries <- replicate(3, list(max = 9999), simplify = FALSE)
  batches <- create_query_batches(queries, param_name_for_sum = NULL)
  expect_length(batches, 1)
})

test_that("create_query_batches maneja consultas sin el parámetro de suma", {
  queries <- list(list(nombre = "a"), list(nombre = "b"), list(nombre = "c"))
  batches <- create_query_batches(queries, max_queries_per_batch = 2, param_name_for_sum = "max")
  expect_length(batches, 2)
})
