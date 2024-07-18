# Script de Georreferenciación para Talleres en Las Condes

Este repositorio contiene un script en R diseñado para georreferenciar direcciones de talleres en la comuna de Las Condes, Chile. El script utiliza varias librerías de R para procesar un archivo Excel de entrada, realizar la geocodificación de las direcciones y exportar los resultados.

## Requisitos

- R (versión recomendada: 4.0.0 o superior)
- RStudio (recomendado para una fácil ejecución del script)

## Librerías Necesarias

Asegúrate de tener instaladas las siguientes librerías:

```r
install.packages(c("tidygeocoder", "sf", "mapview", "tidyverse", "furrr", "tictoc", "readxl"))
```

## Preparación del Archivo Excel

El script espera un archivo Excel en el mismo directorio. Este archivo debe contener una columna llamada "address" con las direcciones a georreferenciar.

**Importante**: La columna "address" debe seguir el siguiente formato:

```
{dirección}, Las Condes, Chile
```

Por ejemplo:
```
Av. Apoquindo 3400, Las Condes, Chile
```

Asegúrate de que todas las direcciones en la columna "address" sigan este formato para obtener los mejores resultados de geocodificación.

## Ejecución del Script

1. Coloca el archivo `.xlsx` en el mismo directorio que el script R.
2. Abre el script en RStudio.
3. Ejecuta el script línea por línea o todo de una vez.

## Funcionalidad del Script

El script realiza las siguientes operaciones:

1. Carga las librerías necesarias.
2. Lee el archivo Excel de entrada.
3. Prepara los datos para la geocodificación.
4. Configura el procesamiento paralelo para mejorar la eficiencia.
5. Realiza la geocodificación de las direcciones utilizando el servicio de ArcGIS.
6. Une los resultados de la geocodificación con los datos originales.
7. Visualiza los resultados en un mapa interactivo.
8. Exporta los resultados en formatos CSV y Excel.

## Resultados

El script generará dos archivos de salida:

- `resultado.csv`: Archivo CSV con los resultados de la geocodificación.
- `resultado.xlsx`: Archivo Excel con los resultados de la geocodificación.

Además, se mostrará un mapa interactivo en RStudio con las ubicaciones geocodificadas.

## Autor

Javier Morales J.
