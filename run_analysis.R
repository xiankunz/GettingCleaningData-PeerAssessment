##########
##  R script file to create the tidy data set.
##   You should create one R script called run_analysis.R that does the following. 
##  1. Merges the training and the test sets to create one data set.
##  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##  3. Uses descriptive activity names to name the activities in the data set
##  4. Appropriately labels the data set with descriptive activity names. 
##  5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
## Source of data for the project:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# Merges the training and the test sets to create one data set X.
trainset <- read.table("UCI HAR Dataset/train/X_train.txt")
testset <- read.table("UCI HAR Dataset/test/X_test.txt")
datax <- rbind(trainset, testset)

headertable <- read.table("UCI HAR Dataset/features.txt")
header <- headertable[ ,"V2"]
names(datax) <- header

# Extracts only the measurements on the mean and standard deviation for each measurement.
datamean <- datax[, grep("-mean()", colnames(datax), fixed = TRUE)]
datastd <- datax[, grep("-std()", colnames(datax), fixed=TRUE)]
datameanstd  <-cbind(datamean, datastd)

trainlabel <- read.table("UCI HAR Dataset/train/y_train.txt")
testlabel <- read.table("UCI HAR Dataset/test/y_test.txt")
datay <- rbind(trainlabel, testlabel)

trainsj <- read.table("UCI HAR Dataset/train/subject_train.txt")
testsj <- read.table("UCI HAR Dataset/test/subject_test.txt")
datas <- rbind(trainsj, testsj)

dataysj <- cbind(datay, datas);
names(dataysj) <- c("activity","subject")

data <- cbind(datameanstd, dataysj);

# Uses descriptive activity names to name the activities in the data set
activity <-read.table("UCI HAR Dataset//activity_labels.txt")
names(activity) <- c("activity","description")

# Appropriately labels the data set with descriptive activity names. 
data$activity <- activity[data$activity,2]

write.table(data, "labeled_output_data.txt")

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Need install.packages("reshape2"); library(reshape2) 
melteddata <- melt(data,id= c("subject","activity"))
tidydata <- dcast(melteddata,subject + activity~ variable,mean)

write.table(tidydata, "tidy_output_data.txt")

####################################################### END
