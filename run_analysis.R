add<-myworkingdir
setwd(add)
library(plyr)
library(dplyr)
###1.Merges the training and the test sets
features<-read.table('./UCI HAR Dataset/features.txt')
##load different parts of train data set,change column names and combine them
xtrain<-read.table('./UCI HAR Dataset/train/X_train.txt')
names(xtrain)<-features$V2
#
subtrain<-read.table('./UCI HAR Dataset/train/subject_train.txt')
names(subtrain)<-c('SubjectID')
#
ytrain<-read.table('./UCI HAR Dataset/train/y_train.txt')
names(ytrain)<-c('activity')
train<-cbind(subtrain,ytrain,xtrain)
##load different parts of test data set,change column names and combine them
xtest<-read.table('./UCI HAR Dataset/test/X_test.txt')
names(xtest)<-features$V2
#
subtest<-read.table('./UCI HAR Dataset/test/subject_test.txt')
names(subtest)<-c('SubjectID')
#
ytest<-read.table('./UCI HAR Dataset/test/y_test.txt')
names(ytest)<-c('activity')
test<-cbind(subtest,ytest,xtest)
##merge train and test data sets
data<-rbind(test,train)
###2.Extracts only the measurements on the mean and standard deviation for each measurement
data<-data[,grepl('mean|std|SubjectID|activity',names(data))]
###3.Uses descriptive activity names to name the activities in the data set
activitylabels<-read.table('./UCI HAR Dataset/activity_labels.txt')
nameactivity<-function(x){
    n<-grep(x,activitylabels$V1)
    activitylabels$V2[n]
}
data$activity<-lapply(data$activity,nameactivity)
data$activity<-unlist(data$activity)# or data$activity will be non-atomic
###4.Appropriately labels the data set with descriptive variable names
names(data)<-gsub('-|\\(\\)','',names(data))
names(data)<-gsub('^t','time',names(data)) 
names(data)<-gsub('^f','freq',names(data))
names(data)<-tolower(names(data))
###5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data2<-ddply(data,.(subjectid,activity),function(table) colMeans(table[,3:ncol(table)]))
write.table(data2,file='average.txt',sep='\t',row.names=FAULSE)