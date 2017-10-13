output$Plot1 <- renderPlot({
  
  
  #Alistamiento de datos para gráfica
  initData <- dataGen()[[1]]
  
  
  
  
  equival <- data.frame(nom1 = c("MARCA", "DEPARTAMENTO", "SERVICIO", "STATUS", "SEGMENTO", "NACIONAL_IMPORT"),
                        nom2 = c("brand", "department", "service", "status", "segment", "origin"))
  
  
  nam <- data.frame(nombres())
  nam$nombre <- as.character(nam$nombre); nam$nombre2 <- as.character(nam$nombre2)
  nombre <- nam$nombre[match(input$field, nam$nombre2)]
  campo <- as.character(equival$nom2[match(nombre, as.character(equival$nom1))])
  
  #input[[as.character(campo)]]
  
  if(!is.null(input[[as.character(campo)]])) {
    
    
    initData$newCol <- initData[, which(names(dataGen()[[1]]) %in% nombre)]
    
    filter1 <- group_by(initData, newCol, date)
    graphData <- summarize(filter1, 
                           total = sum(CANTIDAD))
    
    graph1 <- ggplot(graphData, 
                     aes(x = date, 
                         y = total, 
                         color = newCol)) + 
      geom_line() +
      theme_bw() + 
      theme(legend.position="bottom") +
      scale_x_date(date_breaks = "1 month", date_labels =  "%b %Y") +
      theme(axis.text.x=element_text(angle=60, hjust=1)) +
      labs(color = "", x = "Fecha", y = "Unidades Vendidas")
    
    #Despliegue de gráfica
    graph1
    
    
    
    
    
    
    
  } else{
    
    initData$newCol <- initData[, which(names(dataGen()[[1]]) %in% nombre)]
    
    filter1 <- group_by(initData, date)
    graphData <- summarize(filter1, 
                           total = sum(CANTIDAD))
    
    graph1 <- ggplot(graphData, 
                     aes(x = date, 
                         y = total)) + 
      geom_line() +
      theme_bw() + 
      theme(legend.position="bottom") +
      scale_x_date(date_breaks = "1 month", date_labels =  "%b %Y") +
      theme(axis.text.x=element_text(angle=60, hjust=1)) +
      labs(color = "", x = "Fecha", y = "Unidades Vendidas")
    
    graph1
    
  }
})
