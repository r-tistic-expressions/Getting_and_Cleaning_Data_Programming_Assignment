## Getting & Cleaning Data Project 

## Import necessary libraries
library(dplyr)

## Load all of the training data from text file to data table then assign column names where applicable.
feat <- read.table("features.txt", header=FALSE)
xtrain <- read.table("train/X_train.txt", header=FALSE)
colnames(xtrain) <- feat[,2]
ytrain <- read.table("train/Y_train.txt", header=FALSE)
colnames(ytrain) <- "Act_ID"
strain <- read.table("train/subject_train.txt", header=FALSE)
colnames(strain) <- "Subject_Id"
actType <- read.table("activity_labels.txt", header=FALSE)
colnames(actType) <- c('Act_ID','Act_Type')

## Load all of the testing data from text file to data table then assign column names where applicable.
xtest <- read.table("test/X_test.txt", header=FALSE)
colnames(xtest) <- feat[,2]
ytest <- read.table("test/Y_test.txt", header=FALSE)
colnames(ytest) <- "Act_ID"
stest <- read.table("test/subject_test.txt", header=FALSE)
colnames(stest) <- "Subject_Id"

## Merge the associated files for both the training and testing data sets
trainData <- cbind(ytrain, strain, xtrain)
testData <- cbind(ytest, stest, xtest)

## Merge the training and testing sets together to create target data set
targetData <- rbind(trainData, testData)

## User regx to pull out columns with Mean and Standard Deviation variables
targetDataNames = colnames(targetData) # get list of all column names
targetMeans <- as.vector(grep("mean", targetDataNames, value=TRUE)) ## subset vector of column names with "mean" in name
targetStd <- as.vector(grep("std", targetDataNames, value=TRUE)) ## subset vector of column names with "std" in name
nameslist <- append(targetMeans, targetStd) ## append the Means and STD vectors for list of column names to use
Act_Sub <- c("Act_ID","Subject_Id") ## simple vector with Activity ID and Subject ID needed for future processing
nameslist <- append(Act_Sub,nameslist) ## append the Activity ID and Subject ID with the nameslist of Means/StD columns

## Create the Final Subsetted Data Set
targetDataSubset <- subset(targetData, select = nameslist) ## create the subsetted target data set with the specified columns

## Create the Tidy Data Set
tidyData <- merge(targetDataSubset, actType, by="Act_ID", all.x=TRUE) ## join the target subset with the Activity Type joined on Act_ID
tidyAverages <- tidyData %>% group_by(Act_Type, Subject_Id) %>% summarise_each(funs(mean)) ## aggregate (mean) the tidyData by Activity type and Subject ID 

## Cleaning up the Column Names
tidyColumns <- colnames(tidyAverages) ## create a list of current column names
for (i in 1:length(tidyColumns)) ## Loops through the column names to change names to more meaningful descriptions
{
  tidyColumns[i] = gsub("-std()","_Standard_Deviation",tidyColumns[i]) # changes std to "Standard_Deviation"
  tidyColumns[i] = gsub("-mean()", "_Mean", tidyColumns[i]) # changes mean to "Mean"
  tidyColumns[i] = gsub("\\()","", tidyColumns[i]) # removes excess special characters at end of column names
  tidyColumns[i] = gsub("^(t)","Time_", tidyColumns[i]) ## changes first character "t" to "Time"
  tidyColumns[i] = gsub("^(f)","Frequency_", tidyColumns[i]) # changes first character "f" to "Frequency"
  tidyColumns[i] = gsub("Mag","Magnitude_", tidyColumns[i]) # changes "mag" to "Magnitude"
}
colnames(tidyAverages) <- tidyColumns # Assigns cleaned column names to tidyAverages data set. 

## Export tidyAverages
write.table(tidyAverages, "tidyAverages.txt", row.name=FALSE) # writes tidyAverages table to text file. 
