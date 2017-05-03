output$textie <- renderPrint({
  
  variation()
  
  
})





output$table1 <- renderTable({
  #nam <- dataGen()[[9]]
  #filedata()
  data.frame(dataGen()[[1]])
})
