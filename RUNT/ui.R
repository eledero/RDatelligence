shinyUI(
  fluidPage(
    #img(src="logo_datelligence-2016.png", align = "right", width = "150px"),
  
  sidebarLayout(
    sidebarPanel(
      
      dateInput("date1", "Fecha de inicio del análisis:", value = "2010-01-01"),
      dateInput("date2", "Fecha de fin del análisis:", value = "2011-04-01"),
      
      selectInput("field", "Selecciona la variable:", NULL, multiple = FALSE),
      
      selectizeInput("brand", "Marca(s)", NULL, multiple = TRUE, options = list(maxItems = 5)),
      
      selectizeInput("department", "Departamento(s)", NULL, multiple = TRUE, options = list(maxItems = 5)),
      
      selectizeInput("service","Servicios", NULL, multiple = TRUE, options = list(maxItems = 5)),
      
      selectizeInput("status", "Status", NULL, multiple = TRUE, options = list(maxItems = 5)),
      
      selectizeInput("segment", "Segmento", NULL, multiple = TRUE, options = list(maxItems = 5)),
        
      selectizeInput("origin", "Origen", NULL, multiple = TRUE, options = list(maxItems = 5)),
      
      selectInput("context", "Variable de contexto", NULL, multiple = FALSE, choices = c("Dolar", "Gasolina", "Petroleo (WTI)", "Petroleo (Brent)", "Confianza", "Desempleo", "Precipitacion")),
      
      tags$hr()
    ),
    
    mainPanel(
     
      
      mainPanel(
        
        
        tabsetPanel(
          tabPanel("Market Share", plotOutput("Plot2", height = "400px", width = "600px"), tableOutput("table2")),
          tabPanel("Genere su reporte",
                   h3("________________________________________________________________"),
                   selectInput("report1", "Selecciona la visualización # 1:", NULL, multiple = FALSE),
                   actionButton("goButton1", "Capturar filtro para visualización 1"),
                   h3("________________________________________________________________"),
                   
                   selectInput("report2", "Selecciona la visualización # 2:", NULL, multiple = FALSE), 
                   actionButton("goButton2", "Capturar filtro para visualización 2"),
                   h3("________________________________________________________________"),
                   
                   downloadButton("report", "Generar reporte")),
          tabPanel("Evolución", plotOutput("Plot1", height = "400px", width = "600px")), 
          tabPanel("Contexto", plotOutput("Plot3", height = "400px", width = "600px")),
          tabPanel("Variación", plotOutput("Plot4", height = "400px", width = "600px")),
          tabPanel("Tabla original", tableOutput("table1")),
          tabPanel("Summary", verbatimTextOutput("textie"),  plotOutput("Plot_1", height = "400px", width = "600px"))
          
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