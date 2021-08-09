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

Furthermore install the **Rosserial Binaries** on your ROS workstation like [so](http://wiki.ros.org/rosserial_arduino/Tutorials/Arduino%20IDE%20Setup). Change the rosversion in respect to yours.

## Programm

In the provided **programm** folder you find the main sketch running on the ESP32-S2 and also the selfmade libraries for the flexsensors and the vibromotors.

[Arduino]:https://www.arduino.cc/en/software
