    output$report <- downloadHandler(
      # For PDF output, change this to "report.pdf"
      filename = "report.pdf",
      content = function(file) {
        # Copy the report file to a temporary directory before processing it, in
        # case we don't have write permissions to the current working dir (which
        # can happen when deployed).
        tempReport <- file.path(tempdir(), "report.Rmd")
        file.copy("report.Rmd", tempReport, overwrite = TRUE)
        
        
        choices <- c(input$report1,
                     input$report2,
                     input$report2)
        
        titles <- c(input$title_1, 
                    input$title_2, 
                    input$title_3)
        
        bigBox <- c(input$big_box1, 
                      input$big_box2, 
                      input$big_box3)
        
        
        #source("rep_1.R", local = TRUE)
        # Set up parameters to pass to Rmd document
        
        
        gr1 <- graph1()
        gr2 <- graph2()
        gr3 <- graph3()
        opciones <- c(TRUE, FALSE, TRUE)
        params <- list(show_text = TRUE, 
                       choices = choices, 
                       a = gr1,
                       b = gr2,
                       c = gr3,
                       titles = titles,
                       bigBox = bigBox
                       )
        
        # Knit the document, passing in the `params` list, and eval it in a
        # child of the global environment (this isolates the code in the document
        # from the code in this app).
        rmarkdown::render(tempReport, output_file = file,
                          params = params,
                          envir = new.env(parent = globalenv())
        )
      }
    )
