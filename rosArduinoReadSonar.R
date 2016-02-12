#!/usr/bin/r

#-------------------------------------------------------
# This script subscribes to a topic where an Arduino is
# publishing distance measurements read from an HC-SR04, 
# ultrasonic sensor, and then sends them to a plot.
#
# It is based on the demo scripts from the rosR packages
# http://wiki.ros.org/rosR
# https://gitlab.com/OvGU-ESS/rosR
# 
# Ana Cruz-Martin 2016
#-------------------------------------------------------

source(paste(system("rospack find rosR",intern=TRUE),"/lib/ros.R",sep=""),chdir=TRUE)
X11()
ros.Init("R_arduino")

subscription <- ros.Subscriber("/sonar_topic", "std_msgs/Float32")

# x and y are vectors of length 10, filled with 0s
time <- rep(0, 10)
distance <- rep(0, 10)

while(ros.OK()) # evaluates to TRUE as long as the master online
{ 
	ros.SpinOnce()
	if(ros.SubscriberHasNewMessage(subscription))
	{
		message <- ros.ReadMessage(subscription)
		distance <- c(distance[-1], message$data)  # append message$data values to the end of y vector
		time <- c(time[-1], ros.TimeNow()) # append time values to the end of x vector

		# When vectors are filled, the plot looks like a real-time plot
		plot(time, distance, t="p", col="blue", xlab='Time', ylab='Distance (cm,)', main='Sonar distance measurements')
                print(message$data) # sensor readings are also printed in console, just to check
	}
}
