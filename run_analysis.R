# Getting And Cleaning Data - Peer-reviewed Programming Assignment
# source dataset url: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

library(dplyr)
library(lubridate)
source("etl_functions.R")

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

join_datasets <- function(first_set, second_set) {
        rbind(first_set, second_set)
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
        avg %>% arrange(subject, activity)
}

create_dataset_files <- function(mean_stdev_data, average_data) {
        write.table(mean_stdev_data, file = "mean_and_std_dataset.txt", row.names = FALSE)
        write.table(average_data, file = "average_dataset.txt", row.names = FALSE)
}
