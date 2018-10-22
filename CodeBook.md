# CodeBook For The Samsung Galaxy S Accelerometers Dataset

This code book describes the variables from the dataset produced by the accelerometers of the Samsun Galaxy S smartphone.

## The Process
### Downloading the Source Dataset
The dataset was collected from the url below using the function *fetch_data*.

> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Unzipping the file produces a directory called *UCI HAR Dataset*, with the following tree structure:

- activity_labels.txt
- features_info.txt
- features.txt
- README.txt
- **test**
  - **Inertial Signals**
    - body_acc_x_test.txt
    - body_acc_y_test.txt
    - body_acc_z_test.txt
    - body_gyro_x_test.txt
    - body_gyro_y_test.txt
    - body_gyro_z_test.txt
    - total_acc_x_test.txt
    - total_acc_y_test.txt
    - total_acc_z_test.txt
  - subject_test.txt
  - X_test.txt
  - y_test.txt
- **train**
  - **Inertial Signals**
    - body_acc_x_train.txt
    - body_acc_y_train.txt
    - body_acc_z_train.txt
    - body_gyro_x_train.txt
    - body_gyro_y_train.txt
    - body_gyro_z_train.txt
    - total_acc_x_train.txt
    - total_acc_y_train.txt
    - total_acc_z_train.txt
  - subject_train.txt
  - X_train.txt
  - y_train.txt

> The files in the *Inertial Signals* folders were not considered for this project.

### Fetching The Features Datasets
The datasets in the *X_test.txt* and *X_train.txt* files have 561 fields, according to the *features_info.txt*. Function *fetch_and_clean* orchestrates the reading and cleaning of the main dataset. 

Each feature has a width of 16 characters in the CSV file, including the space between the values. Fetching is done by is done by function *fetch_features_set* (underlying R function is *read.fwf*), which also creates the columns names.

> **Column Names**<br>
Each column is extracted from *features.txt* file and all non-alphabetical and non-numerical characters are removed, i.e., "(", ")", "-", and ",". Also they are converted to camel case (e.g., CamelCase).<br><br>The bands energy measurements were especially renamed to reflect the axis to which they beloged. This was achieved by adding the suffixes "X", "Y", and "Z" accordingly. Function *change_bands_energy_names* performs this task.

### Subjects and Activities Datasets

Additional data from the activities and subjects datasets are fetched with *fetch_activities* and *fetch_subjects* functions. Since they have a different structure (space delimited), the underlying R function to read them is *read.delim*. 

> **Activities**<br>
There are two main files to understand the activities labels: *activity_labels.txt* and the *y_(train/test).txt* files. Function *fetch_activities* read both and match each row in *y_(train/test).txt* files with the appropriate label in *activity_labels.txt*, producing a dataset that is as long as the former, with the descriptive names replacing the number code.

The structure of the activities dataset has just one column

- activity

The subjects dataset is extracted from *subject_(test/train).txt* files by function *fetch_subjects*.

The structure of the subjects dataset has just one column

- subject

After the train, subjects and activities datasets are merged, the test dataset is joined using R function *rbind* in function *join_datasets*.

### The Final Datasets

Once the *fetch_and_clean* function is run, the mean and standard deviation values are extractred, along with subject and activity features, accomplished by *create_mean_and_std_deviation_dataset* and *create_average_of_mean_and_std*. The averages of all mean and standard deviation values are calculated with the latter, whilst the former produces the tidy dataset from the train and test datasets, along with subjects and activites.

### The Output

For the final step, the files are written on disk using function *create_dataset_files*.

### The Main Function

The function *run_project* executes the previous functions. It is run without any parameters and produces the two datasets.

## The Mean and Standard Deviation Dataset

### **mean_and_std_dataset.txt**
From the original dataset, the columns *subject* and *activity* were added, as described above. The remaining features were modified as described in the *Column Names* box. Units are the same as per the original dataset. There are 10,299 observations and 88 features.

- subject
- activity
- timeBodyAccelerationMeanX
- timeBodyAccelerationMeanY
- timeBodyAccelerationMeanZ
- timeBodyAccelerationStandardDeviationX
- timeBodyAccelerationStandardDeviationY
- timeBodyAccelerationStandardDeviationZ
- timeGravityAccelerationMeanX
- timeGravityAccelerationMeanY
- timeGravityAccelerationMeanZ
- timeGravityAccelerationStandardDeviationX
- timeGravityAccelerationStandardDeviationY
- timeGravityAccelerationStandardDeviationZ
- timeBodyAccelerationJerkMeanX
- timeBodyAccelerationJerkMeanY
- timeBodyAccelerationJerkMeanZ
- timeBodyAccelerationJerkStandardDeviationX
- timeBodyAccelerationJerkStandardDeviationY
- timeBodyAccelerationJerkStandardDeviationZ
- timeBodyGyroscopeMeanX
- timeBodyGyroscopeMeanY
- timeBodyGyroscopeMeanZ
- timeBodyGyroscopeStandardDeviationX
- timeBodyGyroscopeStandardDeviationY
- timeBodyGyroscopeStandardDeviationZ
- timeBodyGyroscopeJerkMeanX
- timeBodyGyroscopeJerkMeanY
- timeBodyGyroscopeJerkMeanZ
- timeBodyGyroscopeJerkStandardDeviationX
- timeBodyGyroscopeJerkStandardDeviationY
- timeBodyGyroscopeJerkStandardDeviationZ
- timeBodyAccelerationMagnitudeMean
- timeBodyAccelerationMagnitudeStandardDeviation
- timeGravityAccelerationMagnitudeMean
- timeGravityAccelerationMagnitudeStandardDeviation
- timeBodyAccelerationJerkMagnitudeMean
- timeBodyAccelerationJerkMagnitudeStandardDeviation
- timeBodyGyroscopeMagnitudeMean
- timeBodyGyroscopeMagnitudeStandardDeviation
- timeBodyGyroscopeJerkMagnitudeMean
- timeBodyGyroscopeJerkMagnitudeStandardDeviation
- frequencyDomainBodyAccelerationMeanX
- frequencyDomainBodyAccelerationMeanY
- frequencyDomainBodyAccelerationMeanZ
- frequencyDomainBodyAccelerationStandardDeviationX
- frequencyDomainBodyAccelerationStandardDeviationY
- frequencyDomainBodyAccelerationStandardDeviationZ
- frequencyDomainBodyAccelerationMeanFrequencyX
- frequencyDomainBodyAccelerationMeanFrequencyY
- frequencyDomainBodyAccelerationMeanFrequencyZ
- frequencyDomainBodyAccelerationJerkMeanX
- frequencyDomainBodyAccelerationJerkMeanY
- frequencyDomainBodyAccelerationJerkMeanZ
- frequencyDomainBodyAccelerationJerkStandardDeviationX
- frequencyDomainBodyAccelerationJerkStandardDeviationY
- frequencyDomainBodyAccelerationJerkStandardDeviationZ
- frequencyDomainBodyAccelerationJerkMeanFrequencyX
- frequencyDomainBodyAccelerationJerkMeanFrequencyY
- frequencyDomainBodyAccelerationJerkMeanFrequencyZ
- frequencyDomainBodyGyroscopeMeanX
- frequencyDomainBodyGyroscopeMeanY
- frequencyDomainBodyGyroscopeMeanZ
- frequencyDomainBodyGyroscopeStandardDeviationX
- frequencyDomainBodyGyroscopeStandardDeviationY
- frequencyDomainBodyGyroscopeStandardDeviationZ
- frequencyDomainBodyGyroscopeMeanFrequencyX
- frequencyDomainBodyGyroscopeMeanFrequencyY
- frequencyDomainBodyGyroscopeMeanFrequencyZ
- frequencyDomainBodyAccelerationMagnitudeMean
- frequencyDomainBodyAccelerationMagnitudeStandardDeviation
- frequencyDomainBodyAccelerationMagnitudeMeanFrequency
- frequencyDomainBodyBodyAccelerationJerkMagnitudeMean
- frequencyDomainBodyBodyAccelerationJerkMagnitudeStandardDeviation
- frequencyDomainBodyBodyAccelerationJerkMagnitudeMeanFrequency
- frequencyDomainBodyBodyGyroscopeMagnitudeMean
- frequencyDomainBodyBodyGyroscopeMagnitudeStandardDeviation
- frequencyDomainBodyBodyGyroscopeMagnitudeMeanFrequency
- frequencyDomainBodyBodyGyroscopeJerkMagnitudeMean
- frequencyDomainBodyBodyGyroscopeJerkMagnitudeStandardDeviation
- frequencyDomainBodyBodyGyroscopeJerkMagnitudeMeanFrequency
- angleTimeBodyAccelerationMeanGravity
- angleTimeBodyAccelerationJerkMeanGravityMean
- angleTimeBodyGyroscopeMeanGravityMean
- angleTimeBodyGyroscopeJerkMeanGravityMean
- angleXGravityMean
- angleYGravityMean
- angleZGravityMean

## The Average of Mean and Standard Deviation Fields Dataset

### **average_dataset.txt**
Measurement units are per the original dataset features, e.g.

\begin{equation*}
averageTimeBodyAccelerationMeanX \sim timeBodyAccelerationMeanX)
\end{equation*}

There are 180 rows, with 88 columns.

- subject
- activity
- averageTimeBodyAccelerationMeanX
- averageTimeBodyAccelerationMeanY
- averageTimeBodyAccelerationMeanZ
- averageTimeBodyAccelerationStandardDeviationX
- averageTimeBodyAccelerationStandardDeviationY
- averageTimeBodyAccelerationStandardDeviationZ
- averageTimeGravityAccelerationMeanX
- averageTimeGravityAccelerationMeanY
- averageTimeGravityAccelerationMeanZ
- averageTimeGravityAccelerationStandardDeviationX
- averageTimeGravityAccelerationStandardDeviationY
- averageTimeGravityAccelerationStandardDeviationZ
- averageTimeBodyAccelerationJerkMeanX
- averageTimeBodyAccelerationJerkMeanY
- averageTimeBodyAccelerationJerkMeanZ
- averageTimeBodyAccelerationJerkStandardDeviationX
- averageTimeBodyAccelerationJerkStandardDeviationY
- averageTimeBodyAccelerationJerkStandardDeviationZ
- averageTimeBodyGyroscopeMeanX
- averageTimeBodyGyroscopeMeanY
- averageTimeBodyGyroscopeMeanZ
- averageTimeBodyGyroscopeStandardDeviationX
- averageTimeBodyGyroscopeStandardDeviationY
- averageTimeBodyGyroscopeStandardDeviationZ
- averageTimeBodyGyroscopeJerkMeanX
- averageTimeBodyGyroscopeJerkMeanY
- averageTimeBodyGyroscopeJerkMeanZ
- averageTimeBodyGyroscopeJerkStandardDeviationX
- averageTimeBodyGyroscopeJerkStandardDeviationY
- averageTimeBodyGyroscopeJerkStandardDeviationZ
- averageTimeBodyAccelerationMagnitudeMean
- averageTimeBodyAccelerationMagnitudeStandardDeviation
- averageTimeGravityAccelerationMagnitudeMean
- averageTimeGravityAccelerationMagnitudeStandardDeviation
- averageTimeBodyAccelerationJerkMagnitudeMean
- averageTimeBodyAccelerationJerkMagnitudeStandardDeviation
- averageTimeBodyGyroscopeMagnitudeMean
- averageTimeBodyGyroscopeMagnitudeStandardDeviation
- averageTimeBodyGyroscopeJerkMagnitudeMean
- averageTimeBodyGyroscopeJerkMagnitudeStandardDeviation
- averageFrequencyDomainBodyAccelerationMeanX
- averageFrequencyDomainBodyAccelerationMeanY
- averageFrequencyDomainBodyAccelerationMeanZ
- averageFrequencyDomainBodyAccelerationStandardDeviationX
- averageFrequencyDomainBodyAccelerationStandardDeviationY
- averageFrequencyDomainBodyAccelerationStandardDeviationZ
- averageFrequencyDomainBodyAccelerationMeanFrequencyX
- averageFrequencyDomainBodyAccelerationMeanFrequencyY
- averageFrequencyDomainBodyAccelerationMeanFrequencyZ
- averageFrequencyDomainBodyAccelerationJerkMeanX
- averageFrequencyDomainBodyAccelerationJerkMeanY
- averageFrequencyDomainBodyAccelerationJerkMeanZ
- averageFrequencyDomainBodyAccelerationJerkStandardDeviationX
- averageFrequencyDomainBodyAccelerationJerkStandardDeviationY
- averageFrequencyDomainBodyAccelerationJerkStandardDeviationZ
- averageFrequencyDomainBodyAccelerationJerkMeanFrequencyX
- averageFrequencyDomainBodyAccelerationJerkMeanFrequencyY
- averageFrequencyDomainBodyAccelerationJerkMeanFrequencyZ
- averageFrequencyDomainBodyGyroscopeMeanX
- averageFrequencyDomainBodyGyroscopeMeanY
- averageFrequencyDomainBodyGyroscopeMeanZ
- averageFrequencyDomainBodyGyroscopeStandardDeviationX
- averageFrequencyDomainBodyGyroscopeStandardDeviationY
- averageFrequencyDomainBodyGyroscopeStandardDeviationZ
- averageFrequencyDomainBodyGyroscopeMeanFrequencyX
- averageFrequencyDomainBodyGyroscopeMeanFrequencyY
- averageFrequencyDomainBodyGyroscopeMeanFrequencyZ
- averageFrequencyDomainBodyAccelerationMagnitudeMean
- averageFrequencyDomainBodyAccelerationMagnitudeStandardDeviation
- averageFrequencyDomainBodyAccelerationMagnitudeMeanFrequency
- averageFrequencyDomainBodyBodyAccelerationJerkMagnitudeMean
- averageFrequencyDomainBodyBodyAccelerationJerkMagnitudeStandardDeviation
- averageFrequencyDomainBodyBodyAccelerationJerkMagnitudeMeanFrequency
- averageFrequencyDomainBodyBodyGyroscopeMagnitudeMean
- averageFrequencyDomainBodyBodyGyroscopeMagnitudeStandardDeviation
- averageFrequencyDomainBodyBodyGyroscopeMagnitudeMeanFrequency
- averageFrequencyDomainBodyBodyGyroscopeJerkMagnitudeMean
- averageFrequencyDomainBodyBodyGyroscopeJerkMagnitudeStandardDeviation
- averageFrequencyDomainBodyBodyGyroscopeJerkMagnitudeMeanFrequency
- averageAngleTimeBodyAccelerationMeanGravity
- averageAngleTimeBodyAccelerationJerkMeanGravityMean
- averageAngleTimeBodyGyroscopeMeanGravityMean
- averageAngleTimeBodyGyroscopeJerkMeanGravityMean
- averageAngleXGravityMean
- averageAngleYGravityMean
- averageAngleZGravityMean