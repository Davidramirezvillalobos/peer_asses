dir.create("./datos")
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,"./datos/datos.zip")
## Download ziped data into working directory
unzip("./datos/datos.zip", exdir = "./datos")
act_lbls <- read.table("./datos/UCI HAR Dataset/activity_labels.txt")
test <- read.table("./datos/UCI HAR Dataset/test/X_test.txt")
train <- read.table("./datos/UCI HAR Dataset/train/X_train.txt")
test_sub <- read.table("./datos/UCI HAR Dataset/test/subject_test.txt")
train_sub <- read.table("./datos/UCI HAR Dataset/train/subject_train.txt")
#Subjects are people categorization between 1 and 30
#test has 9 levels and train 21 levels. All of them different
test_labl <- read.table("./datos/UCI HAR Dataset/test/Y_test.txt")
train_labl <- read.table("./datos/UCI HAR Dataset/train/Y_train.txt")
#Labels are activity categories from 1 to 6.

## 1. Create only one data set
features <- read.table("./datos/UCI HAR Dataset/features.txt")
# Every variable title. 561 variables as test and training data sets
test_ok <- cbind(test_labl, test_sub, test) #561 original variables at the end
colnames(test_ok)[1:2] <- c("Activity", "Subject")
train_ok <- cbind(train_labl, train_sub, train)
colnames(train_ok)[1:2] <- c("Activity", "Subject")
data <- rbind(test_ok, train_ok)

## 2. Extract variables related to mean and standar deviation
Mean_cols <- as.character(subset(features, grepl("mean",features$V2))[,1])
Mean_cols_adj <- as.character(as.numeric(Mean_cols)+2)
# Correct index for columns in "Data" relative to mean
Std_cols <- as.character(subset(features, grepl("std",features$V2))[,1])
Std_cols_adj <- as.character(as.numeric(Std_cols)+2)
# Correct index for columns in "Data" relative to standard deviation
sbst_cols <- as.integer(c(1:2, Std_cols_adj, Mean_cols_adj))
# 1:2 included to consider first two columns added for Activity and subject
cleandata <- data[,sbst_cols]

## 3. Uses descriptive activity names to name the activities in the data set
acts_named <- merge(act_lbls, cleandata, by.x="V1", by.y="Activity", all=TRUE)

## 4. Appropriately labels the data set with descriptive variable names. 
cols_id <- c(Std_cols, Mean_cols)
cols_names <- as.character(features[as.character(cols_id),][,2])
colnames(acts_named) <- c("Act_Id", "Act_name", "Sub_id", cols_names)

## 5. Independent tidy data set with avg of each variable for 
##    each activity and each subject.
library(plyr)
acts_named$sub_by_act <- do.call(paste0, acts_named[c(2, 3)])
acts_named$sub_by_act <- as.factor(acts_named$sub_by_act)
# Create a key column to combine Activity type with subject type. 6 X 30 = 180 levels
avg_by_key <- aggregate(acts_named[, 4:82], list(acts_named$sub_by_act), mean)
# New data frame with 180 rows (one per activity&subject key) and 80 rows (key + 79 variables)
write.table(avg_by_key, file="peer_asses.txt", row.name=FALSE) 

