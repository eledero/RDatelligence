library(ggplot2)
library(dplyr)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 11*1024^2)


shinyServer(function(input, output, session) {
  
  #Archivo de entrada
  
  
  #Lee el archivo CSV
  
  
  
  
  filedata <- reactive({
     initData <- read.csv("base_runt.csv", sep = ";")
    
  })
    
  
  nombres <- reactive({
    nam <- read.csv("nombres.csv", sep = ",")
  })
  
  dataGen <- reactive({ 
    
    
    initData <- filedata()
    #nam <- nombres()
    
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
    initData <- merge(initData, 
                      conv, 
                      by = "month") 
    initData$date <- as.Date(paste(initData$ANO, 
                                   initData$monthNum, 
                                   "01", 
                                   sep = "/"), 
                             format = "%Y/%m/%d")
    
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
    
    
    
    list(initData, 
         unique(initData$MARCA),
         unique(initData$DEPARTAMENTO),
         unique(initData$SERVICIO),
         unique(initData$STATUS),
         unique(initData$SEGMENTO),
         unique(initData$NACIONAL_IMPORT)
         
    )
    
  })
  
  
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
  
  
  
  output$textie <- renderPrint({
    
    "a"
    
    
  })
  
  
  
  output$Plot2 <- renderPlot({
    
    
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
    
    piegraph(info)
    
  })
  
  
  output$table1 <- renderTable({
    #nam <- dataGen()[[9]]
    #filedata()
    data.frame(dataGen()[[1]])
    })
  
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
  
  
  
  updateSelectizeInput(session, "field", choices = read.csv("nombres.csv", sep = ",")[, 2], server = TRUE)
  updateSelectizeInput(session, "brand", choices = read.csv("base_runt.csv", sep = ";")[, "MARCA"], server = TRUE)
  updateSelectizeInput(session, "department", choices = read.csv("base_runt.csv", sep = ";")[, "DEPARTAMENTO"], server = TRUE)
  updateSelectizeInput(session, "service", choices = read.csv("base_runt.csv", sep = ";")[, "SERVICIO"], server = TRUE)
  updateSelectizeInput(session, "status", choices = read.csv("base_runt.csv", sep = ";")[, "STATUS"], server = TRUE)
  updateSelectizeInput(session, "segment", choices = read.csv("base_runt.csv", sep = ";")[, "SEGMENTO"], server = TRUE)
  updateSelectizeInput(session, "origin", choices = read.csv("base_runt.csv", sep = ";")[, "NACIONAL_IMPORT"], server = TRUE)
  
})