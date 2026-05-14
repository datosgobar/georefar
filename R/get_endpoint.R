get_endpoint <- function(endpoint, args) {

  token <- Sys.getenv("GEOREFAR_TOKEN")
  check_internet()

  # Validación de parámetros
  args_clean <- Filter(Negate(is.null), args)
  valid_params <- VALID$PARAMS[[endpoint]]
  errores <- c()

  ## Agregar NAs a vector de errores si existen
  has_na <- any(vapply(args_clean, function(x) any(is.na(x)), logical(1)))
  if (has_na) {
    na_params <- names(args_clean)[vapply(args_clean, function(x) any(is.na(x)), logical(1))]
    errores <- c(
      errores,
      sprintf(
        ERR_MSGS$get_endpoint$NA_PARAMS,
        paste(na_params, collapse = ", ")
      )
    )
  }

  ## Agregar inválidos a vector de errores si existen
  param_names <- names(args_clean)
  valores_invalidos <- setdiff(param_names, valid_params)
  if (length(valores_invalidos) > 0) {
    errores <- c(
      errores,
      sprintf(
        ERR_MSGS$get_endpoint$INVALID_PARAMS,
        endpoint,
        paste(valores_invalidos, collapse = ", ")
      )
    )
  }

  ## Lanzar error si hay problemas
  if (length(errores) > 0) {
    stop("Error en la consulta:\n ", paste(errores, collapse = "\n "), call. = FALSE)
  }

  req <- httr2::request(paste0(base_url, endpoint)) |>
    httr2::req_url_query(!!!args_clean) |>
    httr2::req_error(is_error = ~ httr2::resp_status(.x) != 200,
              body = httr2_error_handler)

  if (!is.null(token) && token != "") {
    req <- req |> httr2::req_auth_bearer_token(token)
  }

  response <- httr2::req_perform(req)

  parsed <- httr2::resp_body_json(response)

  data_list <- parsed[[gsub(pattern = "-", replacement = "_", x = endpoint)]]

  if (is.null(data_list)) {
    data_list <- list()
  }

  data <- purrr::modify_if(data_list, is.null, list)

  if (length(data) == 0) {
    warning(ERR_MSGS$get_endpoint$EMPTY_RESPOSE, call. = FALSE)
  }

  data |>
    dplyr::bind_rows() |>
    dplyr::as_tibble(.name_repair = function(x) {gsub(pattern = "\\$|\\.", replacement = "_", x = x)})
}
