library(dplyr)
library(tidyr)
library(reshape2)
library(memisc)
#Give to the measurements the proper labels
f<- file.path(getwd(), "features.txt")
features <- read.table(f, stringsAsFactors = FALSE)
#Formatting the features
features$V2 <- gsub("-","_",features$V2,) 
features$V2 <- gsub("\\(\\)","",features$V2,)
features$V2 <- gsub("\\(","_",features$V2,)
features$V2 <- gsub(",","_",features$V2,)
features$V2 <- gsub("\\)","",features$V2,)

#TRAIN
#Load the train measurement values
f<- file.path(getwd(), "train/X_train.txt")
x_train <- read.table(f, stringsAsFactors = FALSE, header=FALSE, col.names=features$V2)

# Select fields with mean or std (86 features)
selec_i <- grep("[Mm]ean|[Ss]td", names(x_train))
x_train_red <- x_train[selec_i]

# Add the subject and the activity columns
f<- file.path(getwd(), "train/subject_train.txt")
s_train <- read.table(f, stringsAsFactors = FALSE, header=FALSE, col.names="subject")

f<- file.path(getwd(), "train/y_train.txt")
y_train <- read.table(f, stringsAsFactors = FALSE, header=FALSE, col.names="activity")

y_train$activity <-sub("1","WALKING",y_train$activity)
y_train$activity <-sub("2","WALKING_UPSTAIRS",y_train$activity)
y_train$activity <-sub("3","WALKING_DOWNSTAIRS",y_train$activity)
y_train$activity <-sub("4","SITTING",y_train$activity)
y_train$activity <-sub("5","STANDING",y_train$activity)
y_train$activity <-sub("6","LAYING",y_train$activity)

#Train dataset
train<-cbind(s_train,y_train,x_train_red)

#TEST
#Load the test measurement values
f<- file.path(getwd(), "test/X_test.txt")
x_test <- read.table(f, stringsAsFactors = FALSE, header=FALSE, col.names=features$V2)

# Select fields with mean or std (86 features)
selec_i <- grep("[Mm]ean|[Ss]td", names(x_test))
x_test_red <- x_test[selec_i]

#Add the subject and the activity columns
f<- file.path(getwd(), "test/subject_test.txt")
s_test <- read.table(f, stringsAsFactors = FALSE, header=FALSE, col.names="subject")

f<- file.path(getwd(), "test/y_test.txt")
y_test <- read.table(f, stringsAsFactors = FALSE, header=FALSE, col.names="activity")

y_test$activity <-sub("1","WALKING",y_test$activity)
y_test$activity <-sub("2","WALKING_UPSTAIRS",y_test$activity)
y_test$activity <-sub("3","WALKING_DOWNSTAIRS",y_test$activity)
y_test$activity <-sub("4","SITTING",y_test$activity)
y_test$activity <-sub("5","STANDING",y_test$activity)
y_test$activity <-sub("6","LAYING",y_test$activity)

#Test dataset
test<-cbind(s_test,y_test,x_test_red)

#Joining the two sets
data<-rbind(train,test)

#Taking the mean value per variable
melted <- melt(data, id.vars= c("subject","activity"))
casted <- dcast(melted, subject + activity ~ variable, fun.aggregate = mean, na.rm=TRUE)

#Separating...
melted2 <- melt(casted, id.vars= c("subject","activity"))

#Renaming...
#Jerk
rename <- grepl("[Jj]erk", melted2$variable)
melted2$jerk <- factor(rename, labels=c("NA","Jerk"))

#Magnitude
rename <- grepl("[Mm]ag", melted2$variable)
melted2$magnitude <- factor(rename, labels=c("NA","Magnitude"))

#Angle
rename <- grepl("^a", melted2$variable)
melted2$angle <- factor(rename, labels=c("NA","Angle"))

#Mean / Std
rename1 <- grepl("[Mm]ean", melted2$variable)
rename2 <- grepl("[Ss]td", melted2$variable)
y <- matrix(seq(1,2), nrow =2)
x <- matrix(c(rename1, rename2), ncol=nrow(y))
melted2$operation <- factor(x%*%y, labels=c("Mean","Std"))

#BodyAcc / GravityAcc
rename1 <- grepl("[Bb]odyAcc", melted2$variable)
rename2 <- grepl("[Gg]ravityAcc", melted2$variable)
y <- matrix(seq(1,2), nrow =2)
x <- matrix(c(rename1, rename2), ncol=nrow(y))
melted2$acceleration <- factor(x%*%y, labels=c("NA","Body","Gravity"))

#Acc / Gyro
rename1 <- grepl("[Aa]cc", melted2$variable)
rename2 <- grepl("[Gg]yro", melted2$variable)
y <- matrix(seq(1,2), nrow =2)
x <- matrix(c(rename1, rename2), ncol=nrow(y))
melted2$instrument <- factor(x%*%y, labels=c("NA","Accelerometer","Gyroscope")) 

#Time / Frequency
rename1 <- grepl("^t", melted2$variable)
rename2 <- grepl("^f", melted2$variable)
y <- matrix(seq(1,2), nrow =2)
x <- matrix(c(rename1, rename2), ncol=nrow(y))
melted2$domain <- factor(x%*%y, labels=c("NA","Time","Frequency")) 

#Axis X/Y/Z
rename1 <- grepl("_X", melted2$variable)
rename2 <- grepl("_Y", melted2$variable)
rename3 <- grepl("_Z", melted2$variable)
y <- matrix(seq(1,3), nrow =3)
x <- matrix(c(rename1, rename2,rename3), ncol=nrow(y))
melted2$axis <- factor(x%*%y, labels=c("NA","X","Y","Z")) 


#Final presentation. Reordering columns and dropping the column with the original feature names.
final <- select(melted2, subject,activity,jerk:axis,value) 
final_sorted <- arrange(final, subject, activity)
write.table(final_sorted, file="KPR_Project.txt", quote=FALSE, sep="\t", row.names=FALSE)






