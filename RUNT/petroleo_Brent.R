library(quantmod)
getSymbols('DCOILBRENTEU', src='FRED')



petroleo <- DCOILBRENTEU

head(petroleo)

str(petroleo)

petrol <- data.frame(precio = petroleo[, 1])


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

petrol[, 1] <- complet(petrol[, 1])
petrol$date <- as.Date(rownames(petrol))

st <- as.Date("2010-1-1")
en <- as.Date("2010-4-2")
ll <- data.frame(date = seq(st, en, by = "1 day"))

petrol <- merge(x = ll, y = petrol, by = "date", all.x = TRUE)

petrol[, 2] <- complet(petrol[, 2])

df <- data.frame(petrol[, 1], petrol[, 2])

names(df) <- c("date", "valor")


