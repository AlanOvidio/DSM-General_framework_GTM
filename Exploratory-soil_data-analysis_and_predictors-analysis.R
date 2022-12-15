#FIJAR DIRECTORIO DE TRABAJO
setwd("ubicación")
#CARGAR LIBRERIAS NECESARIAS
library(spatialEco)
library(corrplot)
library(raster)
library(rgdal)
library(moments)
#LEER DATOS DE SUELO DE LA ETAPA ANTERIOR
datos <- readRDS('obssuelo.rds')
#LEER DATOS DE PREDICTORES 
predictores <- readRDS("predictores.rds")
#IGUALAR EL MISMO SISTEMA DE REFERENCIA DE SER NECESARIO
datos <- spTransform(datos, CRSobj = crs(predictores))
#COMPLEMETACION DE BASE DE DATOS
datos@data <- cbind(datos@data, over(datos, predictores))
#OMITIR VALORES NO DISPONIBLES/FALTANTES
datos <- sp.na.omit(datos)
#VERIFICAR ASIMETRIA Y KUTORISIS
skewness(datos@data$SAL)
kurtosis(datos@data$SAL)
#SE PUEDE GRAFICAR UN HISTOGRAMA O BOXPLOT PARA REPRESENTARLO
hist(datos@data$SAL)
boxplot(datos@data$SAL) 

#SE PUDE REALIZAR UNA TRANSPORMACION, EN ESTE CASO LOG1+X PARA COMPROBAR SI EXISTEN MEJORAS EN LA ESTRUCTURA DE LOS DATOS
datos$SALlog1p <- log1p(datos@data$SAL)

#ALGUNAS PARAMETROS DE FORMA DESCRIPTIVOS
#ASIMETRIA
skewness(datos@data$SALog1p)
#KURTOSIS
kurtosis(datos@data$SALog1p)

#ALGUNOS GRAFICOS
#HISTOGRAMA
hist(datos@data$SALlog1p)
#BOXPLOT
boxplot(datos@data$SALlog1p) 

#CREAR MATRIZ SIN LA COLUMNA DEL IDENTIFICADOR
mat <- datos@data[-1]
#CREAR MATRIZ DE CORRELACIONES
corr <- cor(mat, method='pearson')
##APROXIMAR COEFIENTES A 2 DECIMALES
corr <- round(corr, digits = 2)
#GRAFICAR MATRIZ DE CORRELACIONES
corrplot(corr)
