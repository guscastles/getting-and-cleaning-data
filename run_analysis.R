# Getting And Cleaning Data - Peer-reviewed Programming Assignment
# source dataset url: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

library(dplyr)
library(lubridate)

# Runs all necessary functions to accomplish the goal of the project.
# Creates the two outcome datasets and the timestamp file, as 
# explained int the README.md document.
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

# The function *fetch_and_clean* executes the previous functions. 
# It is run without any parameters and return a tidy dataset,
# with train and test data joined
fetch_and_clean <- function() {
        train_data <- tbl_df(cbind(fetch_subjects("train"),
                                   fetch_activities("train"),
                                   fetch_features_set("train")))
        test_data <- tbl_df(cbind(fetch_subjects("test"),
                                  fetch_activities("test"),
                                  fetch_features_set("test")))
        join_datasets(train_data, test_data)
}

# Receives a data_set_indicator (values are train or test).
# Returns a data.frame object containing the subject numbers.
fetch_subjects <- function(data_set_indicator) {
        subjects <- read_additional_data(paste("UCI HAR Dataset",
                                               data_set_indicator,
                                               paste0("subject_", data_set_indicator, ".txt"),
                                               sep = "/"))
        colnames(subjects) <- c("subject")
        subjects
}

# Receives a data_set_indicator (values are train or test).
# Returns a data.frame object containing the activities labels,
# in descriptive format.
fetch_activities <- function(data_set_indicator) {
        raw_labels_data <- read_additional_data(paste("UCI HAR Dataset",
                                                   data_set_indicator,
                                                   paste0("y_", data_set_indicator, ".txt"),
                                                   sep = "/"))
        labels <- read_additional_data("UCI HAR Dataset/activity_labels.txt")
        activities <- raw_labels_data %>%
                mutate(activity = labels[V1, "V2"]) %>%
                select(activity)
        colnames(activities) <- c("activity")
        activities                
}


# Receives a data_set_indicator (values are train or test).
# Returns a data.frame object containing the features dataset.
fetch_features_set <- function(data_set_indicator) {
        dataset <- read_data(paste("UCI HAR Dataset",
                                     data_set_indicator, paste0("X_", data_set_indicator, ".txt"),
                                     sep = "/"))
        colnames(dataset) <- create_column_names("UCI HAR Dataset/features.txt")
        dataset        
}

# Reads the data from filename using function *read.fwf*. Optionally 
# receives number_of_lines, indicating how many lines should be read
# from the file. Returns the raw dataset.
read_data <- function(filename, number_of_lines = -1) {
        
        field_widths <- function() {
                unlist(lapply(1:561, function(count) 16))
        }
        
        read.fwf(filename, widths = field_widths(), n = number_of_lines)
}

# Additional data from the activities and labels datasets are fetched
# with *read_additional_data* function, since they have a different
# structure (space delimited). Receives the filename and, optionally,
# the number_of_lines to be read. Returns the raw dataset.
read_additional_data <- function(filename, number_of_lines = -1) {
        read.delim(filename, sep = " ", header = FALSE, nrows = number_of_lines)
}

# Joins two datasets given by first_set and second_set
# returning the result from the rbind function.
join_datasets <- function(first_set, second_set) {
        rbind(first_set, second_set)
}

# Receives a filename of the data file containing the column names
# of the dataset and return a modified vector with unique column
# names, all lowercase and without special characters, like "(", ")",
# ",", or "-".
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

# Especifically for the bands energy features in coln_names
# that are repeated for each axis, returns unique names
# with the axis suffix "X", "Y", or "Z", accordingly.
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

# Receives the full dataset and returns a dataset with 
# the mean and standard deviation features only, along with
# the subjects and activities values.
create_mean_and_std_deviation_dataset <- function(dataset) {
        cols <- grep("subject|activity|Mean|StandardDeviation", colnames(dataset))
        col_names <- colnames(dataset)[cols]
        dataset[col_names]
}

# Receives the dataset with the mean and standard deviation features only
# and return a dataset with the average values for each feature.
create_average_of_mean_and_std <- function(dataset) {
        
        create_first_grouped_average <- function(col) {
                summarise(grouped, mean(!!sym(col)))
        }
        
        create_remaining_grouped_averages <- function(cols) {
                sapply(cols, calculate_average)
        }
        
        calculate_average <- function(col) {
                unlist(summarise(grouped, mean(!!sym(col)))[3])
        }
        
        change_column_name <- function(col_name) {
                paste0("average",
                       toupper(substring(col_name, 1, 1)),
                       substring(col_name, 2))
        }
        
        mean_std_cols <- colnames(dataset)[-(1:2)]
        grouped <- dataset %>% group_by(subject, activity)
        first_average <- create_first_grouped_average(mean_std_cols[1])
        averages <- create_remaining_grouped_averages(mean_std_cols[2:length(mean_std_cols)]) 
        avg <- data.frame(first_average, averages)
        colnames(avg) <- c(colnames(dataset)[1:2], sapply(mean_std_cols, change_column_name))
        avg
}

# Receives the mean and standard deviation features dataset mean_stdev_data
# and their average dataset average_data. Writes both datasets to disk,
# with names mean_and_std_dataset.csv and average_dataset.csv.
create_dataset_files <- function(mean_stdev_data, average_data) {
        write.table(mean_stdev_data, file = "mean_and_std_dataset.txt", row.names = FALSE)
        write.table(average_data, file = "average_dataset.txt", row.names = FALSE)
}
