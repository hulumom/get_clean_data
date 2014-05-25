
##follow the link I collect data save into local drive
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file (fileurl, "data.zip")
unzip ("data.zip")

## I merge the training and test sets into one set
test_file= read.table ("./UCI HAR Dataset//test/X_test.txt")
train_file = read.table ("./UCI HAR Dataset//train/X_train.txt")
feature_list = read.table ("./UCI HAR Dataset//features.txt")
for (i in 1: length(names (test_file))) {
  names(test_file)[i] <- as.character(feature_list[i,2])
  names (train_file)[i]<-as.character(feature_list[i,2])
}

## I extract mean and standard deviation 
feature_mean <- grepl("-mean()", feature_list[,2] )
feature_std<- grepl ("-std()", feature_list[,2])
feature_mean_std= (feature_mean + feature_std)==1
test_mean_std = data.frame(test_file[,feature_mean_std])
train_mean_std = data.frame(trainfile[,feature_mean_std])
two_data= rbind (test_mean_std, train_mean_std)

## I use descriptive activity names 
subject_test<- read.table ("./UCI HAR Dataset//test/subject_test.txt")
activity_test<- read.table("./UCI HAR Dataset//test/y_test.txt")
subject_train<- read.table ("./UCI HAR Dataset//train/subject_train.txt")
activity_train<- read.table("./UCI HAR Dataset//train/y_train.txt")
subject_all <- rbind (subject_test, subject_train)
activity_all <- rbind (activity_test, activity_train)
all_data = cbind (two_data, c(subject_all, activity_all))
names(all_data)[80]<- "subject"
names(all_data)[81]<- "activity"
activity_label<- read.table ("./UCI HAR Dataset/activity_labels.txt")
library (plyr)
all_data[,81] <-mapvalues (all_data[,81],from= c(1:6), to = c("walking", "walking_up", "walking_down", "sitting", "standing", "laying"))

## I create a second, independent tidy data set 
all_data[,82]<-paste (all_data[,80], all_data[,81], sep="+")
temp_all =NULL
for (i in 1:79){
  temp <-tapply (all_data[,i], all_data[,82], mean)
  temp_all <- cbind (temp_all, temp)
}
all_final <- data.frame (temp_all)
for (i in 1: 79) {
  names(all_final)[i] <- names (data_all[i])
}
###write tidy file
write.table (all_final, file="all_final.txt", col.names=NA,sep="\t")
