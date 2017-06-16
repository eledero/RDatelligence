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
                     input$report2)
        #,
         #            input$report3,
          #           input$report4,
          #           input$report5,
          #           input$report6,
          #           input$report7,
          #           input$report8,
          #           input$report9,
          #           input$report10)
        
        #source("rep_1.R", local = TRUE)
        # Set up parameters to pass to Rmd document
        
        
        gr1 <- graph1()
        opciones <- c(TRUE, FALSE, TRUE)
        params <- list(show_text = TRUE, choices = choices, a = gr1)
        
        # Knit the document, passing in the `params` list, and eval it in a
        # child of the global environment (this isolates the code in the document
        # from the code in this app).
        rmarkdown::render(tempReport, output_file = file,
                          params = params,
                          envir = new.env(parent = globalenv())
        )
      }
    )
