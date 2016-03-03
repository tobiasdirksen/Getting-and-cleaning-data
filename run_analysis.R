# 1) Merges the training and the test sets to create one data set.

subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subject <- rbind(subject_train, subject_test)
names(subject) <- "subjectId"

x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
X  <- rbind(x_train, x_test)

y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
Y  <- rbind(y_train, y_test)
names(Y) <- "activityId"


# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table('./UCI HAR Dataset/features.txt', header=FALSE, col.names=c('featureId', 'featureLabel'))
idx <- grep('mean\\(\\)|std\\(\\)', features$featureLabel)
X <- X[,idx]
names(X) <- gsub("\\(|\\)", "", features$featureLabel[idx])

# 3) Uses descriptive activity names to name the activities in the data set

activities <- read.table('./UCI HAR Dataset/activity_labels.txt', header=FALSE, col.names=c('activityId', 'activityLabel'))


# 4) Appropriately labels the data set with descriptive variable names. 

Y[,1]=activities[Y[,1],2]

# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

all_data <- cbind(subject,Y,x)
tidy_dataset <- aggregate(X, list(all_data$subject, all_data$activity), mean)
names(tidy_dataset)[1:2] <- c('subject', 'activity')
write.table(tidy_dataset, "final_tidy_dataset.txt",row.name=FALSE)
