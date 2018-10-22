# Getting And Cleaning Data
## Peer reviewed project for the Getting and Cleaning Data course from Johns Hopkins

This project contains 4 main files:

- [run_analysis.R](https://github.com/guscastles/getting-and-cleaning-data/blob/master/run_analysis.R) -- Contains all the R functions used to achieve the project's goal
- [CodeBook.md](https://github.com/guscastles/getting-and-cleaning-data/blob/master/CodeBook.md) -- The code book explaining all variables and datasets, including how to get the original dataset and how the functions work
- This README.md -- The main guide for the project
- [download_timestamp.txt](https://github.com/guscastles/getting-and-cleaning-data/blob/master/download_timestamp.txt) -- Contains the download time of the source dataset

> The original dataset [url](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) is available from [Amazon CloudFront](https://aws.amazon.com/cloudfront/).

The script *run_analisys.R* contains the functions with descriptive comments for each one:

- run_project
- download_data
- fetch_and_clean
- fetch_subjects
- fetch_activities
- fetch_features_set
- join_datasets
- create_column_names
- change_bands_energy_names
- create_mean_and_std_deviation_dataset
- create_average_of_mean_and_std
- create_dataset_files

Besides the script and documentation files, two datasets are include

> **[mean_and_std_dataset.csv](https://github.com/guscastles/getting-and-cleaning-data/blob/master/mean_and_std_dataset.csv)**<br>
The dataset with mean and standard deviation values, as well as the subject numbers and the descriptive activities

> **[average_dataset.csv](https://github.com/guscastles/getting-and-cleaning-data/blob/master/average_dataset.csv)**<br>
The average values for all mean and standard deviation measurements

## Executing the Project

To perform all the activities related to the project, on the core R console or RStudio console, run (assuming the script is in the current directory)
```
source("run_analysis.R")
run_project()
```
After it finishes, the two datasets are located int the current working directory.

## Some Thoughts

The two most challeging steps in the project were identifying the format of the source dataset (16 character-witdth for each measurement feature) and identifying the repeated names for the bands energy features for each axis. Overall, a good challenge, with lots of applications from the knowledge of the whole course.
