df <- read.csv("gasolina.csv", sep = ",", header = FALSE)

df <- df[ -c(168:nrow(df)), ] 
df$V2 <- df$V2 * 1000
names(df) <- c("date", "gasolina")
df$gasolina <- as.character(df$gasolina)







df$date <- as.character(df$date)
#df$date <- substr(df$date, 2, nchar(df$date))

df$date <- as.Date(df$date, format = "%Y-%m-%d")
df$gasolina <- as.double(df$gasolina); 
df$desempleo<- NULL
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

if(is.na(df$gasolina[1])){
  
  df$gasolina[1] <- df$gasolina[!is.na(df$gasolina)][1]
  
}



df[, 2] <- complet(df[, 2])






