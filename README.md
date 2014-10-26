## Getting and Cleaning Data Course Project  
<br>  

### Introduction

This repository contains the Course Project for "Getting and Cleaning Data", which is part of the Johns Hopkins Data Science Specialization on [Coursera](https://www.coursera.org/course/getdata).  
<br>  

### Purpose of the Course Project

The purpose of the Course Project is to demonstrate the student's ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.  
<br>  

### Contents of the Repo

Besides this **README.md** file, the following folder and files are uploaded in this repo:  

1. **UCI_HAR_Dataset folder**, which contains the text files to cleaned up through this project.  
2. **run_analysis.R**, a R script that can be run to tidy up the dataset in (1) above as required in the Course Project.  
3. **CodeBook.md**, a Code Book that describes the variables, the data and the transformations that I performed to clean up the data.  
4. **tidydata.txt**, a text file containing the tidy data produced after running the run_analysis.R script. (I have also uploaded this text file in the Course Project page on Coursera for Peer Assessment.)  
<br>

### Data Source

The UCI_HAR_Dataset used in the Course Project is the "Human Activity Recognition Using Smartphones Dataset Version 1.0", downloaded from the following link:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

As the data files in the dataset are very huge, I have uploaded only the following files within the dataset into this repo:  
- README.txt  
- features.txt  
- features_info.txt  
- activity_labels.txt  

You may refer to the README.md in the UCI_HAR_Dataset or the Code Book in this repo for more information on the dataset.  
<br>  

### Before Running the "run_analysis.R" Script

1. Download the UCI_HAR_Dataset into your working directory for R.   
   You can download the dataset from the url included in the Data Source above.  

2. Read the required data files from the dataset into R for viewing to get a sense of their dimensions, number of observations and variables, class of the variables, any missing values etc.  
   (You can choose to omit this step as I have included the codes to read the data files in the run_analysis.R script, but I think it's good to have a sense of the "raw" data first before the cleaning up.)  
   You can use R codes such as str(), head(), tail(), is.na(), etc. to view the files.  This can help you to choose your approach in merging the separate data files into one dataset, and the type and extent of cleaning you need to perform on the dataset.  

3. Install the *plyr* and *reshape2* package (if you haven't done so).  
   There are codes used in the run_analysis.R that are supported by these packages, hence you will need to install them to run the script smoothly.  

4. Change the directory code (and read.table codes if applicable) to access the UCI_HAR_Dataset in your working directory.
   The run_analysis.R script is written on my Windows system. Please amend the directory code and read.table codes where necessary, especially if you are operating on a Mac system.  
<br>
   
### What the Script Does

The script, run_analysis.R, performs the following:  

##### 1. Merging of the Training and Test Sets into One Dataset

The merging of the training and the test sets were carried out in 3 stages:

i) The following training data files are read into R and merged into one dataframe, train_df:
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.  

ii) The following test data files are read into R and merged into one dataframe, test_df:
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

iii) The two dataframes are then merged together. 

     The resulting dataframe has 10299 observations of 563 variables.

##### 2. Using Descriptive Activity Names to Name the Activities in the Dataset

Activity_labels.txt is read into R and the descriptive activity names in the file are transformed to all lower case and used to replace the activity codes (1-6) in the second column of the merged dataframe.  The new activity names in the merged dataframe are: walking, walking_upstairs, walking_downstairs, sitting, standing, and laying.

##### 3. Labeling the Dataset with Descriptive Variable Names

Features.txt is read into R and the descriptive variable names in the file are tidied up using gsub() code. They are then used to label the variables in the 3rd to 563 columns of the dataframe.  

In the features.txt file, the variable names are classed as factor, hence they have to be coerced into character class before applying them as variable names in the merged dataframe.  

Please refer to the Code Book for more information on the transformed variables.

##### 4. Extracting Only the Measurements on the Mean and Standard Deviation for Each Measurement 

(Note: In the features_info.txt, the mean and standard deviation variables are defined as mean() and std() respectively. Hence, I will only extract these variables.)

Columns containing mean (represented by mean()) and standard deviation variables (represented by std()) were found and extracted using grep() before merging them together in a new dataframe.
The rows of the dataframe are then arranged in ascending order by subject (first column), then by activity (second column).

##### 5. Creating a Second, Independent Tidy Dataset with the Average of Each Variable for Each Activity and Each Subject

The dataframe created from Step 4 above is melted and recasted to create a second, independent tidy dataset with the mean of each variable for each activity and each subject. 

The tidy dataset has 180 observations of 68 variables, including the id variables, subject and activity.

The tidy dataset is then written to a text file, "*tidydata.txt*".  

To read the tidy dataset, "tidydata.txt", into R, you can try using the following code:  
        
data <- read.table(file_path, header = TRUE)

