#CARGAR LIBRERIAS
library(rgdal)
library(raster)
library(FactoMineR)
#DEFINIR DIRECTORIO DE TRABAJO
setwd("ubicación")
#CARGAR DATOS DE COVARIABLES AMBIENTALES
covar <- readRDS("predictores_Ha.rds") 
#OMITIR VALORES FALTANTES
covar <- sp.na.omit(covar)
#Realizar el PCA
fit <- prcomp(scale(covar@data))

#RESUMEN DE PCA
summary(fit)

#COMBINAR LOS PC CON LAS COVARIABLES
covar@data <- cbind(covar@data, data.frame(fit$x))

#CARGAR DATOS DE SUELO
dat <- readRDS('obssuelo.rds')

#APLICAR CONVERSION LOGARITMICA
#dat$SAL <- log1p(dat$SAL)

#ARMONIZADO A UNA MISMO SISTEMA DE REFERENCIA
dat <- spTransform(dat, CRS(projection(covar)))

#CARGAR LIBRERIAS PARA AJUSTE Y PREDICCION 
library(GSIF)
library(aqp)
library(gstat)
library(randomForest)
library(plotKML)

#OBTENER NOMBRES DE LA COVARIABLES
names(covar)

#DEFINIR LO TÉRMINOS DEL MODELO (p.ej componentes principales), PUEDEN SER TAMBIEN COVARIABLES.
fm <- SAL ~ PC1+PC2+PC3+PC4

#AJUSTE DE LOS MODELOS, EN EL ARGUMENTO “method” SE ESPECIFICA EL MODELO PUDIENDO SUTITUR “GLM” (MODELOS LINEAL GENERALIZADO) por “RandomForest”, ARBOLES DE DECISION “rpart” U OTRO TIPO, CONSIDERADO CARGAR LA LIBRERIA CORRESPONDIENTE CONSIDERANDO LA NATURALEZA DEL PROBLEMA ABORDADO.
omm <- fit.gstatModel(dat, fm, covar, method="GLM")

#omm <- fit.gstatModel(dat, fm, covar, method="RandomForest")

#REALIZAR PREDICCION Y CALCULO DE LA INCERTIDUBRE DE PREDICCION
om.rk <-predict(omm, covar) 

#OBTENER LOS PARAMETROS DE LA PREDICCION (MAX Y MIN CORREPONDEN A LAS OBSERVACIONES, NO A LAS PREDICCIONES)
print(om.rk)

#GRAFICOS EN ORDEN: PREDICCION DEL MODELO, OBSERVADOS VS PREDICHOS (DE LA VALIDACION CRUZADA), VARIOGRAMA EXPERIMENTAL Y VARIOGRAMA DE LA VARIABLE + RESIDUOS
plot(om.rk)

#GRAFICOS EN ORDEN: PREDICCION DEL MODELO, DESVIACION ESTANDAR DE LA VARIANZA, VARIANZA Y PREDICCION+RESIDUOS
plot(stack(om.rk@predicted))

#GRAFICO EN GOOGLE EARTH
plotKML(om.rkRF)

#GUARDAR PREDICCIONES EN FORMA DE ARCHIVO RASTER. BANDAS ORDENADAS: 1)Predicción del modelo, 2) desviación estándar de la varianza, 3)varianza y 4) predicción final (predicción + residuos)
writeRaster(stack(om.rkGLM@predicted),file='PREDICCIONSALI.tif')

#CARGAR LAS PREDICCIONES 
prediccionsal <- stack('PREDICCIONSALI.tif')

#CONVERTIR A UN SPATIALPIXELSDATAFRAME
prediccionsal <- as(prediccionsal, 'SpatialPixelsDataFrame')
#RESUMEN DE LAS PREDICCIONES	
summary(prediccionesal)

     
