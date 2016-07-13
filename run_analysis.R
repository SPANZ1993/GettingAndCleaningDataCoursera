library(reshape2)

file <- "getdata_dataset.zip"

if(!file.exists(filename)){
      fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileUrl, filename, method = "curl")
}
if(!file.exists("UCI HAR Dataset")){
      unzip(filename)
}

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])

features <- read.table("UCI HAR Dataset/features.txt")
features <- as.character(features[,2])
featuresIndex <- grep(".*mean.*|.*std.*", features)
features <- features[featuresIndex]
features = gsub('[-()]', '', features)
features = tolower(features)

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresIndex]
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
train_complete <- cbind(subject_train, y_train, x_train)

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresIndex]
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
test_complete <- cbind(subject_test, y_test, x_test)

fullData <- rbind(train_complete, test_complete)
colnames(fullData) <- c("subject", "activity", features)

fullData$activity <- factor(fullData$activity, levels = activity_labels[,1], labels = activity_labels[,2])
fullData$subject <- as.factor(fullData$subject)

meltedData <- melt(fullData, id = c("subject", "activity"))
meanData <- dcast(meltedData, subject + activity ~ variable, mean)

write.table(meanData, "cleanData.txt", row.names = FALSE, quote = FALSE)