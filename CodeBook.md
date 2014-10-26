## The Code Book

(Note: I'm referring to the following post on Coursera's discussion forum, "Kirsten's Sample Codebook" (https://class.coursera.org/getdata-008/forum/thread?thread_id=34), as a guide to write this Code Book. )  
<br>

### Introduction

The course project requires the creation of one R script called "run_analysis.R" to tidy up the dataset "Human Activity Recognition Using Smartphones Dataset - Version 1.0":

The R script "run_analysis.R" performs the following: 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation   for each measurement. 
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable name. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  
<br>  
 
### About the Original Data

#### Data Source

The dataset is downloaded from the following link:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Information on the source of the original data are given below:  

Human Activity Recognition Using Smartphones Dataset  
Version 1.0  

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto, November 2012  
Smartlab - Non Linear Complex Systems Laboratory  
DITEN - Università degli Studi di Genova  
Via Opera Pia 11A, I-16145, Genoa, Italy  
activityrecognition@smartlab.ws  
www.smartlab.ws  

  
#### The Experimental Design

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, the researchers captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

Please refer to the 'README.txt' in the downloaded dataset for more details.


#### Features Selection

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals : linear acceleration (tAcc-XYZ) and angular velocity (tBodyGyro-XYZ). These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

The complete list of variables of each feature vector and corresponding information on the variables are available in the 'features.txt' and 'features_info.txt' respectively.  
<br>  

### Cleaning the Data

(Note: Both plyr and reshape2 R packages are used in cleaning the data.)  

##### 1. Merging of the Training and Test Sets into One Dataset

The merging of the training and the test sets were carried out in 3 stages:

i) The following training data files are read into R and merged into one dataframe, train_df:
(Note: all the files each have 7352 obs i.e. rows each)
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.  

    The resulting dataframe has 7352 observations and 563 variables, including the id variables, subject and activity, in the first and second columns.

ii) The following test data files are read into R and merged into one dataframe, test_df:
(Note: All the files each have 2947 obs i.e. rows)
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

    The resulting dataframe has 2947 observations and 563 variables, including the id variables, subject and activity.

iii) The two dataframes are then merged together. 
(Note: The two dataframes each have 563 variables i.e. columns)

    The resulting dataframe has 10299 observations of 563 variables.

##### 2. Using Descriptive Activity Names to Name the Activities in the Dataset

Activity_labels.txt is read into R and the descriptive activity names in the file are transformed to all lower case and used to replace the activity codes (1-6) in the second column of the merged dataframe.

##### 3. Labeling the Dataset with Descriptive Variable Names

Features.txt is read into R and the descriptive variable names in the file are tidied up before they are used to label the variables in the 3rd to 563 columns of the merged dataframe.  

In the features.txt file, the variable names are classed as factor, hence they have to be coerced into character class before applying them as variable names in the merged dataframe.

##### 4. Extracting Only the Measurements on the Mean and Standard Deviation for Each Measurement 

(Note: In the features_info.txt, the mean and standard deviation variables are defined as mean() and std() respectively. Hence, I will only extract these variables.)

Columns containing mean (represented by mean()) and standard deviation variables (represented by std()) were found and extracted using grep() before merging them together in a new dataframe.
The rows of the dataframe are then arranged in ascending order by subject (first column), then by activity (second column).

The resulting dataframe has 10299 observaions of 68 variables, including the id variables, subject and activity.


##### 5. Creating a Second, Independent Tidy Dataset with the Average of Each Variable for Each Activity and Each Subject

The dataframe created from Step 4 above is melted and recasted to create a second, independent tidy dataset with the mean of each variable for each activity and each subject. 

The tidy dataset has 180 observations of 68 variables, including the id variables, subject and activity.

The tidy dataset is then written to a text file, "*tidydata.txt*".  
<br>  

### Description of the Tidy Dataset

The tidy dataset in "tidydata.txt" has 180 observations of 68 variables. 

In the table below , the first column gives the original names of the variables prior to computing the means of each of these variables by each activity and each subject. 

The second column gives the transformed variable names after all the 5 steps in cleaning the dataset have been carried out.  

No.        |	Original Variables (Before data cleaning)	|	Transformed Variables (After data cleaning and computation of mean)	|	Class
---	|	---	|	---	|	---
1	|	subject (id variable, 1 to 30)	|	subject (id variable, 1 to 30)	|	integer
2	|	activity (id variable, with numbers 1 to 6)	|	activity (id variable - walking, walking_upstairs, walking_downstairs, sitting, standing, laying)	|	factor
3	|	tBodyAcc-mean()-X	|	timeBodyAccelerationMeanX	|	numeric
4	|	tBodyAcc-mean()-Y	|	timeBodyAccelerationMeanY	|	numeric
5	|	tBodyAcc-mean()-Z	|	timeBodyAccelerationMeanZ	|	numeric
6	|	tBodyAcc-std()-X	|	timeBodyAccelerationStandardDeviationX	|	numeric
7	|	tBodyAcc-std()-Y	|	timeBodyAccelerationStandardDeviationY	|	numeric
8	|	tBodyAcc-std()-Z	|	timeBodyAccelerationStandardDeviationZ	|	numeric
9	|	tGravityAcc-mean()-X	|	timeGravityAccelerationMeanX	|	numeric
10	|	tGravityAcc-mean()-Y	|	timeGravityAccelerationMeanY	|	numeric
11	|	tGravityAcc-mean()-Z	|	timeGravityAccelerationMeanZ	|	numeric
12	|	tGravityAcc-std()-X	|	timeGravityAccelerationStandardDeviationX	|	numeric
13	|	tGravityAcc-std()-Y	|	timeGravityAccelerationStandardDeviationY	|	numeric
14	|	tGravityAcc-std()-Z	|	timeGravityAccelerationStandardDeviationZ	|	numeric
15	|	tBodyAccJerk-mean()-X	|	timeBodyAccelerationJerkMeanX	|	numeric
16	|	tBodyAccJerk-mean()-Y	|	timeBodyAccelerationJerkMeanY	|	numeric
17	|	tBodyAccJerk-mean()-Z	|	timeBodyAccelerationJerkMeanZ	|	numeric
18	|	tBodyAccJerk-std()-X	|	timeBodyAccelerationJerkStandardDeviationX	|	numeric
19	|	tBodyAccJerk-std()-Y	|	timeBodyAccelerationJerkStandardDeviationY	|	numeric
20	|	tBodyAccJerk-std()-Z	|	timeBodyAccelerationJerkStandardDeviationZ	|	numeric
21	|	 tBodyGyro-mean()-X	|	timeBodyAngularVelocityMeanX	|	numeric
22	|	 tBodyGyro-mean()-Y	|	timeBodyAngularVelocityMeanY	|	numeric
23	|	 tBodyGyro-mean()-Z	|	timeBodyAngularVelocityMeanZ	|	numeric
24	|	 tBodyGyro-std()-X	|	timeBodyAngularVelocityStandardDeviationX	|	numeric
25	|	 tBodyGyro-std()-Y	|	timeBodyAngularVelocityStandardDeviationY	|	numeric
26	|	 tBodyGyro-std()-Z	|	timeBodyAngularVelocityStandardDeviationZ	|	numeric
27	|	 tBodyGyroJerk-mean()-X	|	timeBodyAngularVelocityJerkMeanX	|	numeric
28	|	 tBodyGyroJerk-mean()-Y	|	timeBodyAngularVelocityJerkMeanY	|	numeric
29	|	 tBodyGyroJerk-mean()-Z	|	timeBodyAngularVelocityJerkMeanZ	|	numeric
30	|	 tBodyGyroJerk-std()-X	|	timeBodyAngularVelocityJerkStandardDeviationX	|	numeric
31	|	 tBodyGyroJerk-std()-Y	|	timeBodyAngularVelocityJerkStandardDeviationY	|	numeric
32	|	 tBodyGyroJerk-std()-Z	|	timeBodyAngularVelocityJerkStandardDeviationZ	|	numeric
33	|	 tBodyAccMag-mean()	|	timeBodyAccelerationMagnitudeMean	|	numeric
34	|	 tBodyAccMag-std()	|	timeBodyAccelerationMagnitudeStandardDeviation	|	numeric
35	|	 tGravityAccMag-mean()	|	timeGravityAccelerationMagnitudeMean	|	numeric
36	|	 tGravityAccMag-std()	|	timeGravityAccelerationMagnitudeStandardDeviation	|	numeric
37	|	 tBodyAccJerkMag-mean()	|	timeBodyAccelerationJerkMagnitudeMean	|	numeric
38	|	 tBodyAccJerkMag-std()	|	timeBodyAccelerationJerkMagnitudeStandardDeviation	|	numeric
39	|	 tBodyGyroMag-mean()	|	timeBodyAngularVelocityMagnitudeMean	|	numeric
40	|	 tBodyGyroMag-std()	|	timeBodyAngularVelocityMagnitudeStandardDeviation	|	numeric
41	|	 tBodyGyroJerkMag-mean()	|	timeBodyAngularVelocityJerkMagnitudeMean	|	numeric
42	|	 tBodyGyroJerkMag-std()	|	timeBodyAngularVelocityJerkMagnitudeStandardDeviation	|	numeric
43	|	 fBodyAcc-mean()-X	|	freqBodyAccelerationMeanX	|	numeric
44	|	 fBodyAcc-mean()-Y	|	freqBodyAccelerationMeanY	|	numeric
45	|	 fBodyAcc-mean()-Z	|	freqBodyAccelerationMeanZ	|	numeric
46	|	 fBodyAcc-std()-X	|	freqBodyAccelerationStandardDeviationX	|	numeric
47	|	 fBodyAcc-std()-Y	|	freqBodyAccelerationStandardDeviationY	|	numeric
48	|	 fBodyAcc-std()-Z	|	freqBodyAccelerationStandardDeviationZ	|	numeric
49	|	 fBodyAccJerk-mean()-X	|	freqBodyAccelerationJerkMeanX	|	numeric
50	|	 fBodyAccJerk-mean()-Y	|	freqBodyAccelerationJerkMeanY	|	numeric
51	|	 fBodyAccJerk-mean()-Z	|	freqBodyAccelerationJerkMeanZ	|	numeric
52	|	 fBodyAccJerk-std()-X	|	freqBodyAccelerationJerkStandardDeviationX	|	numeric
53	|	 fBodyAccJerk-std()-Y	|	freqBodyAccelerationJerkStandardDeviationY	|	numeric
54	|	 fBodyAccJerk-std()-Z	|	freqBodyAccelerationJerkStandardDeviationZ	|	numeric
55	|	 fBodyGyro-mean()-X	|	freqBodyAngularVelocityMeanX	|	numeric
56	|	 fBodyGyro-mean()-Y	|	freqBodyAngularVelocityMeanY	|	numeric
57	|	 fBodyGyro-mean()-Z	|	freqBodyAngularVelocityMeanZ	|	numeric
58	|	 fBodyGyro-std()-X	|	freqBodyAngularVelocityStandardDeviationX	|	numeric
59	|	 fBodyGyro-std()-Y	|	freqBodyAngularVelocityStandardDeviationY	|	numeric
60	|	 fBodyGyro-std()-Z	|	freqBodyAngularVelocityStandardDeviationZ	|	numeric
61	|	 fBodyAccMag-mean()	|	freqBodyAccelerationMagnitudeMean	|	numeric
62	|	 fBodyAccMag-std()	|	freqBodyAccelerationMagnitudeStandardDeviation	|	numeric
63	|	 fBodyBodyAccJerkMag-mean()	|	freqBodyAccelerationJerkMagnitudeMean	|	numeric
64	|	 fBodyBodyAccJerkMag-std()	|	freqBodyAccelerationJerkMagnitudeStandardDeviation	|	numeric
65	|	 fBodyBodyGyroMag-mean()	|	freqBodyAngularVelocityMagnitudeMean	|	numeric
66	|	 fBodyBodyGyroMag-std()	|	freqBodyAngularVelocityMagnitudeStandardDeviation	|	numeric
67	|	 fBodyBodyGyroJerkMag-mean()	|	freqBodyAngularVelocityJerkMagnitudeMean	|	numeric
68	|	 fBodyBodyGyroJerkMag-std()	|	freqBodyAngularVelocityJerkMagnitudeStandardDeviation	|	numeric


Notes:  
- Features (variables) are normalized and bounded within [-1,1].  
- CamelCase is used for the transformed variable names to aid reading of the long variable names.



