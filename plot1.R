# Load the needed packages
library(dplyr)


### 1) Download the data and save it into a data table ###

# Load the data from the url if the data folder does not already exist in the correct folder
data_folder_name <- "exdata_data_household_power_consumption.zip"
file_data_unzip <- "household_power_consumption.txt"

if (!file.exists(data_folder_name)) {
      data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      download.file(data_url, data_folder_name, method="curl")
}

# Unzip the data file if it is not already the case
if (!file.exists(file_data_unzip)) {
      unzip(data_folder_name)
}

# Load the data into a table
col_names <- read.table(file_data_unzip, sep=';', nrows=1, header=FALSE)
data_all <- read.table(file_data_unzip, sep=';', col.names = col_names, skip = 1,
                       header = FALSE, na.strings = "?")


### 2) Manipulate the data, preparing it for plotting ###

# Create a new DateAndTime column, which is a combination of Date and Time, 
# and put it into a POSIXct format using strptime()
data_all$DateAndTime <- strptime(paste(data_all$Date, data_all$Time), 
                                 format = "%d/%m/%Y %H:%M:%S")

# Convert the Date from character to Date Format
# And only keep the relevant data needed for the assignment (going from 01/02/2007 to 02/02/2007)
sub_data <- data_all %>%
      mutate(Date = as.Date(Date, "%d/%m/%Y")) %>%
      filter(Date >= "2007-02-01" & Date <= "2007-02-02")

# Drop rows with NAs (if there are any)
sub_data <- na.omit(sub_data)

# Transform the other char columns into numeric columns before plotting
cols_to_convert <- c("Global_active_power", "Global_reactive_power", "Voltage",
                     "Global_intensity", "Sub_metering_1", "Sub_metering_2",
                     "Sub_metering_3")

sub_data[cols_to_convert] <- lapply(sub_data[cols_to_convert], as.numeric)


### 3) Plot the graphic and export it as a PNG file ###

# Open a PNG device to save the plot into it in the right size, i.e. 480x480
png("plot1.png", width = 480, height = 480)

      # Plotting the plot1, which is a histogram of the Global_active_power variable
      hist(sub_data$Global_active_power, 
            main = "Global Active Power",             
            xlab = "Global Active Power (kilowatts)", 
            ylab = "Frequency",                       
            col = "red",                              
            border = "black"                          
           )

# Close the PNG device
dev.off()
