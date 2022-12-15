#FIJAR DIRECTORIO 
setwd("ubicación")

#CARGAR LIBRERIAS
library(mapview)
library(sp)

#LEER DATOS DE SUELO Y AMBIENTE DE FORMACION DE SUELOS
datos <- read.csv('datosuelo.csv', sep = ';', dec = '.')
predictores <- readRDS('predictores.rds')

#DEFINIR COORDENADAS A DATOS DE SUELO (NOMBRES DE CAMPOS)
coordinates(datos) <- ~ X + Y

#DEFINIR PROYECCION ESPACIAL (GEOGRAFICAS PARA ESTE CASO)
proj4string(datos) <- CRS('+proj=longlat +datum=WGS84 +no_defs')

#SI LA INFROMACION NO ES EXCLUSIVA DEL AREA DE ESTUDIO, EXTRAER INFORMACION DE SUELO SUPERPUESTA ESPACIALMENTE CON LAS COVARIABLES AMBIENTALES
predictores <- readRDS('predictores.rds')
datos <- datos[predictores,]

#VER EN UN MAPA BASE
mapview(datos['SAL'])

#GUARDAR EL NUEVO ARCHIVO GENERADO
saveRDS(datos, file= 'obssuelo.rds')
