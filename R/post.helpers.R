check_list_of_lists <- function(queries_list) {
  if (!is.list(queries_list) || !all(sapply(queries_list, is.list))) {
    stop(ERR_MSGS$helpers$NOT_LIST_OF_LISTS)
  }
  if (length(queries_list) == 0) {
    warning(ERR_MSGS$helpers$EMPTY_QUERY_LIST, call. = FALSE)
    return(dplyr::tibble())
  }
}

check_params <- function(endpoint, query) {
  valid_params <- VALID$PARAMS[[endpoint]]
  invalid_params <- setdiff(names(query), valid_params)

  if (length(invalid_params) > 0) {
    warning(
      sprintf(
        ERR_MSGS$post$BULK_POST_REQUESTS$INVALID_PARAMS,
        which(sapply(query, identical, query[[names(query)[1]]])),
        endpoint
      ),
      paste(invalid_params, collapse = ", "),
      call. = FALSE
    )
  }
}

check_max <- function(query, i = 1) {
  current_max   <- query$max
  current_inicio <- query$inicio

  if (!is.null(current_max) && (!is.numeric(current_max) || current_max < 0 || current_max > LIMIT_MAX)) {
    stop(sprintf(ERR_MSGS$post$BULK_POST_REQUESTS$MAX_PARAM, i, LIMIT_MAX), call. = FALSE)
  }
  if (!is.null(current_inicio) && (!is.numeric(current_inicio) || current_inicio < 0)) {
    stop(sprintf(ERR_MSGS$post$BULK_POST_REQUESTS$INICIO_PARAM, i), call. = FALSE)
  }
  if (!is.null(current_max) && !is.null(current_inicio) && (current_max + current_inicio > LIMIT_MAX_INICIO)) {
    stop(sprintf(ERR_MSGS$post$BULK_POST_REQUESTS$MAX_INICIO_SUM, i, LIMIT_MAX_INICIO), call. = FALSE)
  }
}
