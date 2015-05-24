## Getting & Cleaning Data Project 

## Get the Training Data
feat <- read.table("features.txt", header=FALSE)
xtrain <- read.table("train/X_train.txt", header=FALSE)
colnames(xtrain) <- feat[,2]
ytrain <- read.table("train/Y_train.txt", header=FALSE)
colnames(ytrain) <- "Act_ID"
strain <- read.table("train/subject_train.txt", header=FALSE)
colnames(strain) <- "Subject_Id"
actType <- read.table("activity_labels.txt", header=FALSE)
colnames(actType) <- c('Act_ID','Act_Type')

## Get the Testing Data
xtest <- read.table("test/X_test.txt", header=FALSE)
colnames(xtest) <- feat[,2]
ytest <- read.table("test/Y_test.txt", header=FALSE)
colnames(ytest) <- "Act_ID"
stest <- read.table("test/subject_test.txt", header=FALSE)
colnames(stest) <- "Subject_Id"

## Merge the Training Set into the full table
trainData <- cbind(ytrain, strain, xtrain)
testData <- cbind(ytest, stest, xtest)

## Merge Training and Test Sets for Target Final Data Set 
targetData <- rbind(trainData, testData)

## Grep out the Mean and STD Columns
targetDataNames = colnames(targetData)
targetMeans <- as.vector(grep("mean", targetDataNames, value=TRUE))
targetStd <- as.vector(grep("std", targetDataNames, value=TRUE))
nameslist <- append(targetMeans, targetStd)
Act_Sub <- c("Act_ID","Subject_Id")
nameslist <- append(Act_Sub,nameslist)

## Create the Final Subsetted Data Set
targetDataSubset <- subset(targetData, select = nameslist)

## Create the Tidy Data Set
library(dplyr)
tidyData <- merge(targetDataSubset, actType, by="Act_ID", all.x=TRUE)
## tidyNoActivity <- tidyData[, names(tidyData) != 'Act_Type']
tidyAverages <- tidyData %>% group_by(Act_Type, Subject_Id) %>% summarise_each(funs(mean))

## Cleaning up the Column Names
tidyColumns <- colnames(tidyAverages)
tidyColumns
for (i in 1:length(tidyColumns))
{
  tidyColumns[i] = gsub("-std()","_Standard_Deviation",tidyColumns[i])
  tidyColumns[i] = gsub("-mean()", "_Mean", tidyColumns[i])
  tidyColumns[i] = gsub("\\()","", tidyColumns[i])
  tidyColumns[i] = gsub("^(t)","Time_", tidyColumns[i])
  tidyColumns[i] = gsub("^(f)","Frequency_", tidyColumns[i])
  tidyColumns[i] = gsub("Mag","Magnitude_", tidyColumns[i])
}
tidyColumns

colnames(tidyAverages) <- tidyColumns

## Export tidyAverages
write.table(tidyAverages, "tidyAverages.txt", row.name=FALSE)
