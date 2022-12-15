#FIJAR DIRECTORIO DE TRABAJO
setwd("ubicación/de/capa/raster")
#CARGAR LIBERIA NECESARIA
library(raster)
#IMPORTAR LAS CAPAS AMBIENTALES APILADAS
covar <- readRDS('predictores.rds')
#CONVERTIR EL .rds a un RASTER MULTIBANDA
covar <- stack(covar)
#REPROYECTAR EL RASTER P.EJ: SISTEMA GTM Y RESOLUCION DE 100 m
covar <-projectRaster(covar, crs='+proj=tmerc +lat_0=0 +lon_0=-90.5 +k=0.9998 +x_0=500000 +y_0=0 +ellps=WGS84 +units=m +no_defs', res = 100)
#GUARDAMOS A LA VEZ QUE COERCIONAMOS NUEVAMENTE A UN “SpatialPixelsDataFrame”
saveRDS(as(covar,'SpatialPixelsDataFrame'), file= 'predictores_Ha.rds')
