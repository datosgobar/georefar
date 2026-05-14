process_single_post_response <- function(response_obj, endpoint, batch_size) {
  # Usar el texto JSON crudo para poder aplanar con jsonlite::fromJSON(flatten=TRUE)
  raw_json <- httr2::resp_body_string(response_obj, encoding = "UTF-8")
  parsed_content <- jsonlite::fromJSON(raw_json, flatten = TRUE)

  if (!"resultados" %in% names(parsed_content)) {
    url_info <- tryCatch(httr2::resp_url(response_obj), error = function(e) "unknown URL")
    stop(paste0("La respuesta del POST para '", endpoint, "' (URL: ", url_info,
                ") no contiene el campo 'resultados' esperado."), call. = FALSE)
  }

  results_df <- parsed_content$resultados

  # La API devuelve las claves con guiones bajos aunque el endpoint use guiones medios.
  # El endpoint 'ubicacion' usa 'ubicaciones' en el body del request pero devuelve 'ubicacion' en la respuesta.
  data_key <- gsub("-", "_", endpoint)

  # results_df puede ser un data.frame (cuando fromJSON aplana) o una lista
  if (is.data.frame(results_df)) {
    col_name <- data_key
    if (col_name %in% names(results_df)) {
      # Caso normal: hay una columna con el nombre del endpoint (lista de data.frames)
      all_rows <- lapply(results_df[[col_name]], function(df) {
        if (is.null(df) || (is.data.frame(df) && nrow(df) == 0)) return(dplyr::tibble())
        if (is.data.frame(df)) return(dplyr::as_tibble(df))
        dplyr::tibble()
      })
      result <- dplyr::bind_rows(all_rows)
    } else if (any(startsWith(names(results_df), paste0(col_name, ".")))) {
      # Caso aplanado total (ej: ubicacion): las columnas ya están en results_df con prefijo
      result <- dplyr::as_tibble(results_df)
    } else {
      warning(paste0("Campo '", col_name, "' no encontrado en 'resultados' para '", endpoint, "'."), call. = FALSE)
      return(dplyr::tibble())
    }
  } else {
    # Fallback: lista de listas
    actual_data_items_list <- lapply(results_df, function(x) x[[data_key]])
    result <- tryCatch({
      dplyr::bind_rows(lapply(actual_data_items_list, function(items) {
        if (is.null(items) || length(items) == 0) return(dplyr::tibble())
        if (is.data.frame(items)) return(dplyr::as_tibble(items))
        dplyr::tibble()
      }))
    }, error = function(e) {
      warning(paste0("Error al combinar resultados de '", endpoint, "': ", e$message), call. = FALSE)
      dplyr::tibble()
    })
  }

  # Limpiar nombres de columnas
  if (ncol(result) > 0) {
    names(result) <- gsub("\\$|\\.", "_", names(result))
  }

  if (nrow(result) == 0 && batch_size > 0) {
    warning(paste0("Una tanda de ", batch_size, " consultas POST para '", endpoint,
                   "' devolvió una lista vacía o no se pudieron procesar sus resultados."), call. = FALSE)
  }

  return(result)
}
