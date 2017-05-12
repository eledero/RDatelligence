library(ggplot2)
library(dplyr)
library(gtable)
library(grid)
library(ggthemes)


options(shiny.maxRequestSize = 11*1024^2)

shinyServer(function(input, output, session) {
  
  source("dataLoad.R", local = TRUE) #Cargue de archivos CSV de base y nombres
  source("dataGen.R", local = TRUE) #Generación de dataframe base
  source("plot1.R", local = TRUE) #Plot de evolución
  source("plot2.R", local = TRUE) #Plot de Mkt Share
  source("table2.R", local = TRUE) #Tabla de Mkt Share
  source("checks.R", local = TRUE) #Tabla original y Summary
  source("updateSelectizeInput.R", local = TRUE) #Actualizaciones de los campos en los SelectizeInput
  source("doubleData.R", local = TRUE)
  source("doubleMerge.R", local = TRUE)
  source("variation.R", local = TRUE)
  source("varGraph.R", local = TRUE)
  
  
  
})