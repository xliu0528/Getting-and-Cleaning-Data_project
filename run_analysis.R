##Project
##1. Merges the training and the test sets to create one data set.
getwd()
setwd("/Users/Penny/Desktop/Getting and Cleaning Data")
if(!file.exists("./data/UCI HAR Dataset")){dir.create("./data/UCI HAR Dataset")}
setwd("./data/UCI HAR Dataset")

x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
sub_test <- read.table("./test/subject_test.txt")
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
sub_train <- read.table("./train/subject_train.txt")
mergedx <- rbind(x_test, x_train)
dim(mergedx)
mergedy <- rbind(y_test, y_train)
dim(mergedy)
mergedsub <- rbind(sub_test, sub_train)
dim(mergedsub)

##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("./features.txt")
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
mean_std_features

##3. Uses descriptive activity names to name the activities in the data set
activity <- read.table("./activity_labels.txt")
head(activity)
mergedy[, 1] <- activity[mergedy[, 1], 2]
names(mergedy) <- "activity"
head(mergedy)

##4. Appropriately labels the data set with descriptive variable names. 
names(mergedsub) <- "subject"
final <- cbind(mergedx, mergedy, mergedsub)
dim(final)
head(final)
write.table(final, "final.txt", sep="\t")

##5. From the data set in step 4, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject.
library(reshape2)
melt <- melt(final, id=c("activity", "subject"))
head(melt)
tail(melt)
tidy <- dcast(melt, activity + subject ~ variable, mean)
head(tidy)
write.table(tidy, file = "./tidy.txt")
