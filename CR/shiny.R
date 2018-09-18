  shinyApp(
    
    
    
    ui = fluidPage(
    
      tabsetPanel(type = "tabs",
                  tabPanel("Analisis temporal", 
                           
                           selectizeInput("state", "Escoja las variables (maximo 4):",
                                          choices = c(" "),
                                          options = list(maxItems = 4), 
                                          multiple = TRUE
                                          
                           ), 
                           
                           plotOutput("tempAnalysis")
                           
                           ),
                  
                  tabPanel("Analisis cruzado", 
                           
                           selectizeInput("state2", "Escoja las variables (maximo 2):",
                                          choices = c(" "),
                                          options = list(maxItems = 2), 
                                          multiple = TRUE
                                          
                           ),
                           plotOutput("crossAnalysis")
                           
                           
                           
                           
                           )
      )
      
      
    ),
    
    
    server = function(input, output, session) {

      library(ggplot2)
      library(dplyr)
      library(tidyr)
      library(ggrepel)
      
      initTable <- reactive({
        #setwd("~/RDatelligence/CR")
        initTable = read.csv(dir()[grepl("Costa", dir())]) %>%
          gather(key, value, -X) %>%
          arrange(key, X)
        
        initTable$value = gsub(",", "", initTable$value) %>% 
          as.numeric()
        names(initTable) = c("Año", "Variable", "Valor")
        
        initTable
        
      })
      
      output$graph1 = renderPlot({
        
        variables = c("Cienc.Salud.U.Pb", "Cienc.Soc.U.Pb")
        ggplot(initTable[initTable$Variable %in% variables, ]) + aes(x = Año, y = Valor) + geom_line(aes(color = Variable)) + labs(x = "Año", y = "Valor", legend = "", title = "Evolución de variables.") + theme(legend.position="bottom", legend.box = "vertical", legend.title = element_blank())
        
        
      })
      
      output$tempAnalysis = renderPlot({
        initTable = initTable()
        variables = input$state
        ggplot(initTable[initTable$Variable %in% variables, ]) + aes(x = Año, y = Valor) + geom_line(aes(color = Variable)) + labs(x = "Año", y = "Valor", legend = "", title = "Evolución de variables.") + theme(legend.position="bottom", legend.box = "vertical", legend.title = element_blank())
        
      })
      
      output$crossAnalysis = renderPlot({
        initTable = initTable()
        varScatter = input$state2
        scatterData = cbind(initTable[which(initTable$Variable == varScatter[1]), ], initTable[which(initTable$Variable == varScatter[2]), "Valor"])
        names(scatterData) = c("Año", "key", varScatter[1], varScatter[2])
        ggplot(scatterData, aes_string(varScatter[1], varScatter[2], label = "Año")) + geom_point() + geom_text_repel(size = 2.5) + labs(title = "Análisis cruzado de variables.")
        
        
      })
      
      output$result <- renderPrint({
        
        str(input$state)
      })
      
      observe({
        
        newList = initTable()
        
        updateSelectizeInput(session, "state",
                             choices = unique(newList$Variable)
        )
        
        updateSelectizeInput(session, "state2",
                             choices = unique(newList$Variable))
        
      })
      
      
    }
  )
