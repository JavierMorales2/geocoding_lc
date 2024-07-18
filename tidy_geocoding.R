# Autor: Javier Morales C.
# Objetivo: Georreferenciar direcciones
# Fecha: Noviembre, 2024
# Departamento de Innovación, SECPLAN

# Librerías ---------------------------------------------------------------
library(tidygeocoder)  # Para geocodificación
library(sf)            # Para manejo de datos espaciales
library(mapview)       # Para visualización de mapas interactivos
library(tidyverse)     # Para manipulación y visualización de datos
library(furrr)         # Para paralelización de funciones
library(tictoc)        # Para medir el tiempo de ejecución
library(readxl)        # Para leer archivos Excel

# Carga de Datos ----------------------------------------------------------
# Lectura del archivo Excel que contiene las direcciones a georreferenciar
data <- read_excel("talleres_example.xlsx") 
address_df <- data

# Preparación de Datos ----------------------------------------------------
# Añadir un identificador único a cada registro
address_df <- tibble::rowid_to_column(address_df, "ID")

# Convertir la columna de direcciones a una lista para su uso con furrr
address_list <- address_df$address %>% as.list()

# Configuración de Procesamiento Paralelo ---------------------------------
# Configurar el plan de ejecución paralela utilizando todos los núcleos disponibles menos uno
future::plan(strategy = "multisession", workers = availableCores() - 1)

# Proceso de Geocodificación ----------------------------------------------
# Iniciar medición del tiempo de ejecución
tic()

# Realizar la geocodificación en paralelo utilizando el método 'arcgis'
address_geodata <- furrr::future_map(
  .x = address_list, 
  ~ tidygeocoder::geo(address = .x, method = 'arcgis', lat = lat , long = long)
) %>% 
  # Combinar los resultados en un único dataframe
  dplyr::bind_rows()

# Finalizar medición del tiempo de ejecución
toc()

# Unión de Datos ----------------------------------------------------------
address_geodata <- tibble::rowid_to_column(address_geodata, "ID")
address_df_geo <- address_df %>% 
  left_join(address_geodata %>% select(ID, lat, long), by = "ID")

# Eliminar duplicados y asegurar una sola columna 'address'
address_df_geo_f <- address_df_geo %>%
  dplyr::distinct() %>%
  dplyr::select(-contains("address.")) %>%  # Elimina columnas que contengan "address."
  dplyr::rename(address = address)  # Renombra la columna original de dirección si es necesario

# Visualización de Resultados ---------------------------------------------
address_df_geo_f %>% 
  dplyr::filter(!is.na(lat)) %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  mapview(legend = FALSE)

# Exportación de Resultados -----------------------------------------------
write_csv2(address_df_geo_f, "talleres_2024_example.csv")
write_xlsx(address_df_geo_f, "talleres_2024_example.xlsx")

# Nota: Para guardar como shapefile, descomentar la siguiente línea:
# st_write(address_df_geo_f, "resultado/resultado.shp")
