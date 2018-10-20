library(dplyr)

# Fetches the data from the given url, automatically
# unziping it and picking its name. It assumes the 
# current folder is the destination folder.
# Returns the name of the downloade file.
fetch_data <- function(url) {
        splitted <- strsplit(url, "%20")
        dest_file <- tail(unlist(splitted), 1)
        download.file(url, destfile = dest_file)
        unzip(dest_file)
        dest_file
}

#
read_data <- function(filename, number_of_lines = -1) {
        read.fwf(filename, widths = field_widths(), n = number_of_lines)
}

#
read_additional_data <- function(filename, number_of_rows = -1) {
        read.delim(filename, sep = " ", header = FALSE, nrows = number_of_rows)
}

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
