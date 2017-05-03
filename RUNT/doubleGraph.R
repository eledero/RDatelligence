doubleGraph <- function(df, nams = c("eje1", "eje2")){
scalFact <- mean(df[, 3])/mean(df[, 2])
names(df) <- c("date","valor1", "valor2")
p <- ggplot(df, aes(x = date))
p <- p + geom_line(aes(y = valor1, colour = "Red"))

# adding the relative humidity data, transformed to match roughly the range of the temperature
p <- p + geom_line(aes(y = valor2/scalFact, colour = "Blue"))

# now adding the secondary axis, following the example in the help file ?scale_y_continuous
# and, very important, reverting the above transformation
p <- p + scale_y_continuous(sec.axis = sec_axis(~.*scalFact, name = nams[2])) + scale_x_date()

# modifying colours and theme options
p <- p + scale_colour_manual(values = c("blue", "red"), labels = c(nams[2], nams[1]))
p <- p + labs(y = nams[1], x = "Fecha", colour = "") + theme(legend.position="bottom")

p

}



