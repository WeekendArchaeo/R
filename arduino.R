#!/usr/bin/r

#-------------------------------------------------------
# This script subscribes to a topic where an Arduino is
# publishing data readings from a FSR sensor, and then
# sends them to a plot.
#
# It is based on the demo scripts from the rosR packages
# http://wiki.ros.org/rosR
# https://gitlab.com/OvGU-ESS/rosR
# 
# Ana Cruz-Martin 2015
#-------------------------------------------------------

source(paste(system("rospack find rosR",intern=TRUE),"/lib/ros.R",sep=""),chdir=TRUE)
X11()
ros.Init("R_arduino")

subscription <- ros.Subscriber("/chatter", "std_msgs/Int16")

# time and voltage are vectors of length 20, filled with 0s
time <- rep(0, 50)
voltage <- rep(0, 50)

while(ros.OK()) # evaluates to TRUE as long as the master online
{ 
	ros.SpinOnce()
	if(ros.SubscriberHasNewMessage(subscription))
	{
		message <- ros.ReadMessage(subscription)
		voltage <- c(voltage[-1], message$data)  # append message$data values to the end of voltage vector
		time <- c(time[-1], ros.TimeNow()) # append time values to the end of time vector

		# When vectors are filled, the plot looks like a real-time plot
		plot(time, voltage, t="l", col="blue", xlab='Time', ylab='Voltage (mV)', main='FSR readings')
                print(message$data) # sensor readings are also printed in console, just to check
	}
}
