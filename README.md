# Project Getting Cleaning Data
Getting and Cleaning Data Final Project

The purpose of this project is to collect, work with, and clean a data setHere are the dataset:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The R script called run_analysis.R that does the following:

  1.  Merges the training and the test sets to create one data set.
  2.  Extracts only the measurements on the mean and standard deviation for each measurement.
  3.  Uses descriptive activity names to name the activities in the data set
  4.  Appropriately labels the data set with descriptive variable names.
  5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
Steps to reproduce this project

  1.  Download R script run_analysis.R in the same folder where the dataset is (UCI HAR Dataset). 
  2.  Change your working directory the above mentioned folder (i.e., the folder where the R script file is saved).
  3.  Run the R script using source("run_analysis.R")

Outputs produced

  1. A tidy dataset file called  KPR_Project.txt (tab-delimited text)
