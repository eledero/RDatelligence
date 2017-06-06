    output$report <- downloadHandler(
      # For PDF output, change this to "report.pdf"
      filename = "report.pdf",
      content = function(file) {
        # Copy the report file to a temporary directory before processing it, in
        # case we don't have write permissions to the current working dir (which
        # can happen when deployed).
        tempReport <- file.path(tempdir(), "report.Rmd")
        file.copy("report.Rmd", tempReport, overwrite = TRUE)
        source("report1.R", local = TRUE)
        source("report2.R", local = TRUE)
        source("report3.R", local = TRUE)
        # Set up parameters to pass to Rmd document
        
        opciones <- c(TRUE, FALSE, TRUE)
        params <- list(show_text = FALSE, a = graph1, b = graph2, c = graph3, d = opciones)
        
        # Knit the document, passing in the `params` list, and eval it in a
        # child of the global environment (this isolates the code in the document
        # from the code in this app).
        rmarkdown::render(tempReport, output_file = file,
                          params = params,
                          envir = new.env(parent = globalenv())
        )
      }
    )
