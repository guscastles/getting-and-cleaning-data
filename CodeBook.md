# CodeBook For The Samsung Galaxy S Accelerometers Dataset

This code book describes the variables from the dataset produced by the accelerometers of the Samsun Galaxy S smartphone.

The original code book is

> - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

The dataset was collected from the url

> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

using the function 

```
fetch_data(url)
```

in ***run_analysis.R***. The script can be loaded with the usual command

```
source("run_analysis.R")
```

