# Accelerometer_Integration
Combine several accelerometers attached to a rigid body into an equivalent accelerometer without the need of angular movement information

Run acc_i.m which is the main file.
It uses the following functions:
  AddWhiteNoise
  CalAcc2
  GenerateSin
It demonstrates an example integration of 5 accelerometers on a rigid body into an equivalent accelerometer.

At first it generate arbitrary linear and angular motions of the rigid body.
An then calculates the accelerations at 5 locations.
And then calculates the position and values of the integrated accelerometer.
Finally, compares the results and plots.
