#Paquetes a cargar
library(ggplot2)
library(dplyr)




#Declaración de funciones
firstup <- function(x) {
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}


#Configura el Working Directory
setwd("~/Documents/RUNT")

#Lee el archivo CSV
initData <- read.csv(dir()[1], 
                     sep = ";")

#Fechas inicial y final
fechaIni <- as.Date("2010-02-01")
fechaFin <- Sys.Date()


#Procesamiento de datos para fecha
initData$month <- firstup(unique(tolower(initData$MONTH_)))
conv <- data.frame(month = firstup(unique(tolower(initData$MONTH_))),
                   monthNum = 1:length(firstup(unique(tolower(initData$MONTH_)))))
initData <- merge(initData, 
                  conv, 
                  by = "month") 
initData$date <- as.Date(paste(initData$ANO, 
                               initData$monthNum, 
                               "01", 
                               sep = "/"), 
                         format = "%Y/%m/%d")

#Filtrado por fechas
initData <- initData[initData$date >= fechaIni, ]
initData <- initData[initData$date <= fechaFin, ]


#Alistamiento de datos para gráfica
filter1 <- group_by(initData, MARCA, MODELO)
graphData <- summarize(filter1, 
                       total = sum(CANTIDAD))
#Generación de gráfica
graph1 <- ggplot(graphData, 
                 aes(x = MODELO, 
                     y = total, 
                     color = MARCA)) + 
          geom_point() +
          theme_bw() + theme(legend.position="bottom") 

#Despliegue de gráfica
graph1

