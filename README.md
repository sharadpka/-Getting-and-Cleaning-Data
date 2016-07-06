# Getting and Cleaning Data Course Project

## Objective
The obective of this project is to collect and bring all the data into R, clean the data and merge data sets and build a tidy data set and save the result to a text file.

## Process

1. Downloads the zip file from the URL location provided to a temp file
2. Unzips the file and loads the train, test, activitylabel, features and subject datasets in their respective R objects and then deletes the temp file
3. Merges the train related datasets and test related data sets first
4. Merges the two main train and test data sets
5. Gathers measurements on mean and STD on the mergedset data set
6. Adds description to activity labels and other common variable names
7. Creates a tidy data set for each activity and subject/participant (as referred to, in my code) and saves it to Tidy.txt

The R code for the above is saved to run_analysis.R
