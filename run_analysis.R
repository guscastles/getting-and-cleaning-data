# Getting And Cleaning Data - Peer-reviewed Programming Assignment
# source dataset url: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

library(dplyr)
library(lubridate)

run_project <- function() {
        
        message <- function(msg) {
                cat(msg, sep = "\n")
        }
        
        message("Downloading source dataset...")
        download_data("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
        message("Cleaning and joining train and test datasets...")
        data <- fetch_and_clean()
        message("Creating the mean and standard deviation dataset...")
        mean_std_dataset <- data %>% create_mean_and_std_deviation_dataset
        message("Creating averages of the mean and standard deviation values...")
        avg_dataset <- mean_std_dataset %>% create_average_of_mean_and_std
        message("Saving both datasets...")
        create_dataset_files(mean_std_dataset, avg_dataset)
        message("Finished!")
}

download_data <- function(url) {
        splitted <- strsplit(url, "%20")
        dest_file <- tail(unlist(splitted), 1)
        if (!file.exists(dest_file)) {
                download.file(url, destfile = dest_file)
                unzip(dest_file)
                cat(as.character(now()), file = "download_timestamp.txt")
        }
        dest_file
}

fetch_and_clean <- function() {
        train_data <- tbl_df(cbind(fetch_subjects("train"),
                                   fetch_activities("train"),
                                   fetch_features_set("train")))
        test_data <- tbl_df(cbind(fetch_subjects("test"),
                                  fetch_activities("test"),
                                  fetch_features_set("test")))
        join_datasets(train_data, test_data)
}

fetch_subjects <- function(data_set_indicator) {
        subjects <- read_additional_data(paste("UCI HAR Dataset",
                                               data_set_indicator,
                                               paste0("subject_", data_set_indicator, ".txt"),
                                               sep = "/"))
        colnames(subjects) <- c("subject")
        subjects
}

fetch_activities <- function(data_set_indicator) {
        raw_labels_data <- read_additional_data(paste("UCI HAR Dataset",
                                                   data_set_indicator,
                                                   paste0("y_", data_set_indicator, ".txt"),
                                                   sep = "/"))
        labels <- read_additional_data("UCI HAR Dataset/activity_labels.txt")
        raw_labels_data$activity <- factor(raw_labels_data$V1, levels = labels$V1, labels = labels$V2)
        raw_labels_data %>% select(activity)
}


fetch_features_set <- function(data_set_indicator) {
        dataset <- read_data(paste("UCI HAR Dataset",
                                     data_set_indicator, paste0("X_", data_set_indicator, ".txt"),
                                     sep = "/"))
        colnames(dataset) <- create_column_names("UCI HAR Dataset/features.txt")
        dataset        
}

read_data <- function(filename, number_of_lines = -1) {
        
        field_widths <- function() {
                unlist(lapply(1:561, function(count) 16))
        }
        
        read.fwf(filename, widths = field_widths(), n = number_of_lines)
}

read_additional_data <- function(filename, number_of_lines = -1) {
        read.delim(filename, sep = " ", header = FALSE, nrows = number_of_lines)
}

join_datasets <- function(first_set, second_set) {
        rbind(first_set, second_set)
}

create_column_names <- function(filename) {
        data <- read.delim("UCI HAR Dataset/features.txt", sep = " ", header = FALSE)
        col_names <- data %>%
                mutate(V2 = gsub(",|\\-", "", V2)) %>%
                mutate(V2 = gsub("\\(|\\)", "", V2)) %>%
                mutate(V2 = sub("Acc", "Acceleration", V2)) %>%
                mutate(V2 = sub("Gyro", "Gyroscope", V2)) %>%
                mutate(V2 = sub("^t", "time", V2)) %>%
                mutate(V2 = sub("^anglet", "angleTime", V2)) %>%
                mutate(V2 = sub("^f", "frequencyDomain", V2)) %>%
                mutate(V2 = sub("Freq", "Frequency", V2)) %>%
                mutate(V2 = gsub("mean", "Mean", V2)) %>%
                mutate(V2 = sub("std", "StandardDeviation", V2)) %>%
                mutate(V2 = sub("Mag", "Magnitude", V2)) %>%
                mutate(V2 = sub("gravity", "Gravity", V2)) %>%
                mutate(V2 = sub("bands", "Bands", V2))
        change_bands_energy_names(col_names)
}

change_bands_energy_names <- function(col_names) {
        
        change <- function(df) {
                changed <- df %>% 
                        select(V1, V2, V3, V4, V5, V6, V7, V8, V9) %>%
                        mutate(V1 = addsuffix(V1, "X"), V2 = addsuffix(V2, "Y"), V3 = addsuffix(V3, "Z"),
                               V4 = addsuffix(V4, "X"), V5 = addsuffix(V5, "Y"), V6 = addsuffix(V6, "Z"),
                               V7 = addsuffix(V7, "X"), V8 = addsuffix(V8, "Y"), V9 = addsuffix(V9, "Z"))
                as.character(unlist(changed))
        }
        
        addsuffix <- function(value, suffix) {
                paste0(value, suffix)
        }
        
        bandsenergy_rows <- grep("BandsEnergy", col_names$V2)
        bandsenergy <- matrix(col_names[bandsenergy_rows, "V2"], ncol = 9)
        col_names[bandsenergy_rows, "V2"] <- bandsenergy %>% tbl_df %>% change
        col_names$V2
}

create_mean_and_std_deviation_dataset <- function(dataset) {
        cols <- grep("subject|activity|Mean|StandardDeviation", colnames(dataset))
        col_names <- colnames(dataset)[cols]
        dataset[col_names]
}

create_average_of_mean_and_std <- function(dataset) {
        
        change_column_name <- function(col_name) {
                paste0("average",
                       toupper(substring(col_name, 1, 1)),
                       substring(col_name, 2))
        }
        
        avg <- aggregate(dataset[-(1:2)], by = list(dataset$subject, dataset$activity), FUN = mean)
        colnames(avg) <- c(colnames(dataset)[1:2], sapply(colnames(dataset)[-(1:2)], change_column_name))
        avg
}

create_dataset_files <- function(mean_stdev_data, average_data) {
        write.table(mean_stdev_data, file = "mean_and_std_dataset.txt", row.names = FALSE)
        write.table(average_data, file = "average_dataset.txt", row.names = FALSE)
}
