# Devuelve texto adicional para el mensaje de error de httr2.
# IMPORTANTE: httr2::req_error(body = ) espera que esta funcion DEVUELVA un
# vector de caracteres, no que lance un error. Si lanza, httr2 lo envuelve en
# "Failed to parse error body with method defined in req_error()" y oculta el
# mensaje real de la API.
httr2_error_handler <- function(resp) {
  info <- paste0(
    "API request failed: ",
    httr2::resp_status_desc(resp), " (", httr2::resp_status(resp), "). ",
    "URL: ", httr2::resp_url(resp)
  )

  error_body_text <- tryCatch({
    if (httr2::resp_has_body(resp) &&
        grepl("json|text|xml", httr2::resp_content_type(resp), ignore.case = TRUE)) {
      body_content <- httr2::resp_body_string(resp, encoding = "UTF-8")
      if (nchar(body_content) < 500) paste0("API Response: ", body_content) else NULL
    } else {
      NULL
    }
  }, error = function(e) NULL)

  c(info, error_body_text)
}
