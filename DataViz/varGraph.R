output$Plot4 <- renderPlot ({
  
  df <- variation()
  
  ggplot(df, aes(x = monthNum, y = cant, color = factor(ANO))) + 
    geom_line() + 
    theme_bw() + 
    labs(x = "Mes", y = "Autos vendidos", color = "Año")
  
  
  
})