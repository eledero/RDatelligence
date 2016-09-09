#Circle - Area Plot
circleAreaPlot  <- function(dataCat, titl = "", xLabel = "", yLabel = "", fillLabel = "", voltear=FALSE, color = "black"){
  
  names(dataCat)[1] <- "a"
  
  filter1 <- group_by(dataCat, a)
  a <- summarise(filter1, count = n())
  a <- arrange(a, desc(count))
  p <- ggplot(a, aes(x=factor(a),y=0,size=count))
  response <- p + geom_point(colour = color) 
  
  response <- response + labs(title = titl, x = xLabel, y = yLabel)
  if(voltear){
    response <- response + coord_flip()
  }
  
  
  
  return(response)
}







#Pie chart (falta agregar labels)
#Restricciones: no más de 8 categorías.
piegraph <- function(info, titleLabel = "", fillLabel = ""){
  graph <- ggplot(data = dataCat, aes(a, fill = factor(a))) + geom_bar()
  graph <- graph + aes(x = factor(1), fill = factor(a)) + geom_bar(width = 1) + coord_polar(theta = "y")
  graph <- graph + labs(title = titleLabel, fill = fillLabel, x = "", y = "") + theme_bw()
  graph <- graph + theme(panel.grid=element_blank()) +theme(axis.text=element_blank()) + theme(axis.ticks=element_blank()) + theme_void()
  return(graph)
}