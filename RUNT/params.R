actionButton1 <- eventReactive(input$goButton1, {
  params1 <- list(a =input$origin, 
                  b = input$context, 
                  c = input$date1, 
                  d = input$date2, 
                  e = input$field, 
                  f = input$brand, 
                  g = input$department, 
                  h = input$service,
                  i = input$status, 
                  j = input$segment)
  params1
}

, ignoreNULL = FALSE

)






actionButton2 <- eventReactive(input$goButton2, {
  params1 <- list(a =input$origin, #1
                  b = input$context, #2
                  c = input$date1, #3
                  d = input$date2, #4
                  e = input$field, #5
                  f = input$brand, #6
                  g = input$department, #7
                  h = input$service,#8
                  i = input$status, #9
                  j = input$segment) #10
  params1
}

, ignoreNULL = FALSE

)


params <- reactive({ 
  
  
  elem1 <- actionButton1()
  elem2 <- actionButton2()
  
  paramets <- list(a1 = elem1, a2 = elem2)
  
  paramets
  }  )
  

