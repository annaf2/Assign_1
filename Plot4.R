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

#PLOT 4
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1))
with(data, plot(Global_active_power ~ DateTime,type= "l", ylab="Global Active Power"))
with(data, plot(Voltage ~ DateTime,type= "l", xlab="datetime", ylab="Voltage"))
with(data, plot(Sub_metering_1 ~ DateTime,type= "l", ylab="Energy sub metering"), col="black")
with(data, points(Sub_metering_2 ~ DateTime, type= "l", col="red"))
with(data, points(Sub_metering_3 ~ DateTime, type= "l", col="blue"))
legend("topright", pch = "-",cex=0.5, lwd=1, col = c("black","blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
with(data, plot(Global_reactive_power ~ DateTime,type= "l", xlab="datetime"))
dev.copy(png, file="Plot4.png")
dev.off()