
#Extracción de datos del CSV
initData <- read.csv("ReporteTraficoSalas-2016-07-03.csv")



#Procesar datos
filter1 <- group_by(initData, dia_semana, fecha)
graphData <- summarise(filter1, count = n())
filter2 <- group_by(graphData, dia_semana)
initData <- summarise(filter2, prom = mean(count))
initData$prom <- round(initData$prom, 1)


#Gráfica
grafica <- ggplot(initData, aes(x=factor(dia_semana), y=prom, fill = factor(dia_semana))) + 
  stat_summary(fun.y="mean", geom="bar") +
  
  aes(label = prom) +
  labs(title = "Promedio de carros", x = "Dia de la semana", y = "Promedio de autos", fill = "Dia de la semana") +
  theme(panel.background = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())



grafica <- grafica + geom_text(aes(y = prom + 0.1), position = position_dodge(0.9), vjust = 0)

grafica
