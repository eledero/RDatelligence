dataGen <- reactive({ 
  
  initData <- filedata()
  
  #Declaración de funciones
  firstup <- function(x) {
    substr(x, 1, 1) <- toupper(substr(x, 1, 1))
    x
  }
  
  #Fechas inicial y final
  fechaIni <- as.Date(input$date1)
  fechaFin <- as.Date(input$date2)
  
  #Procesamiento de datos para fecha
  initData$month <- firstup(unique(tolower(initData$MONTH_)))
  conv <- data.frame(month = firstup(unique(tolower(initData$MONTH_))),
                     monthNum = 1:length(firstup(unique(tolower(initData$MONTH_)))))
  initData <- merge(initData, conv, by = "month") 
  initData$date <- as.Date(paste(initData$ANO, initData$monthNum, "01", sep = "/"), format = "%Y/%m/%d")
  
  #Filtrado por fechas INICIAL
  initData <- initData[initData$date <= as.Date("2010/04/02", format = "%Y/%m/%d"), ]
  
  #Filtrado por fechas
  initData <- initData[initData$date >= fechaIni, ]
  initData <- initData[initData$date <= fechaFin, ]
  
  if(!is.null(input$brand)){
    
    initData <- initData[(initData$MARCA %in% input$brand), ]
    
  } 
  
  if(!is.null(input$department)){
    
    initData <- initData[(initData$DEPARTAMENTO %in% input$department), ]
    
  } 
  
  if(!is.null(input$service)){
    
    initData <- initData[(initData$SERVICIO %in% input$service), ]
    
  }
  
  if (!is.null(input$status)){
    
    initData <- initData[(initData$STATUS %in% input$status), ]
    
  } 
  
  if (!is.null(input$segment)){
    
    initData <- initData[(initData$SEGMENTO %in% input$segment), ]
    
  } 
  
  if (!is.null(input$origin)){
    
    initData <- initData[(initData$NACIONAL_IMPORT %in% input$origin), ]
    
  } 
  
  list(initData, unique(initData$MARCA), unique(initData$DEPARTAMENTO), unique(initData$SERVICIO), unique(initData$STATUS), unique(initData$SEGMENTO), unique(initData$NACIONAL_IMPORT))
  
})
