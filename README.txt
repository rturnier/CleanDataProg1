Data :

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

 This R script will : 

    Merges the training and the test sets to create one data set.
    Extracts only the measurements on the mean and standard deviation for each measurement. 
    Uses descriptive activity names to name the activities in the data set
    Appropriately labels the data set with descriptive activity names. 
    Creates a second, independent tidy data set with the average of each variable for each 
    activity and each subject.

output file name :           "mergedData.txt
output file location :  same dir as R script

-------------------------------------------------------------------------------------------------

Data structure :  
        The training and test data are available in folders named `train` and `test` respectively.

        For each of these data sets:
                Measurements are present in `X_<dataset>.txt` file
                Subject information is present in `subject_<dataset>.txt` file
                Activity codes are present in `y_<dataset>.txt` file

        All activity codes and their labels are in a file named `activity_labels.txt`.

        Names of all measurements taken are present in file `features.txt` with linked with a key to 
        the X_<dataset>.txt` files.

        All columns representing means and standard deviations contain `...mean()` and std() respectively in them.
