
pattern <- "-[Mm]ean\\(\\)|-[Ss]td\\(\\)"

# load meta data
features <- read.table('./UCI HAR Dataset/features.txt', col.names=c('row','feature'))
applicable_features <- grep(pattern,features$feature)
activities <- read.table('./UCI HAR Dataset/activity_labels.txt', col.names=c('row','activity'))

##Load data

# training data
train_subjects <- read.table('./UCI HAR Dataset/train/subject_train.txt',col.names=c('subject'))
train_activities <- read.table('./UCI HAR Dataset/train/y_train.txt',col.names=c('activity_code'))
train_activities <- data.frame(sapply(train_activities$activity_code,function(d){activities$activity[activities$row==d]}))
colnames(train_activities)<-c('activity')

train_data <- read.table('./UCI HAR Dataset/train/X_train.txt')
train_data <- train_data[ , applicable_features ]
colnames(train_data)<-features$feature[applicable_features]
train_data <- cbind(train_data,train_subjects)
train_data <- cbind(train_data,train_activities)

# test data
test_subjects <- read.table('./UCI HAR Dataset/test/subject_test.txt',col.names=c('subject'))
test_activities <- read.table('./UCI HAR Dataset/test/y_test.txt',col.names=c('activity_code'))
test_activities <- data.frame(sapply(test_activities$activity_code,function(d){activities$activity[activities$row==d]}))
colnames(test_activities)<-c('activity')

test_data <- read.table('./UCI HAR Dataset/test/X_test.txt')
test_data <- test_data[ ,applicable_features ]
colnames(test_data)<-features$feature[applicable_features]
test_data <- cbind(test_data,test_subjects)
test_data <- cbind(test_data,test_activities)

## merge data

combined_data <- rbind(train_data,test_data)

## summarize data

meltData <- melt(combined_data,id=c('subject','activity'))
castData <- dcast(meltData,subject+activity~variable, mean)

## output data to CSV

write.csv(features$feature[applicable_features],file='variables.txt',row.names=FALSE,quote=FALSE)
write.csv(combined_data, file='observations.txt',row.names=FALSE,quote=FALSE)
write.csv(castData, file='summary.txt',row.names=FALSE,quote=FALSE)