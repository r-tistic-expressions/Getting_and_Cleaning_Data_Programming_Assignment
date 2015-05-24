Read Me for Getting & Cleaning Data Programming Assignment
=========================

### Overview

This file was written to describe the content and structure of the run_analysis.R and codebook.md files for the Coursera course "Getting and Cleaning Data" programming assignment. 

---

### run_analysis.R

This file is the sole script for executing the data cleansing project. 

### Section 1: Loading Data and Assigning Column Names
This code loads all of the data associated with the project from both the Test and Train folders. Data loaded include:
* features.txt
* x_train.txt
* y_train.txt
* subject_train.txt
* activity_labels.txt
* x_test.txt
* y_test.txt
* subject_test.txt

After data is loaded the train and test sets are combined via rbind to create the target data set.

### Section 2: Subset the Target Data for Mean and Standard Deviation Fields
This code gets a list of the column names and then uses Regular Expressions to find the columns that include mean and stdev values. 

The list of mean/stdev columns is then used to subset the target data into targetDataSubset for further processing. 

### Section 3: Create the Tidy Data Set
This code starts with taking the targetDataSubset and joining it to the Activity Type table.

After the join the code uses dplyr's group_by and summarise_each functions to create the aggregated table for all meanStdev values by Act_Type and Subject_ID.

### Section 4: Create Meaningful Column Names
This code uses Regular Expressions to adjust the column names into more meaningful descriptors. The code loops through the column names and edits the string depending on if there was a match with an associated change. 

### Section 5: Export the Tidy Averages Text File
This code writes a text file to the working directory with the name "tidyAverages.txt". 