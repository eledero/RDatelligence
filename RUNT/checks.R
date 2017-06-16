output$textie <- renderPrint({
  
  
  
  #dataGen1()
  #actionButton1()
  #params()
  #dataGen1()[[1]]
  #dataGen1()[[1]]
  "Hola"
  #params()[[1]]
  #checkie()
})


output$Plot_1 <- renderPlot({
  
  graph1()
  
})



output$table1 <- renderTable({
  #nam <- dataGen()[[9]]
  #filedata()
  dataGen1()[[1]]  
  
  #data.frame(dataGen1()[[1]])
  
  #parameters()
})
