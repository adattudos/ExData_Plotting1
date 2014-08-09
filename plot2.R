# This is the R script created for Exploratory Data Analysis Course Project 1
# Its goal is to reproduce plot2.png using Global Active Power data over a
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

# Open png graphics device to construct plot2.png as 480x480 PNG image
png(filename="plot2.png", width=480, height=480)

# Plot Global_active_power as a function of Time to reconstruct plot2
plot(powercons$Time, powercons$Global_active_power, type="l", xlab="",
     ylab="Global Active Power (kilowatts)")

# Close the png graphics device
dev.off()

# Please ignore the "closing unused connection" warnings that might
# be displayed on some platforms. No solution found so far:
# https://class.coursera.org/exdata-005/forum/thread?thread_id=42
