---
title: "Describtion how the script works"
author: "Roman Dzhafarov"
date: '6 March 2016 '
output: html_document
---

#Reading training and test data
Reading names, subjects, activity labels, etc. is omited
```{r}

trainSet<-read.table(file = "train/X_train.txt", colClasses = classes,
                     col.names = names$V2, check.names = FALSE)

testSet<-read.table(file = "test/X_test.txt", colClasses = classes,
                     col.names = names$V2, check.names = FALSE)

```
#Step 1 - Merging data in one data set
```{r}
allSet<-rbind.data.frame(trainSet, testSet)

```
#Step 2 - Extract columns of mean() and std()
Use RegEx for extacting all necessary columns
```{r}
allSet<-allSet[,c(1:2, grep("-mean\\(\\)|-std\\(\\)", names(allSet)))]

```
#Step 3 - Uses descriptive activity names
Read descriptive activity labels and update activity variable
```{r}
descr_activity<-read.table("activity_labels.txt")
allSet$activity<-descr_activity[allSet$activity,2]

```
#Step 4 - Uses descriptive variable names
Use RegEx for replacement "-", "()" and low case
```{r}
names(allSet)<-gsub("-mean\\(\\)-?", "Mean", names(allSet))
names(allSet)<-gsub("-std\\(\\)-?", "Std", names(allSet))

```
#Step 5 - Summarising data by subjects and activity
With the help of dplyr package it is easy to group and summarise by group.
The result data set "result.txt" is write in the Samsung data directory
```{r}
library(dplyr)

allSetMean<-tbl_df(allSet) %>% group_by(subjects, activity) %>% summarise_each(funs(mean))
write.table(allSetMean, file = "result.txt", row.names = FALSE)

```


