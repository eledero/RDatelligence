library(ggplot2)
library(dplyr)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 11*1024^2)


shinyServer(function(input, output) {
  
  #Archivo de entrada
  
  
  #Lee el archivo CSV
  
  
  
  filedata <- reactive({
    inFile1 <- input$file1
    if (is.null(inFile1)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    read.csv(inFile1$datapath, sep = ";")
    
  })
  
  
  
  
  
  
  
  
  
  
  
  dataGen <- reactive({ 
  
    
    initData <- filedata()
    
    if (is.null(initData)){
      
      return(NULL)
      
    }
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
  
  
  
  observe({
    updateSelectizeInput('brand', 
                         choices = as.character(dataGen()[[2]]))
  })
  
  
    
  #output$selectUIMarca <- renderUI({ 
    
   # selectizeInput("brand", 
    #               "Marca(s)", 
     #              as.character(dataGen()[[2]]), 
      #             multiple = TRUE)
  #})
  
  
  output$selectUIDpto <- renderUI({ 
    
    selectizeInput("department", 
                   "Departamento(s)", 
                   as.character(dataGen()[[3]]), 
                   multiple = TRUE)
  })
  
  output$selectUIServ <- renderUI({ 
    
    selectizeInput("service", 
                   "Servicios", 
                   as.character(dataGen()[[4]]), 
                   multiple = TRUE)
  })
  
  
  output$selectUIStat<- renderUI({ 
    
    selectizeInput("status", 
                   "Status", 
                   as.character(dataGen()[[5]]), 
                   multiple = TRUE)
  })
  
  output$selectUISegm<- renderUI({ 
    
    selectizeInput("segment", 
                   "Segmento", 
                   as.character(dataGen()[[6]]), 
                   multiple = TRUE)
  })
  
  output$selectUIOrig<- renderUI({ 
    
    selectizeInput("origin", 
                   "Origen", 
                   as.character(dataGen()[[7]]), 
                   multiple = TRUE)
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
    data.frame(x=dataGen()[[1]])
  })
  
  output$values <- renderPrint({
    
    
    list(x1 = input$brand)
    
    #str(sapply(sprintf('e%d', 0:10), function(id) {
     # input[[id]]
    #}, simplify = FALSE))
    
    #htmlOutput("selectUIServ"),
    #htmlOutput("selectUIStat"),
    #htmlOutput("selectUISegm"),
    #htmlOutput("selectUIOrig"),
    
    
    
  })
  
  
})