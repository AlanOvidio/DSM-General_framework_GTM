#CARGAR LIBRERIAS NECESARIAS
library(aqp)
library(GSIF)
library(mapview)
library(rgdal)
library(mapview)
library(raster)

#FIJAR DIRECTORIO Y LEER DATOS DE SUELO Y AMBIENTE DE FORMAICON DE SUELOS
setwd("ubicación")
datos <- read.csv('datosuelo.csv', sep = ';', dec = '.')
predictores <- readRDS('predictores.rds')

#EXTRAER INFO DE SUELOS EN AREA DE PREDICTORES
datos <- datos[predictores,]

#CONVERTIR A UN MARCO DE DATOS O “DATAFRAME”
datos <- data.frame(datos)
#CREAR UN IDENTIFICADOR UNICO EN UN NUEVO CAMPO
datos$ID<-paste0("ID_", datos$X, "_", datos$Y)

#GENERAR UN OBJETO DE CLASE “SOILPROFILECOLLECTION”
#definir profundidades (nombres de campos)
depths(datos) <- ID ~ limsuperior + liminferior

#Horizonte (nombre del campo)
hzdesgnname(datos) <- 'horizonte'

#sitio
site(datos) <- ~ X + Y
#DEFINR COORDENADAS
coordinates(datos) <- ~ X + Y
#GENERAR UN DATAFRAME VACIO
datos30cm <- data.frame()
#INICIAR UN CICLO PARA AJUSTAR A LA PROFUNIDAD X
for(i in 1:length(datos)){
  #Aplicar spline de suavizado de conservación de masas (en este caso 0-30 cm)
  try(SAL <- mpspline(datos[i], 'SAL', d = t(c(0,30)))) 
  #Almacenar en un dataframe el valor ajustado
  dat <- data.frame(id = datos[i]@site$ID,
                    X = datos[i]@sp@coords[,1],
                    Y = datos[i]@sp@coords[,2],
                    SAL = SAL$var.std[,1])
  #Almacenar la sucesión de valores ajustados calculados
  datos30cm <- rbind(datos30cm, dat) 
  #cerrar ciclo
}
#DEFINIR COORDENADAS A LOS DATOS AJUSTADOS
coordinates(datos30cm) <- ~ X+Y
#DEFINIR PROYECCION ESPACIAL
proj4string(datos30cm) <- CRS("+proj=longlat +datum=WGS84 +no_defs")
#VER EN UN MAPA BASE
mapview(datos30cm['SAL'])
#GUARDAR EL NUEVO ARCHIVO GENERADO
saveRDS(datos30cm, file='obssuelo.rds')
