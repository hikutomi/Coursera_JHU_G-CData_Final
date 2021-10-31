# Coursera_JHU_G-CData_Final
Coursera, JOHNS HOPKINS UNIVERSITY Data Science, Getting &amp; Cleaning Data Final Project (WK4Assignment)\

1). Overview\
This project is to collect, work with, and clean a data set. The data set are collected from the accelerometers from the Samsung Galaxy S smartphone.\
The data are downloaded from the website below and saved in the current folder.\
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip \

2). Submit files\
 - README.md\
 - run_analysis.R\
 - CodeBook.Rmd\
 - CodeBook.pdf\
 - selectedGroupedSummary.txt\

3). run_analysis.R\
The R file was created to follow below guideline.\
 - 1. Merges the training and the test sets to create one data set.\
 - 2. Extracts only the measurements on the mean and standard deviation for each measurement.\
 - 3. Uses descriptive activity names to name the activities in the data set\
 - 4. Appropriately labels the data set with descriptive variable names.\
 - 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.\

please refer to the "CodeBook" for the detailed explanation.\

4). Tidiness of the final output "selectedGroupedSummary".\
According to Hadley Wickham, Tidy Data must satisfy three conditions below.\
 - 1. Each variable forms a column.\
 - 2. Each observation forms a row.\
 - 3. Each type of observational unit forms a table\

"dataAll" is a tidy data table, since it meets all of the tree conditions of tidiness of data. Specifically, (1) each variables, "Subject", "Activity", and 561 measurement variables, e.g."tBodyAcc-mean()-X" has its own column. (2) There are 10,299 observations having its own row. (3) Each value has its own cell.\

Final output "selectedGroupedSummary", consisting of 180 rows and 20 columns, is also tidy, since it was derived from tidy dataset "dataAll", and average values of the "selectedGroupedSummary" were calculated along selected measurement variables.\

5). Verification of the "selectedGroupedSummary"\
The final output file, "selectedGroupedSummary.txt" can be read into R with such code as below.\
read.table("selectedGroupedSummary.txt", header=TRUE)\

(end of file)\
