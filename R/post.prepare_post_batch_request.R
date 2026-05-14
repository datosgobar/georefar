prepare_post_batch_request <- function(endpoint, single_batch_queries_list) {
  token <- Sys.getenv("GEOREFAR_TOKEN")
  url <- paste0(base_url, endpoint)

  # La API espera la clave del body con guiones bajos, no guiones medios.
  # Algunos endpoints tienen claves irregulares (plural distinto al nombre del endpoint).
  body_key_map <- c(ubicacion = "ubicaciones")
  base_key <- gsub("-", "_", endpoint)
  body_key <- if (base_key %in% names(body_key_map)) body_key_map[[base_key]] else base_key

  body_data <- list()
  body_data[[body_key]] <- single_batch_queries_list

  req <- httr2::request(url) |>
    httr2::req_method("POST") |>
    httr2::req_body_json(data = body_data, auto_unbox = TRUE) |>
    httr2::req_error(is_error = ~ httr2::resp_status(.x) != 200, body = httr2_error_handler)

  if (!is.null(token) && token != "") {
    req <- req |> httr2::req_auth_bearer_token(token)
  }

  return(req)
}
