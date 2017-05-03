#doubleMerge <- reactive({ 
output$Plot3 <- renderPlot({  
  
  
  
 if((input$context) == "Dolar"){
   source("dolar.R", local = TRUE)
   df1 <- df
   nam <- c("Tasa de Cambio USD-COP", "Unidades vendidas")
 }
  

  if((input$context) == "Petroleo"){
    source("petroleo.R", local = TRUE)
    df1 <- df
    nam <- c("Precio barril Petroleo WTI (USD/barril)", "Unidades vendidas")
  }
  
  if((input$context) == "Confianza"){
    source("confianza.R", local = TRUE)
    df1 <- df
    nam <- c("ICC (%)", "Unidades vendidas")
  }
  
  if((input$context) == "Desempleo"){
    source("desempleo.R", local = TRUE)
    df1 <- df
    nam <- c("Desempleo (%)", "Unidades vendidas")
  }
  
  
 
  
  
  df <- doubleData()
  
  df2 <- merge(x = df1, y = df, by = "date", all.x = TRUE)
  
  
  #as.character(format(as.Date(df2$date,format="%Y-%m-%d"), "%d"))
  #which((as.character(format(as.Date(df2$date,format="%Y-%m-%d"), "%d"))) == "01")
  df2 <- df2[which((as.character(format(as.Date(df2$date,format="%Y-%m-%d"), "%d"))) == "01"), ]
  
  #df2
  #c("Dolar", "Petroleo", "Confianza", "Desempleo")
  
  
  source("doubleGraph.R", local = TRUE)
  
  
  
    doubleGraph(df2, nam)
  
  
  
  })
  