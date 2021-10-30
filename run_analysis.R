## DataCleaning Week4 V4
library(data.table)
library(dplyr)

## To read relvant files. 
## Please create "test" and "train" directory in reviewer's wd and store
## the relevant data to verify my program (below is my setting wd).
## setwd("~/coursera/JHU_Getting&CleanData/Week4_Assgmnt/UCI_HAR_Dataset/")
## getting original files and store them in each data table.
data_X_test <- fread("./test/X_test.txt")
data_y_test <- fread("./test/y_test.txt")
data_subject_test <- fread("./test/subject_test.txt")

data_X_train <- fread("./train/X_train.txt")
data_y_train <- fread("./train/y_train.txt")
data_subject_train <- fread("./train/subject_train.txt")

data_activity_labels <- fread("activity_labels.txt")
data_features <- fread("features.txt")
## end of storing in the data tables.

## 1). Merges the training and the test sets to create one data set.
## 1-1). "test" is the horizontally combined table consisting of measurement, 
## Subject, and Activity tables. Names of the "Test" is assigned appropriately.
names(data_X_test) <- data_features$V2
test <- cbind(data_subject_test, data_y_test)
test <- cbind(test, data_X_test)
names(test)[1] <- "Subject"
names(test)[2] <- "Activity"

## 1-2). "train" is the horizontally combined table consisting of measurement, 
## Subject, and Activity tables. Names of the "Train" is assigned appropriately.
names(data_X_train) <- data_features$V2
train <- cbind(data_subject_train, data_y_train)
train <- cbind(train, data_X_train)
names(train)[1] <- "Subject"
names(train)[2] <- "Activity"

## 1-3). "dataAll" table is created such that test" and "train" were combined vertically.
dataAll <- rbind(test, train)

## 2). Extracts only the measurements on the mean and standard deviation for each measurement. 
## 2-1). "g" is extracted character Values that end as "mean()" or "std()" from the "features" .
g <- grep("mean\\(\\)$|std\\(\\)$", data_features$V2, value=TRUE)

## 2-2). "selected" table is the subset of "Subject", "Activity", and all of the measurements
## that has name included in "g".
selected <- select(dataAll, Subject, Activity, all_of(g))


## 3). Uses descriptive activity names to name the activities in the data set
## 3-1). "f" function is created to replace numerical values of "Acivity" to descriptive names, e.g. 
##       "WALKING".
f <- function(num){
  if(num == 1){"WALKING"}
  else if(num == 2){"WALKING_UP"}
  else if(num == 3){"WALKING_DW"}
  else if(num == 4){"SITTING"}
  else if(num == 5){"STANDING"}
  else if(num == 6){"LAYING"}
  else "error"
}

## 3-2). To execute the function "f" using "lapply". 
activityNames <- lapply(selected$Activity, f)
activityNames <- unlist(activityNames)
selected$Activity <- activityNames

## 4). Appropriately labels the data set with descriptive variable names.
##     To remove "-" and"()" and adjust names of measurement variables of "selected" table. 
valueNames <- names(selected)
valueNames <- sub("-std\\(\\)$", "Std", valueNames)
valueNames <- sub("-mean\\(\\)$", "Mean", valueNames)
names(selected) <- valueNames

## 5). From the data set in step 4, creates a second, independent tidy data set
##     with the average of each variable for each activity and each subject.
## 5-1). To group "Subject", and "Activity" variables and creates "selectedGrouped" table.
selectedGrouped <- group_by(selected, Subject, Activity)

## 5-2). To calculate average of grouped table and creates "selectedGroupedSummary" table.
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

## To View "selectedGroupedSummary" table and save it as a text file in the wd.
View(selectedGroupedSummary)
write.table(selectedGroupedSummary, "selectedGroupedSummary.txt")