# Simulation

For better understanding of the sensor values and quick evaluation of the gloves performance, we hereby introduce a real time simulation environment in [Unity]. Note that the access to this simulation environment is restricted to Windows users. To make use of the provided [ROS] framework under these conditions, we rely on [ROS#].

## Unity

First of all, download and install Unity from [here](https://unity3d.com/de/get-unity/download). We used version 2020.2.1f1, but it should also work with the latest release version.

## Ubuntu Virtual Machine

Then install a Virtual Machine. Follow the instruction steps from [here](https://brb.nci.nih.gov/seqtools/installUbuntu.html). Use Ubuntu 18.04 for convenience. 

Furthermore, set up the network adapters from the VM like [so](https://github.com/siemens/ros-sharp/wiki/User_Inst_UbuntuOnOracleVM).

## ROS

After that, set up [ROS] in your VM. Download and install ROS Melodic as described [here](http://wiki.ros.org/melodic/Installation/Ubuntu). Make sure to do the **Desktop-Full Install**.
Also configure your workspace by following [this](http://wiki.ros.org/ROS/Tutorials/InstallingandConfiguringROSEnvironment).

Then install [rosbridge-suite](http://wiki.ros.org/rosbridge_suite) through the terminal via
```shell
sudo apt-get install ros-melodic-rosbridge-server
```

Now add the [ROS#] functionalities to your workspace by downloading and placing the [file_server](https://github.com/siemens/ros-sharp/tree/master/ROS/file_server) package into the **src** folder of your Catkin workspace and build it by running
```shell
catkin_make
```
in the root folder of your workspace. You can also find these steps [here](https://github.com/siemens/ros-sharp/wiki/User_Inst_ROSOnUbuntu).

## Environment

Download the **HandSim** folder from this repository and open it in Unity as a project.

[Unity]:https://unity.com/
[ROS#]:https://github.com/siemens/ros-sharp
[ROS]:https://www.ros.org/