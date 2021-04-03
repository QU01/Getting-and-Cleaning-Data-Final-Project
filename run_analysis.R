
install.packages("tidyr")
library(tidyr)


url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


download.file(url = url, destfile = "/root/RStudio/GettinLastProject/dataset.zip")


unzip("/root/RStudio/GettinLastProject/dataset.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = ".", unzip = "internal",
      setTimes = FALSE)

x_train <- read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",header=FALSE)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE)


x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE)

colnames(x_test) <- colnames(x_train)
colnames(subject_test) <- colnames(subject_train)


x_data <- rbind(x_train, x_test) 
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

features <- read.table("UCI HAR Dataset/features.txt")

x_data2 <- x_data[, grep("-(mean|std)\\(\\)", features[, 2])]
names(x_data2) <- features[grep("-(mean|std)\\(\\)", read.table("UCI HAR Dataset/features.txt")[, 2]), 2] 


write.table(tidyData, "final_dataset.csv")

y_data[, 1] <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="")[y_data[, 1], 2]

names(y_data) <- "Activity"

names(subject_data) <- "Subject"

data <- cbind(x_data2, y_data, subject_data)

names(data) <- make.names(names(data))

names(data) <- gsub('^t'," Time of ", names(data))
names(data) <- gsub('^f'," Frequency of ", names(data))
names(data)<-gsub("\\.std()", " standard deviation ", names(data))
names(data)<-gsub("\\.mean()", " mean value ", names(data))
names(data) <- gsub('Acc'," Acceleration ",names(data))
names(data)<-gsub("Gyro", " Angular ", names(data))
names(data)<-gsub("-X$", "", names(data))


data3 <-aggregate(. ~Subject + Activity, data, mean)

data3 <-data3[order(data3$Subject,data3$Activity),]

