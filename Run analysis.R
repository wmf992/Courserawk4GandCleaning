##Reading the datasets
setwd("./test")
library(data.table)
library(tidyr)
library(dplyr)

#Test data
x_test<-read.table("./Data/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./Data/UCI HAR Dataset/test/y_test.txt")
s_test<-read.table("./Data/UCI HAR Dataset/test/subject_test.txt")

#Train data
x_train<-read.table("./Data/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./Data/UCI HAR Dataset/train/y_train.txt")
s_train<-read.table("./Data/UCI HAR Dataset/train/subject_train.txt")

#Reading features and naming columns from featrues
features<-read.table("./Data/UCI HAR Dataset/features.txt")
setnames(x_test, old = colnames(x_test), new = features$V2)

##Mergin (train, test)
x_data<-rbind(x_train,x_test)
y_data<-rbind(y_train,y_test)
s_data<-rbind(s_train,s_test)

selectedcol<-grep("[Mm]ean|[Ss]td",features$V2)
selectedColNames <- features[selectedcol, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)

x_data<-x_data[,selectedcol]
alldata<-cbind(s_data,y_data,x_data)

##Setting colnames
colnames(alldata) <- c("Subject", "ActivityN", selectedColNames)

##Labels
labels<-read.table("./Data/UCI HAR Dataset/activity_labels.txt")
colnames(labels)<-c("ActivityN","Activity")

##Merging labels for acitivity with alldata
alldata<-merge(labels, alldata)
alldata<-select(alldata,-ActivityN)
alldata<-arrange(alldata,Subject,Activity)

meltedData <- melt(alldata, id = c("Subject", "Activity"))

