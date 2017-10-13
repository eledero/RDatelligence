dataGen3 <- reactive({ 
  
  initData <- filedata()
  
  #Declaración de funciones
  firstup <- function(x) {
    substr(x, 1, 1) <- toupper(substr(x, 1, 1))
    x
  }
  
  #Fechas inicial y final
  fechaIni <- as.Date(params()[[3]][[3]])
  fechaFin <- as.Date(params()[[3]][[4]])
  
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
  
  if(!is.null(params()[[3]][[6]])){
    
    initData <- initData[(initData$MARCA %in% params()[[3]][[6]]), ]
    
  } 
  
  if(!is.null(params()[[3]][[7]])){
    
    initData <- initData[(initData$DEPARTAMENTO %in% params()[[3]][[7]]), ]
    
  } 
  
  if(!is.null(params()[[3]][[8]])){
    
    initData <- initData[(initData$SERVICIO %in% params()[[3]][[8]]), ]
    
  }
  
  if (!is.null(params()[[3]][[9]])){
    
    initData <- initData[(initData$STATUS %in% params()[[3]][[9]]), ]
    
  } 
  
  if (!is.null(params()[[3]][[10]])){
    
    initData <- initData[(initData$SEGMENTO %in% params()[[3]][[10]]), ]
    
  } 
  
  if (!is.null(params()[[3]][[1]])){
    
    initData <- initData[(initData$NACIONAL_IMPORT %in% params()[[3]][[1]]), ]
    
  } 
  
  #initData
  list(initData, unique(initData$MARCA), unique(initData$DEPARTAMENTO), unique(initData$SERVICIO), unique(initData$STATUS), unique(initData$SEGMENTO), unique(initData$NACIONAL_IMPORT))
  
})





graph3 <- reactive({ 
  
  if(input$report3 == "1. Market Share"){
    
    #Reporte de Market Share
    
    initData <- dataGen3()[[1]]
    nam <- data.frame(nombres())
    nombre <- nam$nombre[match(params()[[3]][[5]], nam$nombre2)]
    info <- initData[, which(names(dataGen3()[[1]]) %in% nombre)]
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
    
    resul <- piegraph(info)
    
    resul
    
    
    
  } else if (input$report3 == "2. Evolucion"){
    
    
    #Reporte de evolución
    
    #Alistamiento de datos para gráfica
    initData <- dataGen3()[[1]]
    
    
    
    
    equival <- data.frame(nom1 = c("MARCA", "DEPARTAMENTO", "SERVICIO", "STATUS", "SEGMENTO", "NACIONAL_IMPORT"),
                          nom2 = c("brand", "department", "service", "status", "segment", "origin"), 
                          nom3 = c(6, 7, 8, 9, 10, 1))
    
    
    nam <- data.frame(nombres())
    nam$nombre <- as.character(nam$nombre); nam$nombre2 <- as.character(nam$nombre2)
    nombre <- nam$nombre[match(params()[[3]][[5]], nam$nombre2)]
    campo <- as.character(equival$nom2[match(nombre, as.character(equival$nom1))])
    campo2 <- as.numeric(equival$nom3[match(campo, as.character(equival$nom2))])
    
    
    
    if(!is.null(params()[[3]][[campo2]])) {
      
      
      initData$newCol <- initData[, which(names(dataGen3()[[1]]) %in% nombre)]
      
      filter1 <- group_by(initData, newCol, date)
      graphData <- summarize(filter1, 
                             total = sum(CANTIDAD))
      
      graph3 <- ggplot(graphData, 
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
      graph3
      
      
      
      
      
      
      
    } else{
      
      initData$newCol <- initData[, which(names(dataGen3()[[1]]) %in% nombre)]
      
      filter1 <- group_by(initData, date)
      graphData <- summarize(filter1, 
                             total = sum(CANTIDAD))
      
      graph3 <- ggplot(graphData, 
                       aes(x = date, 
                           y = total)) + 
        geom_line() +
        theme_bw() + 
        theme(legend.position="bottom") +
        scale_x_date(date_breaks = "1 month", date_labels =  "%b %Y") +
        theme(axis.text.x=element_text(angle=60, hjust=1)) +
        labs(color = "", x = "Fecha", y = "Unidades Vendidas")
      
      graph3
      
    }
    
    resul <- graph3
    
    resul
    
    
    
    
    
    
    
  } else if (input$report3 == "3. Contexto"){
    
    
    df <- data.frame(dataGen3()[[1]])
    
    
    
    
    
    st <- as.Date("2010-1-1")
    en <- as.Date("2010-4-2")
    ll <- data.frame(date = seq(st, en, by = "1 day"))
    
    filter1 <- group_by(df, date)
    
    df <- summarize(filter1, cantidad = sum(CANTIDAD))
    
    complet <- function(x){
      
      for (i in 1:length(x)){
        
        if(is.na(x[i])){
          
          #print(is.na(x[i]))
          
          
          x[i] <- x[i-1]
          
          #print(x[i])
          
          
        }
        
      }
      
      return(x)
    }
    
    #petrol[, 1] <- complet(petrol[, 1])
    
    st <- as.Date("2010-1-1")
    en <- as.Date("2010-4-2")
    ll <- data.frame(date = seq(st, en, by = "1 day"))
    
    df <- merge(x = ll, y = df, by = "date", all.x = TRUE)
    
    df[, 2] <- complet(df[, 2])
    
    
    
    
    
    if((params()[[3]][[2]]) == "Dolar"){
      source("dolar.R", local = TRUE)
      df1 <- df
      nam <- c("Tasa de Cambio USD-COP", "Unidades vendidas", "Fuente: Banco de la República de Colombia.")
    }
    
    
    if((params()[[3]][[2]]) == "Petroleo (WTI)"){
      source("petroleo_WTI.R", local = TRUE)
      df1 <- df
      nam <- c("Precio barril Petroleo WTI (USD/barril)", "Unidades vendidas", "Fuente: Yahoo.")
    }
    
    if((params()[[3]][[2]]) == "Petroleo (Brent)"){
      source("petroleo_Brent.R", local = TRUE)
      df1 <- df
      nam <- c("Precio barril Petroleo Brent (USD/barril)", "Unidades vendidas", "Fuente: Yahoo.")
    }
    
    if((params()[[3]][[2]]) == "Confianza"){
      source("confianza.R", local = TRUE)
      df1 <- df
      nam <- c("ICC (%)", "Unidades vendidas", "Fuente: Fedesarrollo.")
    }
    
    if((params()[[3]][[2]]) == "Desempleo"){
      source("desempleo.R", local = TRUE)
      df1 <- df
      nam <- c("Desempleo (%)", "Unidades vendidas", "Fuente: Banco de la República.")
    }
    
    
    if((params()[[3]][[2]]) == "Precipitacion"){
      source("precipitacion.R", local = TRUE)
      df1 <- df
      nam <- c("Precipitacion (cc)", "Unidades vendidas", "Fuente: Ideam-Observatorio ambiental de Bogotá.")
    }
    
    if((params()[[3]][[2]]) == "Gasolina"){
      source("gasolina.R", local = TRUE)
      df1 <- df
      nam <- c("Valor galon gasolina (COP)", "Unidades vendidas", "Fuente: Sistema de
               información de petróleo y gas colombiano (SIPG).")
    }
    
    
    
    
    
    df <- doubleData3()
    
    df2 <- merge(x = df1, y = df, by = "date", all.x = TRUE)
    
    
    #as.character(format(as.Date(df2$date,format="%Y-%m-%d"), "%d"))
    #which((as.character(format(as.Date(df2$date,format="%Y-%m-%d"), "%d"))) == "01")
    df2 <- df2[which((as.character(format(as.Date(df2$date,format="%Y-%m-%d"), "%d"))) == "01"), ]
    
    #df2
    #c("Dolar", "Petroleo", "Confianza", "Desempleo")
    
    
    source("doubleGraph.R", local = TRUE)
    
    
    
    resul<- doubleGraph(df2, nam)
    
    resul
    
    
    } else if (input$report3 == "4. Variacion"){
      
      initData <- filedata()
      #nam <- nombres()
      
      #Declaración de funciones
      firstup <- function(x) {
        substr(x, 1, 1) <- toupper(substr(x, 1, 1))
        x
      }
      
      
      #Fechas inicial y final
      fechaIni <- as.Date(params()[[3]][[3]])
      fechaFin <- as.Date(params()[[3]][[4]])
      
      #Procesamiento de datos para fecha
      initData$month <- firstup(unique(tolower(initData$MONTH_)))
      conv <- data.frame(month = firstup(unique(tolower(initData$MONTH_))),
                         monthNum = 1:length(firstup(unique(tolower(initData$MONTH_)))))
      initData <- merge(initData, 
                        conv, 
                        by = "month") 
      initData$date <- as.Date(paste(initData$ANO, 
                                     initData$monthNum, 
                                     "01", 
                                     sep = "/"), 
                               format = "%Y/%m/%d")
      
      #Filtrado por fechas INICIAL
      #initData <- initData[initData$date <= as.Date("2011/04/02", format = "%Y/%m/%d"), ]
      #initData <- initData[initData$date <= fechaFin, ]
      
      
      
      #Filtrado por fechas
      initData <- initData[initData$date >= fechaIni, ]
      initData <- initData[initData$date <= fechaFin, ]
      
      if(!is.null(params()[[3]][[6]])){
        
        initData <- initData[(initData$MARCA %in% params()[[3]][[6]]), ]
        
      } 
      
      if(!is.null(params()[[3]][[7]])){
        
        initData <- initData[(initData$DEPARTAMENTO %in% params()[[3]][[7]]), ]
        
      } 
      
      if(!is.null(params()[[3]][[8]])){
        
        initData <- initData[(initData$SERVICIO %in% params()[[3]][[8]]), ]
        
      }
      
      if (!is.null(params()[[3]][[9]])){
        
        initData <- initData[(initData$STATUS %in% params()[[3]][[9]]), ]
        
      } 
      
      if (!is.null(params()[[3]][[10]])){
        
        initData <- initData[(initData$SEGMENTO %in% params()[[3]][[10]]), ]
        
      } 
      
      if (!is.null(params()[[3]][[1]])){
        
        initData <- initData[(initData$NACIONAL_IMPORT %in% params()[[3]][[1]]), ]
        
      } 
      
      
      
      
      filter1 <- group_by(initData, ANO, monthNum)
      df <- summarise(filter1, cant = sum(CANTIDAD))
      
      
      graph4 <- ggplot(df, aes(x = monthNum, y = cant, color = factor(ANO))) + 
        geom_line() + 
        theme_bw() + 
        labs(x = "Mes", y = "Autos vendidos", color = "Año")
      
      
      
      resul <- graph4
      
      resul
      
    }
  
  
  
})

