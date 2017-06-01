

initData <- dataGen()[[1]]
nam <- data.frame(nombres())
nombre <- nam$nombre[match(input$field, nam$nombre2)]
info <- initData[, which(names(dataGen()[[1]]) %in% nombre)]
info <- data.frame(info)

names(info)[1] <- "a"  


piegraph <- function(dataCat, titleLabel = "", fillLabel = ""){
  
  filter1 <- group_by(.data = dataCat, by = a)
  dataCat2 <- summarize(filter1, count = n())
  dataCat2$prop <- dataCat2$count/sum(dataCat2$count)
  dataCat2 <- arrange(dataCat2, desc(prop))
  names(dataCat2)[1] <- "a"  
  dataCat2$a <- as.character(dataCat2$a)
  dataCat2$a[dataCat2$prop < 0.1] <- "OTROS"
  
  
  filter1 <- group_by(dataCat2, a)
  dataCat2 <- summarize(filter1, count = sum(count), prop = sum(prop))
  dataCat2$prop2 <- paste(round(dataCat2$prop*100, 1), "%")
  
  
  
  graph <- ggplot(data=dataCat2, aes(x=factor(1), y=prop, fill=factor(a), label = prop2)) +
    geom_bar(stat="identity", width = 1) +
    coord_polar(theta = "y") +
    geom_text(position = position_stack(vjust = 0.5), size=5) +
    labs(title = titleLabel, fill = fillLabel, x = "", y = "") + theme_bw() + 
    theme(panel.grid=element_blank()) +
    theme(axis.text=element_blank()) + 
    theme(axis.ticks=element_blank()) + 
    theme_void()
  
  return(graph)
}


#Despliegue de gráfica

graph1 <- piegraph(info)

