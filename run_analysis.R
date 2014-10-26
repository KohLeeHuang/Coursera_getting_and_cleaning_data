## Coursera - Getting and Cleaning Data
## Course Assignment 
## R script : run_analysis.R


## Requirements prior to running the Script
## -----------------------------------------
## This script is written and run 3 times on a Windows system.
## If you are using a Mac or Linux system, please change the 
## directory and read.table commands to enable running on your system

## To run this script, you will need to download and install the
## following packages:

library(plyr)
library(reshape2)


## Set the Directory Path to folder containing the data 
## (please change as required to access the data in your directory)

dir <- "C:/Users/KLH/coursera/datascience/getting_and_cleaning_data/klhproject/UCI_HAR_Dataset/"
setwd(dir)


## Step 1. Merges the training and the test sets to create one dataset
## --------------------------------------------------------------

## i) Read and combine the following training sets into one dataframe 
##    'train/subject_train.txt': Each row identifies the subject who 
##    performed the activity for each window sample. Range: 1 to 30
##    'train/y_train.txt': Training labels
##    'train/X_train.txt': Training dataset

train_subjects <- read.table(paste0(dir, "train/subject_train.txt"), col.names = "subject", sep = "")
train_labels <- read.table(paste0(dir, "train/y_train.txt"), col.names = "activity", sep = "")
train_data <- read.table(paste0(dir, "train/X_train.txt"), sep = "")

train_df <- cbind(train_subjects, train_labels, train_data)

## ii) Read and combine the following test sets into one dataframe
##     'test/subject_test.txt': Each row identifies the subject who 
##     performed the activity for each window sample. Range: 1 to 30
##     'test/y_test.txt': Test labels
##     'test/X_test.txt': Test dataset

test_subjects <- read.table(paste0(dir, "test/subject_test.txt"), col.names = "subject", sep = "")
test_labels <- read.table(paste0(dir, "test/y_test.txt"), col.names = "activity", sep = "")
test_data <- read.table(paste0(dir, "test/X_test.txt"), sep = "")

test_df <- cbind(test_subjects, test_labels, test_data)

## iii) Merge the two dataframes, train_df and test_df

merged_df <- rbind(train_df, test_df)


## Step 2. Uses descriptive activity names to name the activities in the dataset
## ------------------------------------------------------------------------
## (Note: This is specified as 3rd step in the course project description. 
## In my script, I choose to perform Steps 3 and 4 first which makes it
## easier to extract the required measurements (i.e. variables))

## i) Read the activity labels and change them to lowercase

activity <- read.table(paste0(dir, "activity_labels.txt"), col.names = c("num", "name"), sep = "")
activity$name <- tolower(activity$name)

## ii) Replace the column "activity" in the merged dataframe with  
##     the descriptive activity names

merged_df$activity <- factor(merged_df$activity, levels = activity$num, labels = activity$name)


## Step 3. Appropriately labels the data set with descriptive variable names
## -------------------------------------------------------------------------

## i) Read the features.txt for use as variable names

features <- read.table(paste0(dir, "features.txt"), col.names = c("num", "varname"), sep = "")

## ii) Tidy up the variable names for the required variables to make
##     them more suitable for R and sync with the 
##     (Note: I assigned the same vector name in using gsub as I have
##      the tendency to make mistakes in using the wrong vector
##      names after 2-3 iterations of similar codes)

features$varname <- gsub("-", "", features$varname)
features$varname <- gsub("[()]", "", features$varname)
features$varname <- gsub("mean", "Mean", features$varname)
features$varname <- gsub("std", "StandardDeviation", features$varname)
features$varname <- gsub("tBody", "timeBody", features$varname)
features$varname <- gsub("tGravity", "timeGravity", features$varname)
features$varname <- gsub("fBody", "freqBody", features$varname)
features$varname <- gsub("Acc", "Acceleration", features$varname)
features$varname <- gsub("Gyro", "AngularVelocity", features$varname)
features$varname <- gsub("Mag", "Magnitude", features$varname)
features$varname <- gsub("BodyBody", "Body", features$varname)


## iii) Change the class of the variable names unders "varname" 
##      from "factor" to "character"

varnames <- as.character(features$varname)  

## iv) Labels the variables (columns) in the merged dataframe with the 
##     descriptive variable names

id_cols <- c("subject", "activity")
names(merged_df) <- c(id_cols, varnames)


## Step 4. Extract only the measurements on the mean and standard 
##         deviation for each measurement
## ---------------------------------------------------------------
## (Note: In the features_info.txt, the mean and standard deviation 
## variables are defined as mean() and std() respectively. Hence, 
## I will only extract these variables.)
 
## i) Find columns with variables measuring the mean or standard 
##    deviation, but exclude meanFreq()

meas_cols <- grep("Mean|StandardDeviation", names(merged_df), value = TRUE) 
meas_cols1 <- meas_cols[!grepl("MeanFreq", meas_cols)]
meas_cols2 <- meas_cols1[!grepl("gravityMean", meas_cols1)]
meas_cols3 <- meas_cols2[!grepl("Mean,gravity", meas_cols2)]

## ii) Create the new dataframe with only the selected columns

meanstd_df <- merged_df[c(id_cols, meas_cols3)]

## iii) Arrange the new dataframe by subject and then by activity 
##      (optional - I performed this step to make the data more orderly)

meanstd_df <- arrange(meanstd_df, subject, activity)


## Step 5. Create a second independent dataset with the average of
## each variable for each activity and each subject

## i) Melt and recast the dataframe with the average of each variable
##    for each activity and each subject

meltdata <- melt(meanstd_df, id = id_cols, measure.vars = meas_cols3)
tidydata <- dcast(meltdata, subject + activity ~ variable, mean)

## ii) Write to text file "tidydata2.txt"

write.table(tidydata, "../tidydata.txt", row.name = FALSE)

## (Optional) View the tidy data, running the commands below one at a time
str(tidydata)
head(tidydata, n=3)
tail(tidydata, n=3)


## End of script
