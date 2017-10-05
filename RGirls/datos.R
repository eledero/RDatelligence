setwd("RDatelligence/RGirls")

library(reshape2)

a <- read.csv(dir()[2], stringsAsFactors = FALSE)
a <- melt(a, id.vars = "REGION")
str(a)
cambios <- grepl("%", a$value)
a$value[cambios] <- gsub("%", "", a$value[cambios])

a$value <- as.numeric(a$value)

a$value[cambios] <- a$value[cambios]/100

