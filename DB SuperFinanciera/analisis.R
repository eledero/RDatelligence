#Abrir librerías
library(readxl)
library(ggplot2)
library(dplyr)

#



#Descargar archivo

url  <- paste0("http://www.supersociedades.gov.co/asuntos-economicos-y-contables/", 
"estudios-y-supervision-por-riesgos/SIREM/Documents/2015.zip")
file <- "datos.zip"
download.file(url, file)


#Descomprimir archivo
unzip(file)

setwd("2015") 
source("source.R")
files <- c("BalanceGeneral2015SIREMV2.xls", "EstadoResultados2015SIREMV2.xls", "FlujoEfectivo2015SIREMV2.xls")
data  <- lapply(files, read_excel, 1)

balSheet <- data[[1]]; balSheet <- as.data.frame(balSheet[balSheet$CIUDAD == "BOGOTA D.C.  ", ])
profLoss <- data[[2]]; profLoss <- as.data.frame(profLoss[profLoss$CIUDAD == "BOGOTA D.C.  ", ])
cashFlow <- data[[3]]; cashFlow <- as.data.frame(cashFlow[cashFlow$CIUDAD == "BOGOTA D.C.  ", ])

dataCat <- balSheet$SECTOR ; dataCat <- as.data.frame(dataCat) ; names(dataCat) <- "sector"





makeGroup <- function(introData) arrange(top_n(summarise(group_by(dataCat, sector), count = n()), n = 20), desc(count))
ggplot(makeGroup(balSheet), aes(x = sector, y = count, fill = sector)) +
  stat_summary(fun.y = sum, geom = "bar") +
  theme_bw() +
  theme(axis.text.x=element_blank(),axis.ticks.x=element_blank()) +
  labs(y = "# de empresas", title = "Top 20 sectores", fill = "Sector")



dataInic <- balSheet[,c(1:6, 52, 60, 161, 233) ]
dataInic2 <- cashFlow[, c(1:6, 67)]
dataInic$pruebaAcida <- (dataInic$`TOTAL ACTIVO CORRIENTE` - dataInic$`14 SUBTOTAL INVENTARIOS (CP)`)/dataInic$`TOTAL PASIVO CORRIENTE`
total <- merge(dataInic, dataInic2, by="NIT")
finalDataset <- total[(total$pruebaAcida > 0) & (total$`TOTAL - AUMENTO (DISMINUCION) DEL EFECTIVO`) > 0, ]
empresasMalas <- total[(total$pruebaAcida < 0) | (total$`TOTAL - AUMENTO (DISMINUCION) DEL EFECTIVO`) < 0, ]



dataCat <- empresasMalas$SECTOR.x ; dataCat <- as.data.frame(dataCat) ; names(dataCat) <- "sector"


ggplot(makeGroup(dataCat), aes(x = sector, y = count, fill = sector)) +
  stat_summary(fun.y = sum, geom = "bar") +
  theme_bw() +
  theme(axis.text.x=element_blank(),axis.ticks.x=element_blank()) +
  labs(y = "# de empresas", title = "Top 20 sectores", fill = "Sector")


juzgar <- total[!is.na(total$mala), ]

grupo <- group_by(juzgar, SECTOR.x, mala)

propMalas <- summarise(grupo, count = n(), sum = sum(mala))

propMalas <- summarise(propMalas, empMalas = sum(sum), totalEmp = sum(count))

propMalas$prop <- propMalas$empMalas/propMalas$totalEmp

datosMalas <- arrange(top_n(propMalas, n = 20), desc(prop))


