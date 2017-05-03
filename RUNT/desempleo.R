library(XLConnect)
wb <- loadWorkbook("desempleo.xlsx")
df <- readWorksheet(wb, sheet = "Sheet1", header = TRUE)
df <- df[11:nrow(df), ] 
df <- df[1:(nrow(df) - 13), ]


df[, 1] <- paste0(df[, 1], "-01")
names(df) <- c("date", "empleo", "desempleo")
df$date <- as.Date(df$date, format = "%Y-%m-%d")
df$empleo <- as.numeric(df$empleo); df$desempleo <- as.numeric(df$desempleo)
df$fecha <- NULL
#(df)


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

df[, 2] <- complet(df[, 2])
df[, 3] <- complet(df[, 3])

df$empleo <- NULL



