# -----------------------------------------------------------
# Turtlebot 2: encoders info plot and analysis
# Copyright (C) 2015 Ana Cruz-Martín (anacruzmartin@gmail.com)
#  
# Measurements are read from rows of a file with this format:
#   [msgs_secs msgs_nsecs sensor_timestamp left_enc right_enc]
# where
#  msgs_secs = secs of the ROS message timestamp
#  msgs_nsecs = nsecs of the ROS message timestamp
#  sensor_timestamp = sensor measurement timestamp (msecs)
#  left_enc = left encoder reading
#  rigth_enc = right encoder reading
# -----------------------------------------------------------
  
  
max_value_encoder <- 65535  # max measurement taken by the encoder
sampling_period <- 0.02   # time gap between sensor readings (secs)
ticks2rads <- (2 * pi) / 2578.33  # encoder: 2578.33 ticks/wheel revolution (see Kobuki docs)

datafile <- read.table('datafile.txt')   # file where measurements are saved
datafile_dims <- dim(datafile)
datafile_rows <- datafile_dims[1]


# We plot the measurements taken by the encoders
t <- datafile[, 3] / 1e3
plot(t, datafile[ ,4], type='b', main='Turtlebot 2 encoders measurements', xlab='Sensor timestamp (secs)',
     ylab='Encoder measurement (ticks)', col='blue')
points(t, datafile[, 5], type='b', col='red')
legend('topright', lty=1, c('Left encoder','Right encoder'), col=c('blue','red'))

t <- datafile[ ,3] / 1e3
t <- t - t[1]
plot(t, datafile[ ,4], type='b', main='Turtlebot 2 encoders measurements', xlab='Absolute sensor timestamp (secs)',
     ylab='Encoder measurement (ticks)', col='blue')
points(t, datafile[ ,5], type='b', col='red')
legend('topright', lty=1, c('Left encoder','Right encoder'), col=c('blue','red'))

t <- datafile[ ,1] + datafile[ ,2]/1e9
plot(t, datafile[ ,4], type='b', main='Turtlebot 2 encoders measurements', xlab='Message timestamp (secs)',
     ylab='Encoder measurement (ticks)', col='blue')
points(t, datafile[ ,5], type='b', col='red')
legend('topright', lty=1, c('Left encoder','Right encoder'), col=c('blue','red'))

t <- datafile[ ,1] + datafile[ ,2]/1e9
t <- t - t[1]
plot(t, datafile[ ,4], type='b', main='Turtlebot 2 encoders measurements', xlab='Absolute message timestamp (secs)',
     ylab='Encoder measurement (ticks)', col='blue')
points(t, datafile[ ,5], type='b', col='red')
legend('topright', lty=1, c('Left encoder','Right encoder'), col=c('blue','red'))


# We check if encoders reset through the experiment
# If encoders reset, we readjust values adding the max value stored by the encoder, for further plots
left_encoder_row <- which((abs(diff(datafile[ ,4])) > 1000))
right_encoder_row <- which((abs(diff(datafile[ ,5])) > 1000))

if (left_encoder_row) {datafile[(left_encoder_row+1):datafile_rows,4] <- datafile[(left_encoder_row+1):datafile_rows,4] + (max_value_encoder + 1)}
if (right_encoder_row) {datafile[(right_encoder_row+1):datafile_rows,5] <- datafile[(right_encoder_row+1):datafile_rows,5] + (max_value_encoder + 1)}  


# We plot the speed of both wheel s
# speed = variation of encoders reading divided by time)
t <- datafile[2:datafile_rows,3] / 1e3
plot(t, diff(datafile[ ,4] * ticks2rads) / sampling_period, type='b', main='Turtlebot 2 wheels speeds',
     xlab='Sensor timestamp (secs)', ylab='Wheel speed (rads/sec)', col='blue')
points(t, diff(datafile[ ,5] * ticks2rads) / sampling_period, type='b', col='red')
legend('topright', lty=1, c('Left encoder','Right encoder'), col=c('blue','red'))

t <- datafile[2:datafile_rows,3] / 1e3
t <- t - t[1]
plot(t, diff(datafile[ ,4] * ticks2rads) / sampling_period, type='b', main='Turtlebot 2 wheels speeds',
     xlab='Absolute sensor timestamp (secs)', ylab='Wheel speed (rads/sec)', col='blue')
points(t, diff(datafile[ ,5] * ticks2rads) / sampling_period, type='b', col='red')
legend('topright', lty=1, c('Left encoder','Right encoder'), col=c('blue','red'))
