if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip?accessType=DOWNLOAD"
download.file(fileUrl, destfile="./data/proj.zip")

unzip(zipfile="./data/proj.zip", exdir="./data")

path <- file.path("./data/proj", "UCI HAR Dataset")
myfile <- list.files(path, recursive = TRUE)
myfile

TestActivity <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
TrainActivity <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)

TestSubject <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
TrainSubject <- read.table(file.path(path, "train" , "subject_train.txt"),header = FALSE)

TestFeature <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
TrainFeature <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

str(TestActivity)

str(TrainActivity)

str(TestSubject)

str(TrainSubject)

str(TestFeature)

str(TrainFeature)

# Following code Concatenate the data tables by rows

Activity <- rbind(TrainActivity, TestActivity)

Subject <- rbind(TrainSubject, TestSubject)

Feature <- rbind(TrainFeature, TestFeature)

# Following code set names to variables

names(Subject) <- c("subject")

names(Activity)<- c("activity")

FeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)

names(Feature)<- FeaturesNames$V2

# Following code Merge columns to get the data frame Data for all data

Combine <-  cbind(Subject, Activity)

finaldata <- cbind(Feature, Combine)

# Subset Name of Features by measurements on the mean and standard deviation

subsFeaturesNames <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]

#Subset the data frame Data by seleted names of Features

selectNames <- c(as.character(subsFeaturesNames), "subject", "activity" )
Data <- subset(finaldata, select =selectNames )

str(Data)

activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

head(Data$activity,30)

names(Data)

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)

# Creates a second,independent tidy data set
library(plyr);
Datanew<-aggregate(. ~subject + activity, Data, mean)
Datanew<-Datanew[order(Datanew$subject,Datanew$activity),]
write.table(Datanew, file = "tidydata.txt",row.name=FALSE)

library(knitr)
knit2html("CodeBook.md")


