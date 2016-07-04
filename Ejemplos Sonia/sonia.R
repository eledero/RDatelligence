library(dplyr)
library(ggplot2)

####Manera # 1####

autos <- round(runif(35, 0, 10), 0)

dia <- rep(c("Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"), times = 5)

initData <- data.frame(dia, autos)

grafica <- ggplot(initData, aes(x=factor(dia), y=autos, fill = factor(dia))) + 
  stat_summary(fun.y="mean", geom="bar") +
  
  aes(label = autos) +
  labs(title = "Promedio de carros", x = "Día de la semana", y = "Promedio de autos", fill = "Día de la semana") +
  theme(panel.background = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())



grafica <- grafica + geom_text(position = position_dodge(0.9))


####Manera # 2####


autos <- round(runif(35, 0, 10), 0)
dia <- rep(c("Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"), times = 5)
initData <- data.frame(dia, autos)


filter1 <- group_by(initData, dia)
graphData <- summarise(filter1, prom = mean(autos))



grafica2 <- ggplot(graphData, aes(x=factor(dia), y=prom, fill = factor(dia))) +
            stat_summary(fun.y="sum", geom="bar") +
            aes(label = prom) +
            labs(title = "Promedio de carros", x = "Día de la semana", y = "Promedio de autos", fill = "Día de la semana")

  #+ theme(panel.background = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())

grafica2 <- grafica2 + geom_text(aes(y = prom + 0.05), position = position_dodge(0.9), vjust = 0)
grafica2 <- grafica2 + theme(panel.background = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())
grafica2


