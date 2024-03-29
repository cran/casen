#' Armoniza los codigos de regiones
#' @description Convierte las etiquetas de las regiones para usar de manera 
#' uniforme los nombres de CASEN 2017. El procedimiento consiste en buscar la 
#' columna \code{r} (antes del anio 2000) o \code{region} (desde el anio 2000) 
#' y aplicar expresiones regulares de acuerdo a la codificacion respectiva.
#' @param d una encuesta CASEN en formato tibble o data.frame
#' @importFrom magrittr %>%
#' @importFrom rlang sym
#' @importFrom dplyr mutate select case_when
#' @importFrom labelled to_factor
#' @return un tibble con la columna de region transformada
#' @examples 
#' \dontrun{
#' casen1990 <- readRDS("casen1990.rds")
#' armonizar_region(casen1990)
#' }
#' @export
armonizar_region <- function(d) {
  if (any("r" %in% colnames(d))) {
    d <- d %>% 
      dplyr::mutate(
        !!sym("r") := as.character(labelled::to_factor(!!sym("r")))
      ) %>% 
      dplyr::mutate(
        !!sym("r") := dplyr::case_when(
          r == "I" ~ "Tarapac\u00e1",
          r == "II" ~ "Antofagasta",
          r == "III" ~ "Atacama",
          r == "IV" ~ "Coquimbo",
          r == "V" ~ "Valpara\u00edso",
          r == "VI" ~ "O'Higgins",
          r == "VII" ~ "Maule",
          r == "VIII" ~ "Biob\u00edo",
          r == "IX" ~ "La Araucan\u00eda",
          r == "X" ~ "Los Lagos",
          r == "XI" ~ "Ays\u00e9n",
          r == "XII" ~ "Magallanes",
          r == "R.M." ~ "Metropolitana",
          TRUE ~ r
        )
      ) %>% 
      dplyr::mutate(!!sym("r") := as.factor(!!sym("r")))
  }
  
  if (any("region" %in% colnames(d))) {
    d <- d %>% 
      dplyr::mutate(
        !!sym("region") := as.character(labelled::to_factor(!!sym("region")))
      ) %>% 
      dplyr::mutate(
        !!sym("region") := gsub("^.*\\. ", "", !!sym("region")),
        !!sym("region") := gsub("^Regi\u00f3n de |^Regi\u00f3n del |^Regi\u00f3n ", "", !!sym("region"))
      ) %>% 
      dplyr::mutate(
        !!sym("region") := dplyr::case_when(
          !!sym("region") == "Tarapaca" ~ "Tarapac\u00e1",
          grepl("Higgins", !!sym("region")) ==  TRUE ~ "O'Higgins",
          grepl("del Campo", !!sym("region")) ==  TRUE ~ "Ays\u00e9n",
          grepl("Metropolitana", !!sym("region")) == TRUE ~ "Metropolitana",
          grepl("Magallanes", !!sym("region")) ==  TRUE ~ "Magallanes",
          TRUE ~ !!sym("region")
        )
      ) %>% 
      dplyr::mutate(!!sym("region") := as.factor(!!sym("region")))
  }
  
  return(d)
}

#' Armoniza los codigos de oficio
#' @description Convierte las etiquetas de los oficios para usar de manera 
#' uniforme los nombres de CASEN 2017, debiendo fusionar algunas categorias
#' que se intersectan (ejemplo: "Directivos de la Adm. Publica y Empresas" con
#' "Miembros del Poder Ejecuivo, Legislativo y Directivos de la Adm. Publica").
#' El procedimiento consiste en buscar la columna \code{oficio} (antes del anio 
#' 2011) u \code{oficio1} (desde el anio 2011) y aplicar expresiones regulares 
#' de acuerdo a la codificacion respectiva.
#' @param d una encuesta CASEN en formato tibble o data.frame
#' @importFrom magrittr %>%
#' @importFrom rlang sym
#' @importFrom dplyr mutate select everything case_when rename
#' @importFrom labelled to_factor
#' @return un tibble con la columna de oficio transformada
#' @examples 
#' \dontrun{
#' casen1990 <- readRDS("casen1990.rds")
#' armonizar_oficio(casen1990)
#' }
#' @export
armonizar_oficio <- function(d) {
  marca_oficio <- any("oficio" %in% colnames(d))
  
  if (marca_oficio) {
    d <- d %>% 
      dplyr::rename(!!sym("oficio1") := !!sym("oficio"))
  }
  
  d <- d %>% 
    dplyr::mutate(
      !!sym("oficio1") := as.character(labelled::to_factor(!!sym("oficio1")))
    ) %>% 
    dplyr::mutate(
      !!sym("oficio1") := tolower(!!sym("oficio1")),
      !!sym("oficio1") := gsub("\\b([[:lower:]])([[:lower:]]+)", "\\U\\1\\L\\2", !!sym("oficio1"), perl = TRUE)
    ) %>% 
    dplyr::mutate(
      !!sym("oficio1") := gsub("\\s+", " ", !!sym("oficio1")),
      !!sym("oficio1") := gsub(" De ", " de ", !!sym("oficio1")),
      !!sym("oficio1") := gsub(" Del ", " del ", !!sym("oficio1")),
      !!sym("oficio1") := gsub(" Y ", " y ", !!sym("oficio1")),
      !!sym("oficio1") := gsub(" y y ", " y ", !!sym("oficio1"))
    ) %>% 
    dplyr::mutate(
      !!sym("oficio1") := gsub("^Oficiales, Operarios.*", "Oficiales, Operarios y Artesanos de Artes Mec\u00e1nicas y de Otros Oficios", !!sym("oficio1")),
      !!sym("oficio1") := gsub("^Operadores y Montadores.*|^Operadores de Inst.*", "Operadores y Montadores de Instalaciones y Maquinaria", !!sym("oficio1")),
      !!sym("oficio1") := gsub("^Prof.*", "Profesionales, Cient\u00edficos e Intelectuales", !!sym("oficio1")),
      !!sym("oficio1") := gsub("^Trabajadores de Los Servicios.*|^Trab\\. de Servicios.*|^Vendedores.*|^Comerciantes.*", "Trabajadores de Servicio y Vendedores", !!sym("oficio1")),
      !!sym("oficio1") := gsub("T\u00e9cnicos y Pro.*|^Tecnicos.*|^t\u00e9Cnicos.*", "T\u00e9cnicos Profesionales de Nivel Medio", !!sym("oficio1")),
      !!sym("oficio1") := gsub("^Miembros del Poder.*|^Miembros Poder.*|^Miembro Poder.*|^Directivos.*", "Miembros del Poder Ejecutivo, Legislativo y Directivos de la Administraci\u00f3n P\u00fablica o Empresas", !!sym("oficio1")),
      !!sym("oficio1") := gsub("Ff\\.Aa\\.", "Fuerzas Armadas", !!sym("oficio1")),
      !!sym("oficio1") := gsub("^Fuerzas.*", "Fuerzas Armadas", !!sym("oficio1")),
      !!sym("oficio1") := gsub("^Empleados Ofi.*", "Empleados de Oficina", !!sym("oficio1")),
      !!sym("oficio1") := gsub("^Directivos de Adm.*", "Directivos de la Administraci\u00f3n P\u00fablica y Empresas", !!sym("oficio1")),
      !!sym("oficio1") := gsub("^Agri.*", "Agricultores y Trabajadores Calificados Agropecuarios y Pesqueros", !!sym("oficio1"))
    )
  
  d <- d %>% 
    dplyr::mutate(
      !!sym("oficio1") := gsub("^s/r/*|^Sin Resp.*|^Ocupacion No.*|^Sin Dato.*", NA, !!sym("oficio1"))
    )
  
  d <- d %>% 
    dplyr::mutate(!!sym("oficio1") := as.factor(!!sym("oficio1")))
  
  if (marca_oficio) {
    d <- d %>% 
      dplyr::rename(!!sym("oficio") := !!sym("oficio1"))
  }
  
  return(d)
}

#' Armoniza los codigos de rama ocupacional
#' @description Convierte las etiquetas de la rama ocupacional para usar de 
#' manera uniforme los nombres de CASEN 2017, debiendo fusionar algunas
#' categorias que se intersectan (ejemplo: "Establecimientos Financieros" y
#' "Servicios de Gobierno y Financieros").
#' El procedimiento consiste en buscar la columna \code{rama} (antes del anio 
#' 2011) o \code{rama1} (desde el anio 2011) y aplicar expresiones regulares 
#' de acuerdo a la codificacion respectiva.
#' @param d una encuesta CASEN en formato tibble o data.frame
#' @importFrom magrittr %>%
#' @importFrom rlang sym
#' @importFrom dplyr mutate select everything case_when rename
#' @importFrom labelled to_factor
#' @return un tibble con la columna de rama transformada
#' @examples 
#' \dontrun{
#' casen1990 <- readRDS("casen1990.rds")
#' armonizar_rama(casen1990)
#' }
#' @export
armonizar_rama <- function(d) {
  marca_rama <- any("rama" %in% colnames(d))
  
  if (marca_rama) {
    d <- d %>% 
      dplyr::rename(!!sym("rama1") := !!sym("rama"))
  }
  
  d <- d %>% 
    dplyr::mutate(
      !!sym("rama1") := as.character(labelled::to_factor(!!sym("rama1")))
    ) %>% 
    dplyr::mutate(
      !!sym("rama1") := tolower(!!sym("rama1")),
      !!sym("rama1") := gsub("^[a-z]\\. |^[a-z]\\.|^[a-z] ", "", !!sym("rama1")),
      !!sym("rama1") := gsub("^\\s", "", !!sym("rama1")),
      !!sym("rama1") := gsub("\\b([[:lower:]])([[:lower:]]+)", "\\U\\1\\L\\2", !!sym("rama1"), perl = TRUE)
    ) %>% 
    dplyr::mutate(
      !!sym("rama1") := gsub("\\s+", " ", !!sym("rama1")),
      !!sym("rama1") := gsub(" De ", " de ", !!sym("rama1")),
      !!sym("rama1") := gsub(" Del ", " del ", !!sym("rama1")),
      !!sym("rama1") := gsub(" Y ", " y ", !!sym("rama1")),
      !!sym("rama1") := gsub(" y y ", " y ", !!sym("rama1"))
    ) %>% 
    dplyr::mutate(
      !!sym("rama1") := gsub("^Act\\. No.*|^Actividades No.*", NA, !!sym("rama1")),
      !!sym("rama1") := gsub("^Agri.*|^Pesca.*", "Agricultura, Caza, Silvicultura y Pesca", !!sym("rama1")),
      !!sym("rama1") := gsub("^Adminis.*", "Administraci\u00f3n P\u00fablica, Defensa y Seguridad Social", !!sym("rama1")),
      !!sym("rama1") := gsub("^Comercio.*|^Hoteles.*", "Comercio Mayorista/Minorista, Restaurantes y Hoteles", !!sym("rama1")),
      !!sym("rama1") := gsub("^Constru.*", "Construcci\u00f3n", !!sym("rama1")),
      !!sym("rama1") := gsub("^Electricidad.*|^Suministro.*", "Electricidad, Gas y Agua", !!sym("rama1")),
      !!sym("rama1") := gsub("^Estab.*|^Servicios de Gob.*|^Intermed.*|^Admin.*", "Servicios de Gobierno y Financieros/Seguros", !!sym("rama1")),
      !!sym("rama1") := gsub("^Explo.*", "Explotaci\u00f3n de Minas y Canteras", !!sym("rama1")),
      !!sym("rama1") := gsub("^Ind.*", "Industrias Manufactureras", !!sym("rama1")),
      !!sym("rama1") := gsub("^Servicios Comunales.*|^Servicios Sociales.*|^Organizaciones.*|^Actividades In.*|^Ense.*|^Hogares.*|^Otras Activ.*|^Servicios Pers.*", "Servicios Comunitarios, Sociales y Personales", !!sym("rama1")),
      !!sym("rama1") := gsub("^Transporte.*", "Transporte, Almacenamiento y Comunicaciones", !!sym("rama1"))
    )
  
  d <- d %>% 
    dplyr::mutate(
      !!sym("rama1") := gsub("^s/r/*|^Sin Resp.*|^Sin Dato.*|^No Bien.*|^Ocupacion No.*", NA, !!sym("rama1"))
    )
  
  d <- d %>% 
    dplyr::mutate(!!sym("rama1") := as.factor(!!sym("rama1")))
  
  if (marca_rama) {
    d <- d %>% 
      dplyr::rename(!!sym("rama") := !!sym("rama1"))
  }
  
  return(d)
}

