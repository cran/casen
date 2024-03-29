#' Disenio complejo para estadistica descriptiva e inferencia
#' @description Usa los factores de expansion, conglomerados y estratos para
#' definir un objeto de disenio complejo.
#' @param datos un data.frame o tibble con la encuesta CASEN (o un subconjunto
#' acotado a una region, etc)
#' @param variable una columna de tipo numerico, por ejemplo ytotcorh que es la
#' opcion por defecto
#' @param agrupacion una columna de tipo texto/factor, por ejemplo region que
#' es la opcion por defecto
#' @param peso una columna de tipo numerico, por defecto es expr que corresponde
#' al factor de expansion regional de acuerdo al manual CASEN 2017
#' @param conglomerado una columna de tipo numerico, por defecto es varunit de
#' acuerdo al manual CASEN 2017
#' @param estrato una columna de tipo numerico, por defecto es varunit de
#' acuerdo al manual CASEN 2017
#' @return Una lista con el disenio y los grupos.
#' @examples
#' cd <- configuracion_disenio(casen_2017_los_rios, "ytotcorh", c("comuna", "sexo"), "expc")
#' cd$disenio
#' cd$grupos
#' @export
configuracion_disenio <- function(datos, variable = "ytotcorh", agrupacion = "region", peso = "expr", conglomerado = "varunit", estrato = "varstrat") {
  # checks ----
  check_input(datos, variable, agrupacion, peso, conglomerado, estrato)

  # compute ----
  d <- clean_data(datos, variable, agrupacion, peso, conglomerado, estrato)

  return(
    list(
      disenio = create_design(d, variable, agrupacion, peso, conglomerado, estrato),
      grupos = unique_groups(d, agrupacion),
      variable = variable,
      agrupacion = agrupacion,
      peso = peso,
      conglomerado = conglomerado,
      estrato = estrato
    )
  )
}
