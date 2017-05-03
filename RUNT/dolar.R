
library(XLConnect)
wb <- loadWorkbook("dolar.xlsx")
df <- readWorksheet(wb, sheet = "Sheet1", header = TRUE)
df <- df[8:nrow(df), ] 
df <- df[1:(nrow(df) - 5), ]

substrRight <- function(x, n){
  substr(x, 6, nchar(x))
}

df[, 2] <- sapply(X = df[, 2], FUN = substrRight)
df[, 3] <- sapply(X = df[, 3], FUN = substrRight)
df[, 1] <- paste0(substr(df[, 1], 1, 4), "-", substr(df[, 1], 5, 6), "-", "01")
df$Cotización.del.dólar <- as.Date(df$Cotización.del.dólar, format = "%Y-%m-%d")
names(df) <- c("date", "promedio", "finMes")


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

df[, 2] <- as.numeric(gsub(",", "", x = complet(df[, 2])))
df[, 3] <- as.numeric(gsub(",", "", x = complet(df[, 3])))

df$finMes <- NULL



