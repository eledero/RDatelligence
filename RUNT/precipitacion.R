df <- read.csv("precipitacion.csv", header =  TRUE, sep = ";")


df$X <- NULL; df$X.1 <- NULL
#df[, 3:4] <- NULL
names(df) <- c("date", "prec")
df$date <- as.Date(df$date, format = "%Y-%m-%d")
df$prec <- as.numeric(df$prec)



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

df <- df[, 1:2]






