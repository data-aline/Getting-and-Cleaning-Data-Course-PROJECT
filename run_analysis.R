library(plyr)

#1. Merges the training and the test sets to create one data set.

#1a. read all data

x_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/y_test.txt")
subject_test<-read.table("./test/subject_test.txt")


#'X_test.txt'/ 'X_train.txt': Test/train set.
# 'y_test.txt'/'y_train.txt': Test/Train labels.
# subject_train.txt': Each row identifies the subject who performed the activity for each window sample. 
#Its range is from 1 to 30. 

x_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt")
subject_train<-read.table("./train/subject_train.txt")

#1b. merge data

x_all<-rbind(x_test,x_train)
y_all<-rbind(y_test,y_train)
subject_all<-rbind(subject_test,subject_train)


#2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")
features[,2] <- as.character(features[,2])
features_mean_and_std <- grep(".*mean.*|.*std.*", features[,2])
features_names <- features[features_mean_and_std,2]

names(x_all)=features[,2]

#subset the columns
x_all=x_all[,features_mean_and_std]


#3. Uses descriptive activity names to name the activities in the data set
activity_label<-read.table("activity_labels.txt")


#4. Appropriately labels the data set with descriptive variable names.

y_all[,1]<-activity_label[y_all[,1],2]
all_data <- cbind(subject_all,y_all,x_all)
names(all_data)<-c("subject", "activity",features_names)     

#5. From the data set in step 4, creates a second, independent tidy data set with the average of 
#each variable for each activity and each subject.

tidy_data<-group_by(all_data,activity,subject)
tidy_data<-summarise_each(tidy_data,funs(mean))