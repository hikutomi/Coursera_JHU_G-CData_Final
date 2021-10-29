## DataCleaning Week4 V3
library(data.table)  ## to use "fread()"
library(dplyr)

## To read relvant files. (Please appropriately save and change directory of 
## the data files according to your environment.)

setwd("~/coursera/JHU_Getting&CleanData/Week4_Assgmnt/")
rm(list=ls())

setwd("~/coursera/JHU_Getting&CleanData/Week4_Assgmnt/UCI_HAR_Dataset/test/")
data_X_test <- fread("X_test.txt")
data_y_test <- fread("y_test.txt")
data_subject_test <- fread("subject_test.txt")

setwd("~/coursera/JHU_Getting&CleanData/Week4_Assgmnt/UCI_HAR_Dataset/train/")
data_X_train <- fread("X_train.txt")
data_y_train <- fread("y_train.txt")
data_subject_train <- fread("subject_train.txt")

setwd("~/coursera/JHU_Getting&CleanData/Week4_Assgmnt/UCI_HAR_Dataset/")
data_activity_labels <- fread("activity_labels.txt")
data_features <- fread("features.txt")
## End of reading relevant files.

## 1). Merges the training and the test sets to create one data set.
## 1-1). Test data: to horizontally combine data, and names it appropriately
names(data_X_test) <- data_features$V2
test <- cbind(data_subject_test, data_y_test)
test <- cbind(test, data_X_test)
names(test)[1] <- "Subject"
names(test)[2] <- "Activity"

## 1-2). Train data: to horizontally combine data, and names it appropriately
names(data_X_train) <- data_features$V2
train <- cbind(data_subject_train, data_y_train)
train <- cbind(train, data_X_train)
names(train)[1] <- "Subject"
names(train)[2] <- "Activity"

## 1-3). To vertically combine the test and train data.
dataAll <- rbind(test, train)

## 2). Extracts only the measurements on the mean and standard deviation for 
##     each measurement. 
## 2-1). To extract index including "mean()" and "std()" from features data.
g <- grep("mean\\(\\)$|std\\(\\)$", data_features$V2, value=TRUE)

## 2-2). To subset "Subject", "Activity", and all of the extracted index.
selected <- select(dataAll, Subject, Activity, all_of(g))


## 3). Uses descriptive activity names to name the activities in the data set
## 3-1). Create function to replace descriptive names to activity values.
f <- function(num){
  if(num == 1){"WALKING"}
  else if(num == 2){"WALKING_UP"}
  else if(num == 3){"WALKING_DW"}
  else if(num == 4){"SITTING"}
  else if(num == 5){"STANDING"}
  else if(num == 6){"LAYING"}
  else "error"
}

## 3-2). To execute the function and replace activity names of the subset data. 
activityNames <- lapply(selected$Activity, f)
activityNames <- unlist(activityNames)
selected$Activity <- activityNames

## 4). Appropriately labels the data set with descriptive variable names.
##    (To remove "-" and"()" and adjust the names from each mean, std values. 
valueNames <- names(selected)
valueNames <- sub("-std\\(\\)$", "Std", valueNames)
valueNames <- sub("-mean\\(\\)$", "Mean", valueNames)
names(selected) <- valueNames

## 4). From the data set in step 4, creates a second, independent tidy data set
##     with the average of each variable for each activity and each subject.
## 4-1). To group the measurement by "Subject", and "Activity"
selectedGrouped <- group_by(selected, Subject, Activity)

## 4-2). To calculate average of each variable based on the group set.
selectedGroupedSummary <- summarize(selectedGrouped, 
                  mean( tBodyAccMagMean ),mean( tBodyAccMagStd ),
                  mean( tGravityAccMagMean ),mean( tGravityAccMagStd ),
                  mean( tBodyAccJerkMagMean ),mean( tBodyAccJerkMagStd ),
                  mean( tBodyGyroMagMean ),mean( tBodyGyroMagStd ),
                  mean( tBodyGyroJerkMagMean ),mean( tBodyGyroJerkMagStd ),
                  mean( fBodyAccMagMean ),mean( fBodyAccMagStd ),
                  mean( fBodyBodyAccJerkMagMean ),
                  mean( fBodyBodyAccJerkMagStd ),mean( fBodyBodyGyroMagMean ),
                  mean( fBodyBodyGyroMagStd ),mean( fBodyBodyGyroJerkMagMean ),
                  mean( fBodyBodyGyroJerkMagStd )
                  )

## To View summary and save the output in as a text file.
View(selectedGroupedSummary)
write.table(selectedGroupedSummary, "selectedGroupedSummary.txt")