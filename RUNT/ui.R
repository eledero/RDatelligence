shinyUI(fluidPage(
  titlePanel("Reporte de archivo RUNT."),
  sidebarLayout(
    sidebarPanel(
      
      dateInput("date1", "Fecha de inicio del análisis:", value = "2000-01-01"),
      dateInput("date2", "Fecha de fin del análisis:", value = "2020-01-01"),
      
      
      selectizeInput("brand", 
                     "Marca(s)", 
                    initData$MARCA, 
                    multiple = TRUE),
      
      selectizeInput("department", 
                     "Departamento(s)", 
                     initData$DEPARTAMENTO, 
                     multiple = TRUE),
      
      selectizeInput("service", 
                     "Servicios", 
                     initData$SERVICIO, 
                     multiple = TRUE),
      
      selectizeInput("status", 
                     "Status", 
                     initData$STATUS, 
                     multiple = TRUE),
      
      selectizeInput("segment", 
                     "Segmento", 
                     initData$SEGMENTO, 
                     multiple = TRUE),
      
      selectizeInput("origin", 
                     "Origen", 
                     initData$NACIONAL_IMPORT, 
                     multiple = TRUE),
      
      tags$hr()
    ),
    
    mainPanel(
      h4('Instrucciones: '),
      h5('Paso 1: cargue los archivos en las casillas de la izquierda.'),
      h4(' '),
      h5('Paso 2: seleccione las fechas de inicio y fin.'),
      h4(' '),
      h5('Paso 3: voila. Ahora tiene usted su informe.'),
      h4(' '),
      h4('____________________________________________________________________________________________________'),
      h4(' '),
      
      mainPanel(
        tabsetPanel(
          tabPanel("Evolución", plotOutput("Plot1", height = "400px", width = "600px")), 
          tabPanel("Market Share", plotOutput("Plot2", height = "400px", width = "600px")),
          tabPanel("Table", tableOutput("table")),
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