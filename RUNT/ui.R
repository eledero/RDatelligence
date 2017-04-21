shinyUI(fluidPage(
  titlePanel("Reporte de archivo RUNT."),
  sidebarLayout(
    sidebarPanel(
      
      dateInput("date1", "Fecha de inicio del análisis:", value = "2000-01-01"),
      dateInput("date2", "Fecha de fin del análisis:", value = "2020-01-01"),
      
      selectInput("field", "Campo a analizar",  NULL, multiple = FALSE),
      
      selectizeInput("brand", "Marca(s)", NULL, multiple = TRUE, options = list(maxItems = 5)),
      
      selectizeInput("department", "Departamento(s)", NULL, multiple = TRUE, options = list(maxItems = 5)),
      
      selectizeInput("service","Servicios", NULL, multiple = TRUE, options = list(maxItems = 5)),
      
      selectizeInput("status", "Status", NULL, multiple = TRUE, options = list(maxItems = 5)),
      
      selectizeInput("segment", "Segmento", NULL, multiple = TRUE, options = list(maxItems = 5)),
      
      selectizeInput("origin", "Origen", NULL, multiple = TRUE, options = list(maxItems = 5)),
      #htmlOutput("field"),
      #htmlOutput("brand"),
      #htmlOutput("department"),
      #htmlOutput("service"),
      #htmlOutput("status"),
      #htmlOutput("segment"),
      #htmlOutput("origin"),
      
      #selectInput("field", 
      #               "Campo a analizar", 
      #               names(initData), 
      #               multiple = FALSE
      #            ),
      
      #selectizeInput("brand", 
      #               "Marca(s)", 
      #              initData$MARCA, 
      #              multiple = TRUE,
      #              options = list(maxItems = 5)),
      
      #selectizeInput("department", 
      #               "Departamento(s)", 
      #               initData$DEPARTAMENTO, 
      #               multiple = TRUE,
      #               options = list(maxItems = 5)),
      
      #selectizeInput("service", 
      #               "Servicios", 
      #               initData$SERVICIO, 
      #               multiple = TRUE,
      #               options = list(maxItems = 5)),
      
      #selectizeInput("status", 
      #               "Status", 
      #               initData$STATUS, 
      #               multiple = TRUE,
      #               options = list(maxItems = 5)),
      
      #selectizeInput("segment", 
      #               "Segmento", 
      #               initData$SEGMENTO, 
      #               multiple = TRUE,
      #               options = list(maxItems = 5)),
      
      #selectizeInput("origin", 
      #               "Origen", 
      #               initData$NACIONAL_IMPORT, 
      #               multiple = TRUE,
      #               options = list(maxItems = 5)),
      
      tags$hr()
    ),
    
    mainPanel(
     
      
      mainPanel(
        tabsetPanel(
          tabPanel("Evolución", plotOutput("Plot1", height = "400px", width = "600px")), 
          tabPanel("Market Share", plotOutput("Plot2", height = "400px", width = "600px"), tableOutput("table2")),
          tabPanel("Tabla original RUNT", tableOutput("table1")),
          tabPanel("Summary", verbatimTextOutput("textie"))
          
        )
      ),
      
      tags$style(type="text/css",
                 ".shiny-output-error { visibility: hidden; }",
                 ".shiny-output-error:before { visibility: hidden; }"
      )
      
      
      
      
      
      
    )
  )
)
)