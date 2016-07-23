#Install Packages

install.packages("caret")
install.packages("kernlab")
install.packages("e1071")
install.packages("doParallel")

library(caret)
library(kernlab)
library(e1071)
library(doParallel)




getwd()
setwd("./MachLearning/FinalProj")



#Download data files and put them into test and train (submission) sets

urlTrain <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
urlTest <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(urlTrain, "train.csv")
download.file(urlTest, "test.csv")
train <- read.csv("train.csv")
test <- read.csv("test.csv")


#Remove Columns with at least 1 NA or blank value 

PCASet <- train[, -c(1:7)]
PCASet <- PCASet[, colSums(is.na(PCASet)) == 0]
b <- c()
for(i in 1:ncol(PCASet)){
  if(i != ncol(PCASet)){
    b[i] <- sum(as.character(PCASet[, i]) == "")
  } else{
    b[i] <- 0
  }
}
b <- (b == 0)
PCASet <- PCASet[, b]


#Train Random Forest Model with parallel processing:

par <- trainControl(repeats = 3, number = 3)
cl <- makeCluster(detectCores(), type = 'PSOCK')
registerDoParallel(cl)
model2 <- train(classe ~ ., method = "rf", data = PCASet, trControl = par )
registerDoSEQ()
answers <- predict(model2, newdata = test)
answers <- as.character(answers)
print(model2$finalModel)


#Write answers for uploading:

pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

pml_write_files(answers)

#model <- train(classe ~ ., method = "rpart", data = PCASet)
#confusionMatrix(model)