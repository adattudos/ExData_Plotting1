# This is the R script created for Exploratory Data Analysis Course Project 1
# Its goal is to reproduce plot4.png using Global Active Power data over a
# 2-day period in February, 2007 in the Electric Power consumption data set.

# The script assumes that the input data set is in the working directory.
# In case the input data set is missing the script downloads and extracts it
# if necessary.

# sqldf package is used to subset the data set as it is read
library(sqldf)

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "household_power_consumption.zip"
dataFile <- "household_power_consumption.txt"

# Download and unzip the data set as necessary
if (!file.exists(dataFile)) {
    if (!file.exists(zipFile)) {
        download.file(url=fileUrl, destfile=zipFile, method="curl")
        dateDownloaded <- date()
    }    
    unzip(zipFile)
}

# Read and subset the data set with read.cvs.sql in packege sqldf
powercons <- read.csv.sql(dataFile, sep=';',
                          sql='SELECT * FROM file WHERE Date="1/2/2007" OR Date="2/2/2007"')

# Convert Time and Date to usable format
powercons$Time <- strptime(paste(powercons$Date, powercons$Time), format="%d/%m/%Y %H:%M:%S")
powercons$Date <- as.Date(powercons$Time)

# It might be necessary to set the Time Locale on some systems to use English
# This is OS platform specific - tested on Ubuntu Linux 14.04 LTS and R 3.1.1
Sys.setlocale("LC_TIME", "C")

# Open png graphics device to construct plot4.png as 480x480 PNG image
png(filename="plot4.png", width=480, height=480)

# Multiple plots will be created in 2 columns and 2 rows
par(mfcol=c(2, 2))

# Plot 4a: Global_active_power as a function of Time
plot(powercons$Time, powercons$Global_active_power, type="l", xlab="",
     ylab="Global Active Power")

# Plot 4b: Sub_metering variables as a function of Time
plot(powercons$Time, powercons$Sub_metering_1, type="l", xlab="", 
     ylab="Energy sub metering")
lines(powercons$Time, powercons$Sub_metering_2, col="red")
lines(powercons$Time, powercons$Sub_metering_3, col="blue")
legend("topright", lwd=1, col=c("black", "red", "blue"),
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Plot 4c: Voltage as a function of Time
plot(powercons$Time, powercons$Voltage, type="l", xlab="datetime",
     ylab="Voltage")

# Plot 4d: Global_reactive_power as a function of Time
# Note that it is due to custom line width it is challenging
# to reconstruct the exact image. However I found lwd=0.6
# to work well on my system (Ubuntu Linux 14.04 LTS and R 3.1.1)
plot(powercons$Time, powercons$Global_reactive_power, type="l", lwd=0.6, xlab="datetime",
     ylab="Global_reactive_power")

# Close the png graphics device
dev.off()

# Please ignore the "closing unused connection" warnings that might
# be displayed on some platforms. No solution found so far:
# https://class.coursera.org/exdata-005/forum/thread?thread_id=42
