output$table2 <- renderTable({
  
  initData <- dataGen()[[1]]
  nam <- data.frame(nombres())
  nombre <- nam$nombre[match(input$field, nam$nombre2)]
  info <- initData[, which(names(dataGen()[[1]]) %in% nombre)]
  info <- data.frame(info)
  names(info)[1] <- "a"  
  
  
  filter1 <- group_by(.data = info, by = a)
  dataCat2 <- summarize(filter1, count = n())
  dataCat2$prop <- dataCat2$count/sum(dataCat2$count)
  dataCat2 <- arrange(dataCat2, desc(prop))
  names(dataCat2)[1] <- "a"  
  dataCat2$a <- as.character(dataCat2$a)
  
  filter1 <- group_by(dataCat2, a)
  dataCat2 <- summarize(filter1, count = sum(count), prop = sum(prop))
  dataCat2$prop2 <- paste(round(dataCat2$prop*100, 1), "%")
  
  
  
  dataCat2$prop <- NULL
  
  names(dataCat2) <- c(input$field, "unid", " Market Share")
  
  
  dataCat2 <- arrange(dataCat2, desc(unid))
  
  names(dataCat2) <- c(input$field, "# de unidades", " Market Share")
  
  dataCat2$Puesto <- 1:nrow(dataCat2)
  
  dataCat2 <- dataCat2[, c(4, 1:3)]
  
  dataCat2
  
})
