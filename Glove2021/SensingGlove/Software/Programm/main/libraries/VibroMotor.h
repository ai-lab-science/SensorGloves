#include "Arduino.h" 

class VibroMotor {
    private:
    int ID;
    int PIN;

    public:
    VibroMotor() {

    }

    void setup(int newID, int newPIN) {
        ID = newID;
        PIN = newPIN;
        const int resolution = 8;
        const int freq = 5000;
        // configure PWM functionalitites
        ledcSetup(ID, freq, resolution);  
        // attach the channel to the GPIO to be controlled
        ledcAttachPin(PIN, ID);
    }

    void vibrate(float f) {
        int cycle = 155 + 100 * f;
        if(cycle <= 155) {
            cycle = 0;
        }
        ledcWrite(ID, cycle);
    }

    void cycle() {
        for(int dutyCycle = 0; dutyCycle <= 255; dutyCycle++){
            // changing the LED brightness with PWM
            ledcWrite(ID, dutyCycle);
            delay(15); 
        }
        for(int dutyCycle = 255; dutyCycle >= 0; dutyCycle--){
            // changing the LED brightness with PWM
            ledcWrite(ID, dutyCycle);
            delay(15);
        }
    }

};