#include "Arduino.h" 
#include <Adafruit_NeoPixel.h>
#include <ros.h>
#include <std_msgs/Float32.h>

class FlexSensor {
    private:
    int ID;                           // id of the sensor
    String JOINT;
    int FLEX_PIN;                     // analog input pin
    float FLAT;
    float BEND;

    public:
    FlexSensor() {

    }

    void setup(int newID, String newJOINT, int newFLEX_PIN) {
        ID = newID;
        JOINT = newJOINT;
        FLEX_PIN = newFLEX_PIN;

        pinMode(FLEX_PIN, INPUT);
    }

    float readAngle(int amount, bool bol) {
        /*// Read the ADC, and calculate voltage and resistance from it
        int flexADC = analogRead(FLEX_PIN);
        float flexV = (flexADC * VCC / 8191.0)-OFFSET;
        float flexR = R_DIV * (VCC / flexV - 1.0);
        Serial.println("ADC: " + String(flexADC));
        Serial.println("Voltage: " + String(flexV) + " volt");
        Serial.println("Resistance: " + String(flexR) + " ohms");

        // Use the calculated resistance to estimate the sensor's
        // bend angle:
        float angle = map(flexR, STRAIGHT_RESISTANCE, BEND_RESISTANCE, 0, 110.0);
        return angle;*/
        int flexADC = analogRead(FLEX_PIN);
        int cal[amount];
        for(int i = 0; i < amount; i++) {
            cal[i] = analogRead(FLEX_PIN);
        }
        // Number of items in the array
        int cal_length = sizeof(cal) / sizeof(cal[0]);
        // qsort - last parameter is a function pointer to the sort function
        qsort(cal, cal_length, sizeof(cal[0]), sort_desc);
        int sum = 0;
        for(int i = 1*amount/10; i < 9*amount/10; i++) {
            sum += cal[i];
        }
        float avg = sum/(8*amount/10);
        if(bol) {
            return avg;
        } 
        float angle = map(avg, FLAT, BEND, 0.0, 90.0);
        return angle;
    }

    // qsort requires you to create a sort function
    static int sort_desc(const void *cmp1, const void *cmp2) {
        // Need to cast the void * to int *
        int a = *((int *)cmp1);
        int b = *((int *)cmp2);
        // The comparison
        return a > b ? -1 : (a < b ? 1 : 0);
        // A simpler, probably faster way:
        //return b - a;
    }

    void calibrateFlat(int amount) {
        Serial.println("Calibrating " + JOINT + " in Flat position");
        int cal[amount];
        for(int i = 0; i < amount; i++) {
            cal[i] = readAngle(100, true);
            delay(10);
        }
        // Number of items in the array
        int cal_length = sizeof(cal) / sizeof(cal[0]);
        // qsort - last parameter is a function pointer to the sort function
        qsort(cal, cal_length, sizeof(cal[0]), sort_desc);
        int sum = 0;
        for(int i = 1*amount/10; i < 9*amount/10; i++) {
            sum += cal[i];
        }
        FLAT = sum/(8*amount/10);
        Serial.println(FLAT);
    }

    void calibrateBend(int amount) {
        Serial.println("Calibrating " + JOINT + " in Bend position");
        int cal[amount];
        for(int i = 0; i < amount; i++) {
            cal[i] = readAngle(100, true);
            delay(10);
        }
        // Number of items in the array
        int cal_length = sizeof(cal) / sizeof(cal[0]);
        // qsort - last parameter is a function pointer to the sort function
        qsort(cal, cal_length, sizeof(cal[0]), sort_desc);
        int sum = 0;
        for(int i = 1*amount/10; i < 9*amount/10; i++) {
            sum += cal[i];
        }
        BEND = sum/(8*amount/10);
        Serial.println(BEND);
    }
};