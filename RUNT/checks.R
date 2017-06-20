output$textie <- renderPrint({
  
  
  
  #dataGen1()
  #actionButton1()
  #params()
  #dataGen1()[[1]]
  #dataGen1()[[1]]
  input$big_box1
  #params()[[1]]
  #checkie()
})


output$Plot_1 <- renderPlot({
  graph1()
})

output$Plot_2 <- renderPlot({
  graph2()
})

output$Plot_3 <- renderPlot({
  graph3()
})


output$table1 <- renderTable({
  #nam <- dataGen()[[9]]
  #filedata()
  dataGen1()[[1]]  
  
  #data.frame(dataGen1()[[1]])
  
  #parameters()
})
