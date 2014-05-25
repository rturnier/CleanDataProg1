
#############################################################################################
#       Purpose :       To returns one dataset after combining the x, y, subject ids.
#       Parameters :    fnameSuffix - train or test
#                       dirName - directory where downloaded datasets reside
#       Other :         filter data to extract only measurements on mean and std values
#                       filter is done to reduce memory size needed
############################################################################################
getData <- function(fnameSuffix, dirName) {
        fpath <- file.path(dirName, paste0("y_", fnameSuffix, ".txt"))
        yData <- read.table(fpath, header=F, col.names=c("ActivityID"))
        
        fpath <- file.path(dirName, paste0("subject_", fnameSuffix, ".txt"))
        subjectData <- read.table(fpath, header=F, col.names=c("SubjectID"))
        
        # read the column names
        colNames <- read.table("features.txt", header=F, as.is=T, col.names=c("MeasureID", "MeasureName"))
        
        # read the X data file
        fpath <- file.path(dirName, paste0("X_", fnameSuffix, ".txt"))
        data <- read.table(fpath, header=F, col.names=colNames$MeasureName)
        
        # names of subset columns required
        ssColNames <- grep(".*mean\\(\\)|.*std\\(\\)", colNames$MeasureName)
        
        # subset the data (done early to save memory)
        data <- data[,ssColNames]
        
        # append the activity id and subject id columns
        data$ActivityID <- yData$ActivityID
        data$SubjectID <- subjectData$SubjectID
        
        # return the data
        data
}
###########################################################################################
#       Purpose:        read test data set, in a folder named "test", and data file names 
#                       suffixed with "test"
############################################################################################
getTestData <- function() {
        message("Reading test data ...")
        getData("test", "test")
}

###########################################################################################
#       Purpose:        read test data set, in a folder named "train", and data file names 
#                       suffixed with "train"
############################################################################################

getTrainData <- function() {
        message("Reading train data ...")
        getData("train", "train")
}

###########################################################################################
#       Purpose:        Merge both train and test datasets and change col names
############################################################################################

mergeData <- function() {
        
        data <- rbind(getTestData(), getTrainData())
        
        message ("Merging train and test datasets ...")
        
        cnames <- colnames(data)
        cnames <- gsub("\\.+mean\\.+", cnames, replacement="Mean")
        cnames <- gsub("\\.+std\\.+", cnames, replacement="Std")
        colnames(data) <- cnames
        data
}

###########################################################################################
#       Purpose:        Add the activity names as another column
############################################################################################


applyActivityLabel <- function(data) {
        activity_labels <- read.table("activity_labels.txt", 
                                      header=F, as.is=T, 
                                      col.names=c("ActivityID", "ActivityName"))
        activity_labels$ActivityName <- as.factor(activity_labels$ActivityName)
        data_labeled <- merge(data, activity_labels)
        data_labeled
}

###########################################################################################
#       Purpose:        Combine training and test data sets and add the activity label as
#                       another column
############################################################################################

getMergedLabeledData <- function() {
       
        applyActivityLabel(mergeData())
       
}

# 
###########################################################################################
#       Purpose:        Create a tidy data set that has the average of each variable for 
#                       each activity and each subject.ombine training and test data sets 
#                       and add the activity label as another column
############################################################################################

getTidyData <- function(mergedLabelData) {
        
        
        # melt the dataset
        id_vars = c("ActivityID", "ActivityName", "SubjectID")
        measure_vars = setdiff(colnames(mergedLabelData), id_vars)
        melted_data <- melt(mergedLabelData, id=id_vars, measure.vars=measure_vars)
        
        # recast
        dcast(melted_data, ActivityName + SubjectID ~ variable, mean)
}

# Create the tidy data set and save it on to the named file
wrtieDataSet <- function(fname) {
        
        tidyData <- getTidyData(getMergedLabeledData())
        
        message("Writing data to file ...")        
        
        write.table(tidyData, fname)
}
#####################################################################################
##              -== Start Here ==-
#####################################################################################
# loading required packages - if not installed please install before runnin script
#   
#       to install : > install.packages("reshape2")

require (reshape2)

message("Please wait ...")

wrtieDataSet("mergedData.txt")

message ("Complete")
