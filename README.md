# Getting And Cleaning Data
## Peer reviewed project for the Getting and Cleaning Data course from Johns Hopkins

This project contains 3 main files:

- [run_analysis.R](https://github.com/guscastles/getting-and-cleaning-data/blob/master/run_analysis.R) -- Contains all the R functions used to achieve the project's goal
- [etl_functions.R](https://github.com/guscastles/getting-and-cleaning-data/blob/master/etl_functions.R) -- Contains support functions for the main functions in *run_analysis.R*
- [CodeBook.md](https://github.com/guscastles/getting-and-cleaning-data/blob/master/CodeBook.md) -- The code book explaining all variables and datasets, including how to get the original dataset and how the functions work
- This README.md -- The main guide for the project

> The original dataset [url](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) is available from [Amazon CloudFront](https://aws.amazon.com/cloudfront/).

Script *run_analisys.R* contains the functions:

- run_project
- download_data
- fetch_and_clean
- join_datasets
- create_mean_and_std_deviation_dataset
- create_average_of_mean_and_std
- create_dataset_files

Script *etl_functions.R* contains the functions:

- fetch_subjects
- fetch_activities
- fetch_features_set
- create_column_names
- change_bands_energy_names

## Output Datasets

The two output datasets are

> **[mean_and_std_dataset.txt](https://github.com/guscastles/getting-and-cleaning-data/blob/master/mean_and_std_dataset.txt)**<br>
The dataset with mean and standard deviation values, as well as the subject numbers and the descriptive activities

> **[average_dataset.txt](https://github.com/guscastles/getting-and-cleaning-data/blob/master/average_dataset.txt)**<br>
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
