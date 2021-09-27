# Hardware

Here we will present how we build our SensorGlove and provide a parts list if you want to build your own.

## Parts list

- microcontroller ESP32-S2
    
    We chose this special microcontroller, since it has build in WiFi and provides a 10-Channel ADC which is important so we can hook up all of our flexsensors to one board.
- 2.2" flex sensors

    You will need at least 8 of these for every joint.
- 1" flex sensors

    If you can get your hands on 2 of these small flex sensors for the front joints of the thumb and pinkie finger your setup will be perfect. Since these are very hard to get, get 2 more of the 2.2" flex sensors for these joints (total of 10 flex sensors).
- Resistors

    You will need 10 of those, one for each flex sensor. The resistance of them should be in the middle of the range of your flex sensors. Therefore measure the relaxed and the bend resistance of them with a multimeter.
- Vibro Motors

    You need 5 small 3.3V Vibromotors for each fingertip. 
- Electronic parts

    General parts like crimping tools, cables etc. are prerequesites.
- thight gloves

    This will be the base for all the sensors and electronics, which will be fixed on the glove. Make sure to use a glove that fits perfectly, since additional fabric will affect the placement and measurements of the flex sensors.
- 3D printed parts

    An access to a 3D printer is also necessary.

## Building Instruction
