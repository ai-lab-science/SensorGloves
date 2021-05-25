#include "libraries/FlexSensor.h"
#include "libraries/VibroMotor.h"
#include <Adafruit_NeoPixel.h>
#include <WiFi.h>
#include <ros.h>
#include <ros/time.h>
#include <math.h>
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>
#include <sensor_msgs/Imu.h>

#define RGB_PIN         18 
#define SDA_pin         11
#define SCL_pin         12

Adafruit_NeoPixel pixels(1, RGB_PIN, NEO_GRB + NEO_KHZ800);
Adafruit_BNO055 bno;

const char* ssid     = "Villa Blanck";
const char* password = "farafloroja26";
IPAddress server(192, 168, 178, 100);
const uint16_t serverPort = 11411;

const int numSensors = 8;
const int numVibros = 1;
const int readAmount = 50;
const int calAmount = 100;

FlexSensor flexSensors[numSensors];
FlexSensor thumbSensors[2];
float angles[numSensors+numSensors/2];
float thumbAngles[2];
imu::Quaternion quat;
imu::Vector<3> euler;
VibroMotor vibroMotors[numVibros];

ros::NodeHandle nh;
std_msgs::Float32 float_msg;
sensor_msgs::Imu imu_msg;

int pins[8] = {8, 7, 6, 5, 3, 4, 1, 2};
int thumbPins[2] = {9, 10};

String joints[numSensors] = {
  "/force_joints/hand/index_finger_joint_1",
  "/force_joints/hand/index_finger_joint_2",
  "/force_joints/hand/middle_finger_joint_1",
  "/force_joints/hand/middle_finger_joint_2",
  "/force_joints/hand/ring_finger_joint_1",
  "/force_joints/hand/ring_finger_joint_2",
  "/force_joints/hand/pinkie_finger_joint_1",
  "/force_joints/hand/pinkie_finger_joint_2",
};

String thumbJoints[2] = {
  "/force_joints/hand/thumb_base",
  "/force_joints/hand/thumb_finger_joint_2"
};

ros::Publisher flexPublishers[numSensors+(numSensors/2)] =
{ ros::Publisher("/force_joints/hand/index_finger_joint_1", &float_msg),
  ros::Publisher("/force_joints/hand/index_finger_joint_2", &float_msg),
  ros::Publisher("/force_joints/hand/middle_finger_joint_1", &float_msg),
  ros::Publisher("/force_joints/hand/middle_finger_joint_2", &float_msg),
  ros::Publisher("/force_joints/hand/ring_finger_joint_1", &float_msg),
  ros::Publisher("/force_joints/hand/ring_finger_joint_2", &float_msg),
  ros::Publisher("/force_joints/hand/pinkie_finger_joint_1", &float_msg),
  ros::Publisher("/force_joints/hand/pinkie_finger_joint_2", &float_msg),
  ros::Publisher("/force_joints/hand/index_finger_joint_3", &float_msg),
  ros::Publisher("/force_joints/hand/middle_finger_joint_3", &float_msg),
  ros::Publisher("/force_joints/hand/ring_finger_joint_3", &float_msg),
  ros::Publisher("/force_joints/hand/pinkie_finger_joint_3", &float_msg)
};
ros::Publisher thumbPublishers[2] =
{
  ros::Publisher("/force_joints/hand/thumb_base", &float_msg),
  ros::Publisher("/force_joints/hand/thumb_finger_joint_2", &float_msg)
};
ros::Publisher imuPub("/hand/imu_data", &imu_msg);

void vibroIndexCallBack(const std_msgs::Float32& float_msg) {
  vibroMotors[0].vibrate(float_msg.data);
}

ros::Subscriber<std_msgs::Float32> vibroSubscribers[numVibros] = 
{
  ros::Subscriber<std_msgs::Float32>("/index_finger_vibro", &vibroIndexCallBack)
};

void setup() {
  //This pixel is just way to bright, lower it to 10 so it does not hurt to look at.
  pixels.setBrightness(10);
  pixels.begin(); // INITIALIZE NeoPixel (REQUIRED)
  pixels.setPixelColor(0, 255, 0, 255);
  pixels.show();
  Serial.begin(115200);
  delay(10);
  // initialize I2C and BNO055
  Wire.begin(SDA_pin, SCL_pin);
  bno = Adafruit_BNO055(55, 0x28);
  if(!bno.begin())
  {
    // There was a problem detecting the BNO055 ... check your connections 
    Serial.print("Ooops, no BNO055 detected ... Check your wiring or I2C ADDR!");
    while(1);
  }
  Serial.println("BNO detected and initialised!");
  delay(1000);
  bno.setExtCrystalUse(true);

  // initialize WIFI
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  nh.getHardware()->setConnection(server, serverPort);
  Serial.println("setted the connection");
  nh.initNode();
  Serial.println("inited node");
  // initialize flexsensors
  for(int i = 0; i < numSensors; i++) {
    flexSensors[i] = FlexSensor();
    flexSensors[i].setup(i, joints[i], pins[i]);
  }
  for(int i = 0; i < 2; i++) {
    thumbSensors[i] = FlexSensor();
    thumbSensors[i].setup(numSensors+i, thumbJoints[i], thumbPins[i]);
  }
  for(int i = 0; i < numSensors+(numSensors/2); i++) {
    nh.advertise(flexPublishers[i]);
  }
  for(int i = 0; i < 2; i++) {
    nh.advertise(thumbPublishers[i]);
  }
  nh.advertise(imuPub);
  // initialize vibromotors
  for(int i = 0; i < numVibros; i++) {
    vibroMotors[i] = VibroMotor();
    vibroMotors[i].setup(i, 13+i);
  }
  for(int i = 0; i < numVibros; i++) {
    nh.subscribe(vibroSubscribers[i]);
  }
  Serial.println("finished setup");

  // wait for IMU calibration
  pixels.setPixelColor(0, 127, 255, 0);
  pixels.show();
  uint8_t system, gyro, accel, mag;
  system = gyro = accel = mag = 0;
  Serial.print("Wait for IMU Calibration");
  while(!system || gyro != 3 || accel != 3 || mag != 3) {
    bno.getCalibration(&system, &gyro, &accel, &mag);
    Serial.print("Sys:");
    Serial.print(system, DEC);
    Serial.print(" G:");
    Serial.print(gyro, DEC);
    Serial.print(" A:");
    Serial.print(accel, DEC);
    Serial.print(" M:");
    Serial.println(mag, DEC);
  }
  pixels.setPixelColor(0, 255, 165, 0);
  pixels.show();
  /* Display the individual values */
  Serial.println();
  Serial.print("Sys:");
  Serial.print(system, DEC);
  Serial.print(" G:");
  Serial.print(gyro, DEC);
  Serial.print(" A:");
  Serial.print(accel, DEC);
  Serial.print(" M:");
  Serial.println(mag, DEC);
  calibrateFlexSensors(calAmount);
  pixels.setPixelColor(0, 0, 255, 0);
  pixels.show();
}

void loop() {
  // collect sensor values
  if (nh.connected()) {
    pixels.setPixelColor(0, 0, 255, 0);
    pixels.show(); 
    for(int i = 0; i < numSensors; i++) {
      angles[i] = flexSensors[i].readAngle(readAmount, false);
      float_msg.data = angles[i] * M_PI / 180.0;
      flexPublishers[i].publish(&float_msg);
    }
    for(int i = 0; i < numSensors/2; i++) {
      angles[numSensors+i] = angles[1+2*i]/2;
      float_msg.data = angles[numSensors+i] * M_PI / 180.0;
      flexPublishers[numSensors+i].publish(&float_msg);
    }
    for(int i = 0; i < 2; i++) {
      thumbAngles[i] = thumbSensors[i].readAngle(readAmount, false);
      float_msg.data = thumbAngles[i] * M_PI / 180.0;
      thumbPublishers[i].publish(&float_msg);
    }
    /* read IMU */ 
    quat = bno.getQuat();
    imu_msg.orientation.x = quat.x();
    imu_msg.orientation.y = quat.y();
    imu_msg.orientation.z = quat.z();
    imu_msg.orientation.w = quat.w();
    imu::Vector<3> accel = bno.getVector(Adafruit_BNO055::VECTOR_LINEARACCEL);
    imu_msg.linear_acceleration.x = accel.x();
    imu_msg.linear_acceleration.y = accel.y();
    imu_msg.linear_acceleration.z = accel.z();
    imu::Vector<3> gyro = bno.getVector(Adafruit_BNO055::VECTOR_GYROSCOPE);
    imu_msg.angular_velocity.x = gyro.x();
    imu_msg.angular_velocity.y = gyro.y();
    imu_msg.angular_velocity.z = gyro.z();
    imu_msg.header.stamp = nh.now();
    imuPub.publish(&imu_msg);
    if(Serial.available()) {
      int in = Serial.read();
      Serial.println(in);
      if(in == 32) {
        calibrateFlexSensors(calAmount);
        nh.getHardware()->setConnection(server, serverPort);
        Serial.println("setted the connection");
        nh.initNode();
        Serial.println("inited node");
        for(int i = 0; i < numSensors+(numSensors/2); i++) {
          nh.advertise(flexPublishers[i]);
        }
        for(int i = 0; i < 2; i++) {
          nh.advertise(thumbPublishers[i]);
        }
        nh.advertise(imuPub);
        for(int i = 0; i < numVibros; i++) {
          nh.subscribe(vibroSubscribers[i]);
        }
        Serial.println("finished setup");
        //while(Serial.available()){Serial.read();}
      }
    }
    // Vibro Feedback
    /*for(int i = 0; i < numVibros; i++) {
      Serial.println("Vibrating");
      vibroMotors[i].cycle();
    }*/
  } else {
    //Serial.println("not connected");
    pixels.setPixelColor(0, 255, 0, 0);
    pixels.show();
  }
  nh.spinOnce();
}

void calibrateFlexSensors(int amount) {
  Serial.println("Waiting for input to start calibrating flat position....");
  while(Serial.available()){Serial.read();}
  while(!Serial.available()){}
  while(Serial.available()){Serial.read();}
  Serial.println("Calibrating Flat position: ");
  Serial.println("Lay the hand flat on a flat surface, so the sensors are at 0 degrees.");
  pixels.setPixelColor(0, 136, 0, 255);
  pixels.show();
  for(int i = 0; i < numSensors; i++) {
    while(Serial.available()){Serial.read();}
    while(!Serial.available()){}
    while(Serial.available()){Serial.read();}
    flexSensors[i].calibrateFlat(amount);
  }
  for(int i = 0; i < 2; i++) {
    while(Serial.available()){Serial.read();}
    while(!Serial.available()){}
    while(Serial.available()){Serial.read();}
    thumbSensors[i].calibrateFlat(amount);
  }
  Serial.println("Waiting for input to start calibrating bend position....");
  while(Serial.available()){Serial.read();}
  while(!Serial.available()){}
  while(Serial.available()){Serial.read();}
  Serial.println("Calibrating Bend position: ");
  Serial.println("Clamp your Hand, except the thump, that all sensors are at 90 degrees.");
  pixels.setPixelColor(0, 0, 0, 255);
  pixels.show();
  for(int i = 0; i < numSensors; i++) {
    while(Serial.available()){Serial.read();}
    while(!Serial.available()){}
    while(Serial.available()){Serial.read();}
    flexSensors[i].calibrateBend(amount);
  }
  Serial.println("Waiting for input to start calibrating bend position of thumb....");
  while(Serial.available()){Serial.read();}
  while(!Serial.available()){}
  while(Serial.available()){Serial.read();}
  Serial.println("Now the thumb:");
  for(int i = 0; i < 2; i++) {
    while(Serial.available()){Serial.read();}
    while(!Serial.available()){}
    while(Serial.available()){Serial.read();}
    thumbSensors[i].calibrateBend(amount);
  }
}
