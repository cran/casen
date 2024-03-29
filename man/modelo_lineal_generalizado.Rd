% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inference.R
\name{modelo_lineal_generalizado}
\alias{modelo_lineal_generalizado}
\title{Modelo lineal generalizado con disenio complejo}
\usage{
modelo_lineal_generalizado(disenio, modelo = "ytotcorh ~ sexo")
}
\arguments{
\item{disenio}{la salida de `configuracion_disenio()` que provee ademas los
grupos y las variables en forma de lista}

\item{modelo}{una expresion simbolica escrita como cadena de texto, consulta
[stats::formula()] para los detalles de modelos con componentes logaritmicas,
cuadraticas, etc.}
}
\value{
Una lista cuyas clases son svyglm, glm y lm.
}
\description{
Usa los factores de expansion, conglomerados y estratos para
ajustar un modelo lineal generalizado con las variables definidas por el
usuario.
}
\examples{
cd <- configuracion_disenio(casen_2017_los_rios, "ytotcorh", c("comuna", "sexo"), "expc")
modelo_lineal_generalizado(cd, "ytotcorh ~ comuna + sexo")
}
