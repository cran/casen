#' Descarga la encuesta CASEN del sitio web del Ministerio de Desarrollo Social
#' @description Obtiene los archivos de la encuesta en formato RAR o ZIP segun
#' el anio de la encuesta. No descomprime ni modifica los datasets originales.
#' @param anios si no se indica un anio, descarga todos los anios disponibles
#' @param carpeta se debe especificar una carpeta de descarga
#' @importFrom utils download.file
#' @importFrom glue glue
#' @return Los archivos comprimidos de la encuesta CASEN descargados desde el
#' sitio web del Ministerio de Desarrollo Social.
#' @examples
#' # descargar CASEN 1990 en carpeta temporal
#' \donttest{descargar_casen_mds(1990, tempdir())}
#' @export
descargar_casen_mds <- function(anios = NULL, carpeta = NULL) {
  # checks ----
  stopifnot(is.numeric(anios) | is.null(anios))
  stopifnot(is.character(carpeta), !is.null(carpeta), length(carpeta) == 1)

  # download ----
  suppressWarnings(try(dir.create(carpeta)))

  all_years <- c(seq(1990, 2000, 2), seq(2003, 2009, 3), seq(2011, 2017, 2))

  if (!is.null(anios) & any(anios %in% all_years) == FALSE) {
    stop("La encuesta CASEN esta disponible entre los anios 1990 y 2017")
  }
    
  if (is.null(anios)) {
    anios <- c(seq(1990, 2000, 2), seq(2003, 2009, 3), seq(2011, 2017, 2))
  }

  urls <- c(
    paste0(
      "http://observatorio.ministeriodesarrollosocial.gob.cl/casen/layout/doc/bases/Casen",
      seq(1990, 1994, 2),
      ".zip"
    ),
    "http://observatorio.ministeriodesarrollosocial.gob.cl/casen/layout/doc/bases/Casen1996.rar",
    paste0(
      "http://observatorio.ministeriodesarrollosocial.gob.cl/casen/layout/doc/bases/Casen",
      seq(1998, 2000, 2),
      ".zip"
    ),
    "http://observatorio.ministeriodesarrollosocial.gob.cl/casen/layout/doc/bases/Casen2003.zip",
    "http://observatorio.ministeriodesarrollosocial.gob.cl/casen/layout/doc/bases/casen2006.zip",
    "http://observatorio.ministeriodesarrollosocial.gob.cl/casen/layout/doc/bases/Casen2009spss.rar",
    "http://observatorio.ministeriodesarrollosocial.gob.cl/casen/layout/doc/bases/casen2011_octubre2011_enero2012_principal_08032013spss.rar",
    "http://observatorio.ministeriodesarrollosocial.gob.cl/documentos/CASEN_2013_MN_B_Principal_spss.rar",
    "http://observatorio.ministeriodesarrollosocial.gob.cl/casen-multidimensional/casen/docs/casen_2015_spss.rar",
    "http://observatorio.ministeriodesarrollosocial.gob.cl/casen-multidimensional/casen/docs/casen_2017_spss.rar"
  )

  links <- data.frame(
    year = all_years,
    url = urls,
    file = paste0(carpeta, "/", all_years, "_spss", gsub(".*\\.", "\\.", urls)),
    stringsAsFactors = FALSE
  )

  links <- links[links$year %in% anios, ]

  for (j in 1:nrow(links)) {
    u <- links$url[[j]]
    f <- links$file[[j]]
    y <- links$year[[j]]
    
    if (!file.exists(f)) {
      message(glue::glue("Intentando descargar CASEN {y}..."))
      try(utils::download.file(u, f, mode = "wb"))
    } else {
      message(glue::glue("CASEN {y} ya existe, se omite la descarga"))
    }
  }
}

#' Descarga la encuesta CASEN de GitHub
#' @description Obtiene los archivos de la encuesta en formato R.
#' @param anios si no se indica un anio, descarga todos los anios disponibles
#' @param carpeta se debe especificar una carpeta de descarga
#' @importFrom utils download.file
#' @importFrom glue glue
#' @return Los archivos rds de la encuesta CASEN descargados desde GitHub.
#' @examples
#' # descargar CASEN 1990 en carpeta temporal
#' descargar_casen_github(1990, tempdir())
#' @export
descargar_casen_github <- function(anios = NULL, carpeta = NULL) {
  # checks ----
  stopifnot(is.numeric(anios) | is.null(anios))
  stopifnot(is.character(carpeta), !is.null(carpeta), length(carpeta) == 1)
  
  # download ----
  suppressWarnings(try(dir.create(carpeta)))
  
  all_years <- c(seq(1990, 2000, 2), seq(2003, 2009, 3), seq(2011, 2017, 2))
  
  if (!is.null(anios) & any(anios %in% all_years) == FALSE) {
    stop("La encuesta CASEN esta disponible entre los anios 1990 y 2017")
  }
  
  if (is.null(anios)) {
    anios <- c(seq(1990, 2000, 2), seq(2003, 2009, 3), seq(2011, 2017, 2))
  }
  
  urls <- glue::glue("https://pachamaltese.github.io/casen/data-rds/{all_years}.rds")
  
  links <- data.frame(
    year = all_years,
    url = urls,
    file = paste0(carpeta, "/", all_years, gsub(".*\\.", "\\.", urls)),
    stringsAsFactors = FALSE
  )
  
  links <- links[links$year %in% anios, ]
  
  for (j in 1:nrow(links)) {
    u <- links$url[[j]]
    f <- links$file[[j]]
    y <- links$year[[j]]
    
    if (!file.exists(f)) {
      message(glue::glue("Intentando descargar CASEN {y}..."))
      try(utils::download.file(u, f, mode = "wb"))
    } else {
      message(glue::glue("CASEN {y} ya existe, se omite la descarga"))
    }
  }
}
