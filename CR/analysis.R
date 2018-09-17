library(ggplot2)
library(dplyr)
library(tidyr)
library(ggrepel)
setwd("~/RDatelligence/CR")
initTable = read.csv(dir()[grepl("Costa", dir())]) %>%
  gather(key, value, -X) %>%
  arrange(key, X)

initTable$value = gsub(",", "", initTable$value) %>% 
  as.numeric()
names(initTable) = c("Año", "Variable", "Valor")

####################################################
#1#
####################################################

variables = c("Cienc.Salud.U.Pb", "Cienc.Soc.U.Pb")
ggplot(initTable[initTable$Variable %in% variables, ]) + aes(x = Año, y = Valor) + geom_line(aes(color = Variable)) + labs(x = "Año", y = "Valor", legend = "", title = "Evolución de variables.") + theme(legend.position="bottom", legend.box = "vertical", legend.title = element_blank())

####################################################
#2#
####################################################

varScatter = c("Cienc.Salud.U.Pb", "Cienc.Soc.U.Pb")
scatterData = cbind(initTable[which(initTable$Variable == varScatter[1]), ], initTable[which(initTable$Variable == varScatter[2]), "Valor"])
names(scatterData) = c("Año", "key", varScatter[1], varScatter[2])
ggplot(scatterData, aes_string(varScatter[1], varScatter[2], label = "Año")) + geom_point() + geom_text_repel(size = 2.5) + labs(title = "Análisis cruzado de variables.")


