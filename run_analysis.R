#You should create one R script called run_analysis.R that does the following.

#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each 
#measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.

#set working directory
path <- getwd()
setwd(path)


##Labels and Column Names.

#Read activity labels and column names
activitylabels <- read.table("~/Desktop/UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("~/Desktop/UCI HAR Dataset/features.txt")[,2]
#Extract only the measurements on the mean and standard deviation for each measurement.
extractfeatures <- grepl("mean|std", features)


##Test Data

#Read test data.
X_test <- read.table("~/Desktop/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("~/Desktop/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("~/Desktop/UCI HAR Dataset/test/subject_test.txt")
names(X_test) <- features
#Extract only the measurements on the mean and standard deviation for each measurement.
X_test <- X_test[,extractfeatures]
#Apply activity labels
y_test[,2] <- activitylabels[y_test[,1]]
names(y_test) <- c("Activity_ID", "Activity_Label")
names(subject_test) <- "subject"
#Merge test data
testdata <- cbind(as.data.table(subject_test), y_test, X_test)


##Train Data

#Read train data.
X_train <- read.table("~/Desktop/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("~/Desktop/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("~/Desktop/UCI HAR Dataset/train/subject_train.txt")
names(X_train) = features
#Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extractfeatures]
#Apply activity data
y_train[,2] = activitylabels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"
#Merge train data
traindata <- cbind(as.data.table(subject_train), y_train, X_train)


##Merge Test and Train Data
mergeddata <- rbind(testdata, traindata)
#Apply labels
id_labels   <- c("subject", "Activity_ID", "Activity_Label")
data_labels <- setdiff(colnames(mergeddata), id_labels)
data  <- melt(mergeddata, id = id_labels, measure.vars = data_labels)


##Create Tidy Data Set
tidydata   <- dcast(data, subject + Activity_Label ~ variable, mean)
#Write txt file
write.table(tidydata, file = "./tidydata.txt", row.name=FALSE)