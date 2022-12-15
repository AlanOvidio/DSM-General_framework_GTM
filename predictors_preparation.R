#FIJAR DIRECTORIO DE TRABAJO
setwd("ubicación/de/capas/raster")
#CARGAR LIBERIAS NECESARIAS
library(raster)
#GENERAR UNA LISTA DE LOS RASTER (COVARIABLES PREDICTORAS)
lis <- list.files(pattern='.tif')
#LEER UN RASTER DE REFERENCIA
ref <- raster('elevation.tif')
#GENERAR UN RASTER STACK VACIO
todos_stack <- stack()
#INICIAR UN CICLO DE 1 A LA LONGITUD DE LA LISTA (n capas)
for (i in 1:length(lis)){
  ##Leer la capa i (1:n)
  refi <- raster(lis[i])
  ##Remuestrear esa capa al ráster de referencia y vecino más cercano.
  refi <- resample (refi, ref, method='ngb')
  ##Guardar la capa i en el stack
  todos_stack <- stack(todos_stack, refi)
  #Ver progreso
  print(i)
  #Cerrar Ciclo
}
#VER LOS NOMBRES EN LA NUEVA CAPA
names(todos_stack)
#CONVERTIR EN “SpatialPixelsdataframe”
todos_stack <- as(todos_stack, 'SpatialPixelsDataFrame')
#DEFINIR UNA FUNCION PARA REEPLAZAR “NA’s” POR LA MEDIAO O SEGÚN CONVENGA
NA2mean <- function(x) replace(x, is.na(x), median(x, na.rm = TRUE))
#APLICAMOS LA FUNCION A LOS DATOS DEL OBJETO
todos_stack@data[] <- lapply(todos_stack@data, NA2mean)
#GURDAMOS EL OBJETO EN FORMATO NATIVO DE R (.rds) 
saveRDS(todos_stack, file='predictores.rds')
