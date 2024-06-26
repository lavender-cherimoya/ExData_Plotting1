# Load the needed package
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

# Load the data in a table
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
png("plot3.png", width = 480, height = 480)

      # Plotting the plot3, showing the evolution of the three Sub_metering variables over time

      # Begin by plotting the first curve, i.e. Sub_metering_1
      plot(sub_data$DateAndTime,
            sub_data$Sub_metering_1,
            main = "Evolution of Energy sub metering \n over the span of two days",   
            type="l",                                                     
            xlab="",                                                      
            ylab="Energy sub metering",                                   
            xaxt = "n"                                                    
           )

      # Plot the two additional curves, Sub_metering_2 and Sub_metering_3
      lines(sub_data$DateAndTime, sub_data$Sub_metering_2, col = "red")
      lines(sub_data$DateAndTime, sub_data$Sub_metering_3, col = "blue")
      
      # Adjust the x-axis tick labels to display the name of the week day
      dates <- as.POSIXct(c("2007-02-01 00:00:00", "2007-02-02 00:00:00", 
                            "2007-02-03 00:00:00"))
      axis.POSIXct(1, at = dates, format = "%a",)

      # Add a legend for each curve
      legend("topright", 
            legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
            col = c("black", "red", "blue"), 
            lty = 1, 
            cex = 1
            )

# Close the PNG device, saving the plot
dev.off()

