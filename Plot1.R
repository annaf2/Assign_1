library(data.table)

#find rows with dates 2007-02-01 and 2007-02-02 and read only them to data
lines <- grep('^[1-2]/2/2007', readLines('household_power_consumption.txt'))
skip=lines[1]-1
nrows=length(lines)
data <-  fread("household_power_consumption.txt", sep=";", header=T, nrows=0)
colNames <- colnames(data) #keeps columnnames 
data <- fread("household_power_consumption.txt", sep=";", header=F, na.strings="?", skip=skip, nrows=nrows)
setnames(data,old=c(1:9), new=colNames)
#change format to date and time
data$DateTime <- paste(data$Date,data$Time)
data$DateTime <- as.POSIXct(strptime(data$DateTime, "%d/%m/%Y %H:%M:%S"))

#PLOT 1
with(data, hist(Global_active_power, main = "Global Active Power", col="red", 
	xlab="Global Active Power (kilowatts)"))
dev.copy(png, file="Plot1.png")
dev.off()
