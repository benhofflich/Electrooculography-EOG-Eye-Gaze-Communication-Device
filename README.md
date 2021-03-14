# Electrooculography-EOG-Eye-Gaze-Communication-Device

Connect horizontal lead to pin A0 of the Arduino
Connect vertical lead to pin A1 of the Arduino
Provide Arduino with -2.5V offset voltage to ground for proper Analog to Digital conversion
Upload EOG_Recording.ino sketch to Arduino

Make sure color.m is downloaded and in path for MATLAB
color.m creates a grid with the specified box highlighted as directed in the BENG 186B Final Project Eye Tracking.m code

For the BENG 186B Final Project Eye Tracking.m code:
  Connect Arduino to MATLAB
  Run the calibration section and follow directions as prompted in the command window
  Run 'Eye Tracking' Trial section to control movement of highlighted grid
