##Initializing and loading necessary packages
library(data.table)

##Creating a temp file to download the zip file to
temp <- tempfile()

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)

##Getting the list of files available
unzip(temp, list = TRUE)

##Reading and storing the test related data sets in respective objects
XTest <- read.table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"))
YTest <- read.table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"))
SubjectTest <- read.table(unzip(temp, "UCI HAR Dataset/test/subject_test.txt"))

##Reading and storing the train related data sets in respective objects
XTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"))
YTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"))
SubjectTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/subject_train.txt"))

##Reading and storing features data set
Features <- read.table(unzip(temp, "UCI HAR Dataset/features.txt"))

## Reading and storing activity labels:
activityLabels = read.table(unzip(temp, "UCI HAR Dataset/activity_labels.txt"))

##Deletes or unlinks the temp table
unlink(temp)

##Setting column names
colnames(XTrain) <- Features[,2] 
colnames(YTrain) <-"activities"
colnames(SubjectTrain) <- "participants"

colnames(XTest) <- Features[,2] 
colnames(YTest) <- "activities"
colnames(SubjectTest) <- "participants"

colnames(activityLabels) <- c('activities','activityType')

##Merging data sets
train <- cbind(YTrain, SubjectTrain, XTrain)
test <- cbind(YTest, SubjectTest, XTest)
mergedset <- rbind(train, test)

##Gathering the measurements on mean and  STD on the mergedset data set

##This doesn't cover all the variables in the mergedset data set (esp. 471:477)
Mean <- grep("mean()", names(mergedset), value = FALSE, fixed = TRUE)
##This is because, in 471:477 mean is represented in a different way
Mean <- append(Mean, 471:477)
MeanMatrix <- mergedset[Mean]

##For STD
STD <- grep("std()", names(mergedset), value = FALSE)
STDMatrix <- mergedset[STD]

##Setting activity names
DescActNames <- merge(mergedset, activityLabels,
                              by='activities',
                              all.x=TRUE)

##Labeling the variable names appropriately
mergedset$activities=DescActNames$activityType

##Converting this variable to a character to add a prefix to the integer as below
mergedset$participants <- as.character(mergedset$participants)

mergedset$participants = paste("Participant", mergedset$participants, sep = " ")

##Labeling appropriate descriptive variable names
names(mergedset) <- gsub("Acc", "Accelerator", names(mergedset))
names(mergedset) <- gsub("Mag", "Magnitude", names(mergedset))
names(mergedset) <- gsub("Gyro", "Gyroscope", names(mergedset))
names(mergedset) <- gsub("^t", "time", names(mergedset))
names(mergedset) <- gsub("^f", "frequency", names(mergedset))

##Creating a tidy dataset
mergedsetdt <- data.table(mergedset)
#This takes the mean of every column broken down by participants and activities
TidyData <- mergedsetdt[, lapply(.SD, mean), by = 'participants,activities']
write.table(TidyData, file = "Tidy.txt", row.names = FALSE)