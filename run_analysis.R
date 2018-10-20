# Getting And Cleaning Data - Peer-reviewed Programming Assignment
# source dataset url: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

library(tidyr)
library(dplyr)
library(lubridate)

# To run the whole project use function *run_project*, with no parameters required
run_project <- function() {
        
        message <- function(msg) {
                cat(msg, sep = "\n")
        }
        
        message("Downloading source dataset...")
        #download_data("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
        message("Cleaning and joining train and test datasets...")
        data <- fetch_and_clean()
        message("Creating the mean and standard deviation dataset...")
        mean_std_dataset <- data %>% create_mean_and_std_deviation_dataset
        message("Creating averages of the mean and standard deviation values...")
        avg_dataset <- mean_std_dataset[-(1:2)] %>% create_average_of_mean_and_std
        message("Saving both datasets...")
        create_dataset_files(mean_std_dataset, avg_dataset)
        message("Finished!")
}

# Fetches the data from the given url, automatically
# unziping it and picking its name. It assumes the 
# current folder is the destination folder.
# Returns the name of the downloade file.
download_data <- function(url) {
        splitted <- strsplit(url, "%20")
        dest_file <- tail(unlist(splitted), 1)
        download.file(url, destfile = dest_file)
        unzip(dest_file)
        cat(as.character(now()), file = "download_timestamp.txt")
        dest_file
}

# The function *fetch_and_clean* executes the previous functions. It is run without any parameters and return a tidy dataset, with train and test data joined
fetch_and_clean <- function() {
        train_data <- tbl_df(cbind(fetch_subjects("train"),
                                   fetch_activities("train"),
                                   fetch_train_set("train")))
        test_data <- tbl_df(cbind(fetch_subjects("test"),
                                  fetch_activities("test"),
                                  fetch_train_set("test")))
        join_datasets(train_data, test_data)
}

fetch_subjects <- function(data_set) {
        subjects <- read_additional_data(paste("UCI HAR Dataset",
                                               data_set,
                                               paste0("subject_", data_set, ".txt"),
                                               sep = "/"))
        colnames(subjects) <- c("subject")
        subjects
}

fetch_activities <- function(data_set) {
        train_labels <- read_additional_data(paste("UCI HAR Dataset",
                                                   data_set,
                                                   paste0("y_", data_set, ".txt"),
                                                   sep = "/"))
        labels <- read_additional_data("UCI HAR Dataset/activity_labels.txt")
        activities <- train_labels %>%
                mutate(activity = labels[V1, "V2"]) %>%
                select(activity)
        colnames(activities) <- c("activity")
        activities                
}

fetch_train_set <- function(data_set) {
        train_set <- read_data(paste("UCI HAR Dataset",
                                     data_set, paste0("X_", data_set, ".txt"),
                                     sep = "/"))
        colnames(train_set) <- create_column_names("UCI HAR Dataset/features.txt")
        train_set        
}

# Verifying the training sets. First the necessary libraries are loaded

# Reading the data using *read.fwf*, passing the *field_widths* function as a parameter for the field widths, the *read_data* function is used
read_data <- function(filename, number_of_lines = -1) {
        
        field_widths <- function() {
                unlist(lapply(1:561, function(count) 16))
        }
        
        read.fwf(filename, widths = field_widths(), n = number_of_lines)
}

# Additional data from the activities and labels datasets are fetched with *read_additional_data* function, since they have a different structure (space delimited)
read_additional_data <- function(filename, number_of_rows = -1) {
        read.delim(filename, sep = " ", header = FALSE, nrows = number_of_rows)
}

# Once read and merged with subjects and labels, the train and test datasets are joined with *rbind* function
join_datasets <- function(first_set, second_set) {
        rbind(first_set, second_set)
}

# To create meaningful column names, the *features_info.txt file* will be used, with each name being tidy up by removing special characters "(", ")", and ",". This last one will be replaced by "-", so the separation of numbers are preserved

# Receives a filename of the data file containing the column names
# of the dataset and return a modified vector with unique column
# names, all lowercase and without special characters, like "(", ")",
# ",", or "-".
create_column_names <- function(filename) {
        data <- read.delim("UCI HAR Dataset/features.txt", sep = " ", header = FALSE)
        col_names <- data %>%
                mutate(V2 = gsub("\\(|\\)", "", V2)) %>%
                mutate(V2 = gsub(",|\\-", "_", V2)) %>%
                mutate(V2 = tolower(V2))
        change_bands_energy_names(col_names)
}

# Especifically for the bands energy features in coln_names
# that are repeated for each axis, returns unique names
# with the axis suffix "_x", "_y", or "_z", accordingly.
change_bands_energy_names <- function(col_names) {
        
        change <- function(df) {
                changed <- df %>% 
                        select(V1, V2, V3, V4, V5, V6, V7, V8, V9) %>%
                        mutate(V1 = add_suffix(V1, "_x"), V2 = add_suffix(V2, "_y"), V3 = add_suffix(V3, "_z"),
                               V4 = add_suffix(V4, "_x"), V5 = add_suffix(V5, "_y"), V6 = add_suffix(V6, "_z"),
                               V7 = add_suffix(V7, "_x"), V8 = add_suffix(V8, "_y"), V9 = add_suffix(V9, "_z"))
                as.character(unlist(changed))
        }
        
        add_suffix <- function(value, suffix) {
                paste0(value, suffix) %>% tolower
        }
        
        bandsenergy_rows <- grep("bandsenergy", col_names$V2)
        bandsenergy <- matrix(col_names[bandsenergy_rows, "V2"], ncol = 9)
        col_names[bandsenergy_rows, "V2"] <- bandsenergy %>% tbl_df %>% change
        col_names$V2
}

# Once the *fetch_and_clean* function is run, the mean and standard deviation values are extractred, along with subject and activities
create_mean_and_std_deviation_dataset <- function(dataset) {
        cols <- grep("subject|activity|mean|std", colnames(dataset))
        col_names <- colnames(dataset)[cols]
        dataset[col_names]
}

# Then, the averages of all mean and standard deviation values are calculated
create_average_of_mean_and_std <- function(dataset) {
        avg <- as.data.frame(sapply(dataset, mean))
        colnames(avg) <- c("average")
        average <- cbind(measurement = rownames(avg), avg)
        rownames(average) <- 1:nrow(average)
        average
}

# For the final step, the files are written on disk
create_dataset_files <- function(mean_stdev_data, average_data) {
        write.csv(mean_stdev_data, file = "mean_and_std_dataset.csv", row.names = FALSE)
        write.csv(average_data, file = "average_dataset.csv", row.names = FALSE)
}
