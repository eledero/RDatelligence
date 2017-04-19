library(ggplot2)
library(dplyr)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 11*1024^2)


shinyServer(function(input, output) {
  
  #Archivo de entrada
  
  
  #Lee el archivo CSV
  
  
  
  filedata <- reactive({
     initData <- read.csv("base_runt.csv", sep = ";")
    
  })
    
  
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
         unique(initData$NACIONAL_IMPORT),
         input$brand
    )
    
  })
  
  
  output$Plot1 <- renderPlot({
    
    #Alistamiento de datos para gráfica
    initData <- dataGen()[[1]]
    filter1 <- group_by(initData, MARCA, MODELO)
    graphData <- summarize(filter1, 
                           total = sum(CANTIDAD))
    
    #Generación de gráfica
    graph1 <- ggplot(graphData, 
                     aes(x = MODELO, 
                         y = total, 
                         color = MARCA)) + 
      geom_line() +
      theme_bw() + 
      theme(legend.position="bottom") 
    
    #Despliegue de gráfica
    graph1
    
  })
  
  
  
  
  output$Plot2 <- renderPlot({
    
    initData <- dataGen()[[1]]
    info <- data.frame(initData$MARCA)
    names(info)[1] <- "a"  
    
    
    piegraph <- function(dataCat, titleLabel = "", fillLabel = ""){
      graph <- ggplot(data = dataCat, aes(a, fill = factor(a))) + geom_bar()
      graph <- graph + aes(x = factor(1), fill = factor(a)) + geom_bar(width = 1) + coord_polar(theta = "y")
      graph <- graph + labs(title = titleLabel, fill = fillLabel, x = "", y = "") + theme_bw()
      graph <- graph + theme(panel.grid=element_blank()) +theme(axis.text=element_blank()) + theme(axis.ticks=element_blank()) + theme_void()
      return(graph)
    }
    
    
    #Despliegue de gráfica
    
    piegraph(info)
    
  })
  
  
  output$table <- renderTable({
      
    #filedata()
    data.frame(dataGen()[[1]])
    })
  
  
  
  output$textie <- renderPrint({
    dataGen()[[1]]
#    input$brand
    
  })
  
  
  
})