library(XLConnect)
wb <- loadWorkbook("confianza.xlsx")
df <- readWorksheet(wb, sheet = "ICC", header = TRUE)
df <- df[12:nrow(df), ] 
#df <- df[1:(nrow(df) - 5), ]
names(df) <- c("date", "ICC", "IEC", "ICE")
df$date <- as.Date(df$date)

complet <- function(x){
  
  for (i in 1:length(x)){
    
    if(is.na(x[i])){
      
      #print(is.na(x[i]))
      
      
      x[i] <- x[i-1]
      
      print(x[i])
      
      
    }
    
  }
  
  return(x)
}

#petrol[, 1] <- complet(petrol[, 1])

st <- as.Date("2010-1-1")
en <- as.Date("2010-4-2")
ll <- data.frame(date = seq(st, en, by = "1 day"))

df <- merge(x = ll, y = df, by = "date", all.x = TRUE)

df[, 2] <- as.numeric(complet(df[, 2]))
df$IEC <- NULL; df$ICE <- NULL