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





if((input$context) == "Dolar"){
  source("dolar.R", local = TRUE)
  df1 <- df
  nam <- c("Tasa de Cambio USD-COP", "Unidades vendidas", "Fuente: Banco de la República de Colombia.")
}


if((input$context) == "Petroleo (WTI)"){
  source("petroleo_WTI.R", local = TRUE)
  df1 <- df
  nam <- c("Precio barril Petroleo WTI (USD/barril)", "Unidades vendidas", "Fuente: Yahoo.")
}

if((input$context) == "Petroleo (Brent)"){
  source("petroleo_Brent.R", local = TRUE)
  df1 <- df
  nam <- c("Precio barril Petroleo Brent (USD/barril)", "Unidades vendidas", "Fuente: Yahoo.")
}

if((input$context) == "Confianza"){
  source("confianza.R", local = TRUE)
  df1 <- df
  nam <- c("ICC (%)", "Unidades vendidas", "Fuente: Fedesarrollo.")
}

if((input$context) == "Desempleo"){
  source("desempleo.R", local = TRUE)
  df1 <- df
  nam <- c("Desempleo (%)", "Unidades vendidas", "Fuente: Banco de la República.")
}


if((input$context) == "Precipitacion"){
  source("precipitacion.R", local = TRUE)
  df1 <- df
  nam <- c("Precipitacion (cc)", "Unidades vendidas", "Fuente: Ideam-Observatorio ambiental de Bogotá.")
}

if((input$context) == "Gasolina"){
  source("gasolina.R", local = TRUE)
  df1 <- df
  nam <- c("Valor galon gasolina (COP)", "Unidades vendidas", "Fuente: Sistema de
           información de petróleo y gas colombiano (SIPG).")
}





df <- doubleData()

df2 <- merge(x = df1, y = df, by = "date", all.x = TRUE)


#as.character(format(as.Date(df2$date,format="%Y-%m-%d"), "%d"))
#which((as.character(format(as.Date(df2$date,format="%Y-%m-%d"), "%d"))) == "01")
df2 <- df2[which((as.character(format(as.Date(df2$date,format="%Y-%m-%d"), "%d"))) == "01"), ]

#df2
#c("Dolar", "Petroleo", "Confianza", "Desempleo")


source("doubleGraph.R", local = TRUE)



graph3<- doubleGraph(df2, nam)