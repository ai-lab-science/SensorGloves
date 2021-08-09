# Software

Here, the software that runs on the microcontroller of the SensorGlove is described.

Download the folders and proceed as following:

## Arduino IDE setup

Download and install the [Arduino] IDE on your machine.

Follow the examples provided [here](https://github.com/espressif/arduino-esp32/tree/master#esp32-s2-and-esp32-c3-support). Add the provided additional Boards URL in your Preferences and then install the latest ESP32 Boards through the Board Manager.

## Libraries

Within the **libraries** folder are all official libraries we used for our SensorGlove. Include them into your IDE with this [help](http://www.arduino.cc/en/Guide/Libraries).

### Important!

It is especially important, that you use our provided version of the **Rosserial** library, since we had to modify it to work on the ESP32-S2.

## Further ROS setup

Furthermore install the **Rosserial Binaries** on your ROS workstation like [so](http://wiki.ros.org/rosserial_arduino/Tutorials/Arduino%20IDE%20Setup). Change the rosversion in respect to yours.

Find out your workstations IP adress with:
ifconfig

Then open the bashrc file in the terminal with:
nano .bashrc
Then add the following dependencies and fill in your IP adress in the first row:
export ROS_IP=yourIPHere
export ROS_MASTER_URI=http://$ROS_IP:11311 
export ROS_HOSTNAME=$ROS_IP

It is important to close all terminals and reopen them now!

## Programm

In the provided **programm** folder you find the main sketch running on the ESP32-S2 and also the selfmade libraries for the flexsensors and the vibromotors.

## Run it

Change the ssid and the password to your corresponding wifi connection in the main.ino file.
Change the server IPAddress to your workstations IP adress that you found out earlier.

Upload the main.ino file onto your ESP.
Open a terminal:
roscore

Open a second terminal:
rosrun rosserial_python serial_node.py tcp

[Arduino]:https://www.arduino.cc/en/software
