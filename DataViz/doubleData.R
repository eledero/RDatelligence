doubleData <- reactive({ 
  
  df <- data.frame(dataGen()[[1]])
  
  
  
 
  
  st <- as.Date("2010-1-1")
  en <- as.Date("2010-4-2")
  ll <- data.frame(date = seq(st, en, by = "1 day"))
  
  filter1 <- group_by(df, date)
  
  df <- summarize(filter1, cantidad = sum(CANTIDAD))
  
  complet <- function(x){
    
    for (i in 1:length(x)){
      
      if(is.na(x[i])){
        
        #print(is.na(x[i]))
        
        
        x[i] <- x[i-1]
        
        #print(x[i])
        
        
      }
      
    }
    
    return(x)
  }
  
  #petrol[, 1] <- complet(petrol[, 1])
  
  st <- as.Date("2010-1-1")
  en <- as.Date("2010-4-2")
  ll <- data.frame(date = seq(st, en, by = "1 day"))
  
  df <- merge(x = ll, y = df, by = "date", all.x = TRUE)
  
  df[, 2] <- complet(df[, 2])
  
  df
  })

