dataGen1 <- reactive({ 
  
  initData <- filedata()
  
  #Declaración de funciones
  firstup <- function(x) {
    substr(x, 1, 1) <- toupper(substr(x, 1, 1))
    x
  }
  
  #Fechas inicial y final
  fechaIni <- as.Date(params()[[1]][[3]])
  fechaFin <- as.Date(params()[[1]][[4]])
  
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
  
  if(!is.null(params()[[1]][[6]])){
    
    initData <- initData[(initData$MARCA %in% params()[[1]][[6]]), ]
    
  } 
  
  if(!is.null(params()[[1]][[7]])){
    
    initData <- initData[(initData$DEPARTAMENTO %in% params()[[1]][[7]]), ]
    
  } 
  
  if(!is.null(params()[[1]][[8]])){
    
    initData <- initData[(initData$SERVICIO %in% params()[[1]][[8]]), ]
    
  }
  
  if (!is.null(params()[[1]][[9]])){
    
    initData <- initData[(initData$STATUS %in% params()[[1]][[9]]), ]
    
  } 
  
  if (!is.null(params()[[1]][[10]])){
    
    initData <- initData[(initData$SEGMENTO %in% params()[[1]][[10]]), ]
    
  } 
  
  if (!is.null(params()[[1]][[1]])){
    
    initData <- initData[(initData$NACIONAL_IMPORT %in% params()[[1]][[1]]), ]
    
  } 
  
  #initData
  list(initData, unique(initData$MARCA), unique(initData$DEPARTAMENTO), unique(initData$SERVICIO), unique(initData$STATUS), unique(initData$SEGMENTO), unique(initData$NACIONAL_IMPORT))
  
})

