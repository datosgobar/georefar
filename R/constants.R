# API Limits for batch POST requests
GEOREFAR_API_MAX_QUERIES_PER_BATCH <- 1000
GEOREFAR_API_MAX_SUM_MAX_PARAM_PER_BATCH <- 5000
LIMIT_MAX <- 5000
LIMIT_MAX_INICIO <- 10000

# Base URL de la API de georef-ar
base_url <- "https://apis.datos.gob.ar/georef/api/v2.0/"

# URL base para descargas completas (sin version, endpoint diferente al de la API)
DUMP_BASE_URL <- "https://apis.datos.gob.ar/georef/api/"

#' Mensajes de error
ERR_MSGS <- list(
  
  # Mensajes de error para get_endpoint
  helpers = list(
    NOT_LIST_OF_LISTS = "'queries_list' debe ser una lista de listas.",
    EMPTY_QUERY_LIST = "'queries_list' est\u00e1 vac\u00eda, no se realizar\u00e1n consultas."
  ),
  
  
  # Mensajes de error para get_endpoint
  get_endpoint = list(
    NA_PARAMS         = "GET no admite NAs. Los par\u00e1metros siguientes tienen NAs:%s",
    EMPTY_QUERY       = "La consulta devolvi\u00f3 una lista vac\u00eda",
    BAD_STATUS        = "El servidor respondi\u00f3 con estado %d",
    INVALID_PARAMS    = "Par\u00e1metro(s) no reconocido(s) para el endpoint '%s': %s.",
    EMPTY_RESPOSE     = "La consulta devolvi\u00f3 una lista vac\u00eda"
  ),
  
  # Mensajes de error para POST por lotes
  post = list(
    BULK_POST_REQUESTS = list(
      NO_BATCHES_CREATED    = "No se pudieron crear lotes de consultas para '%s', aunque la lista de consultas no estaba vac\u00eda.",
      INVALID_PARAMS        = "Consulta %d en 'queries_list' para %s contiene par\u00e1metro(s) no reconocido(s): ",
      MAX_PARAM             = "En la consulta %d, el par\u00e1metro 'max' debe ser un n\u00famero entre 0 y %d.",
      INICIO_PARAM          = "En la consulta %d, el par\u00e1metro 'inicio' debe ser un n\u00famero positivo.",
      MAX_INICIO_SUM        = "En la consulta %d, la suma de 'max' e 'inicio' no debe superar %d.",
      BASE_COMBINE_ERROR    = "La consulta POST completa para '%s' (%d consultas originales en %d lotes)",
      ERROR_LOTE            = "Error en el lote %d para '%s': %s",
      ERROR_DESCONOCIDO     = "Error desconocido o respuesta inesperada en el lote %d para '%s'. Clase del objeto: %s"
    )
  )
)

# Parametros validos por endpoint
BASE_VALID_PARAMS <- c('campos','aplanar','max','inicio','exacto','formato','orden')
UT_BASE_VALID_PARAMS <- c(BASE_VALID_PARAMS,'id','nombre')

VALID <- list(
  PARAMS = list(
    aglomerados                   = UT_BASE_VALID_PARAMS,
    
    provincias                    = c(UT_BASE_VALID_PARAMS, 'interseccion'),
    departamentos                 = c(UT_BASE_VALID_PARAMS, 'provincia','interseccion'),
    municipios                    = c(UT_BASE_VALID_PARAMS, 'provincia','departamento','interseccion'),
    "gobiernos-locales"           = c(UT_BASE_VALID_PARAMS, 'provincia','departamento','interseccion','categoria'),
    
    asentamientos                 = c(UT_BASE_VALID_PARAMS, 'provincia','departamento','gobierno_local','localidad_censal','categoria'),
    localidades                   = c(UT_BASE_VALID_PARAMS, 'provincia','departamento','gobierno_local','localidad_censal'),
    calles                        = c(UT_BASE_VALID_PARAMS, 'provincia','departamento','localidad_censal','categoria'),
    
    "localidades-censales"          = c(UT_BASE_VALID_PARAMS, 'provincia','departamento','gobierno_local'),
    "fracciones-censales"           = c(BASE_VALID_PARAMS   , 'id','provincia','departamento'),
    "radios-censales"               = c(BASE_VALID_PARAMS   , 'id','provincia','departamento','fraccion_censal'),
    
    direcciones                   = c(BASE_VALID_PARAMS   , 'provincia','departamento','localidad_censal','direccion','localidad','desplazar'),
    ubicacion                     = c('campos','aplanar','lat','lon','division'),
    
    "establecimientos-educativos"   = c(UT_BASE_VALID_PARAMS, 'provincia','departamento','gestion'),
    "instituciones-universitarias"  = c(UT_BASE_VALID_PARAMS, 'provincia','departamento','gestion')
  ),
  ENTITIES = 
    c(
      'aglomerados',
      'provincias',
      'departamentos',
      'municipios',
      'gobiernos_locales',
      'asentamientos',
      'localidades',
      'localidades_censales',
      'fracciones_censales',
      'radios_censales',
      'calles',
      'direcciones',
      'ubicacion',
      'establecimientos_educativos',
      'instituciones_universitarias'
    ),
  FORMATS = c("csv", "json", "geojson", "ndjson")
)

valid_entidades <- c(
  "provincias",
  "departamentos",
  "gobiernos-locales",
  "municipios",
  "asentamientos",
  "localidades",
  "aglomerados",
  "localidades-censales",
  "fracciones-censales",
  "radios-censales",
  "calles",
  "cuadras",
  "establecimientos-educativos",
  "instituciones-universitarias"
)

valid_formatos <- c("csv", "json", "geojson", "ndjson")