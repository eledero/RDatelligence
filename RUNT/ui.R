shinyUI(fluidPage(
  titlePanel("Reporte de archivo RUNT."),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Escoja el archivo de los datos:',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv'
                )
      ),
      
      dateInput("date1", "Fecha de inicio del análisis:", value = "2000-01-01"),
      dateInput("date2", "Fecha de fin del análisis:", value = "2020-01-01"),
      
      selectizeInput(
        inputId = "brand", 
        label = "Marca(s)",
        multiple  = TRUE,
        choices = " "),
      
    
    
                 
                    
                    
                   
      
      htmlOutput("selectUIDpto"),
      htmlOutput("selectUIServ"),
      htmlOutput("selectUIStat"),
      htmlOutput("selectUISegm"),
      htmlOutput("selectUIOrig"),
      
      
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
          tabPanel("Summary", verbatimTextOutput("values"))
          
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