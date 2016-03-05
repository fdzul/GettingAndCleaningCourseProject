##################################################
#READING TRAINING DATA

setwd("./UCI HAR Dataset")

names<-read.table(file="features.txt")

subjects<-read.table(file="train/subject_train.txt", col.names = "subjects")

activity<-read.table(file = "train/y_train.txt", col.names = "activity")

initial<-read.table(file = "train/X_train.txt", nrows = 1)
classes<-sapply(initial, class)
trainSet<-read.table(file = "train/X_train.txt", colClasses = classes,
                     col.names = names$V2, check.names = FALSE)

trainSet<-cbind.data.frame(subjects, activity, trainSet)

#################################################
#READING TEST DATA

subjects<-read.table(file="test/subject_test.txt", col.names = "subjects")

activity<-read.table(file = "test/y_test.txt", col.names = "activity")

testSet<-read.table(file = "test/X_test.txt", colClasses = classes,
                     col.names = names$V2, check.names = FALSE)

testSet<-cbind.data.frame(subjects, activity, testSet)

#################################################
#STEP 1 - MERGING DATA IN ONE DATA SET

allSet<-rbind.data.frame(trainSet, testSet)

#################################################
#STEP 2 - EXTRACT COLUMNS OF MEAN() AND STD()

allSet<-allSet[,c(1:2, grep("-mean\\(\\)|-std\\(\\)", names(allSet)))]

#################################################
#STEP 3 - USES DESCRIPTIVE ACTIVITY NAMES

descr_activity<-read.table("activity_labels.txt")
allSet$activity<-descr_activity[allSet$activity,2]

#################################################
#STEP 4 - USES DESCRIPTIVE VARIABLE NAMES

names(allSet)<-gsub("-mean\\(\\)-?", "Mean", names(allSet))
names(allSet)<-gsub("-std\\(\\)-?", "Std", names(allSet))

#################################################
#STEP 5 - SUMMARISING DATA BY SUBJECTS AND ACTIVITY

library(dplyr)

allSetMean<-tbl_df(allSet) %>% group_by(subjects, activity) %>% summarise_each(funs(mean))
write.table(allSetMean, file = "result.txt", row.names = FALSE)

#################################################