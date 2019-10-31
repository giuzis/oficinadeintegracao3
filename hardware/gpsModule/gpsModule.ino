#include <SoftwareSerial.h>
#include "TinyGPS.h"

//SoftwareSerial SerialGPS(8,9); // RX Arduino - TX 
#define SerialGPS Serial2

TinyGPS GPS;

//SoftwareSerial GSMSerial(6, 7); //SIM800L Tx & Rx is connected to Arduino #3 & #2
//
//SoftwareSerial BTSerial(4, 5);
char buf = '\0';

float lat, lon, vel;
unsigned short sat;

void setup() {
  SerialGPS.begin(9600);
  
  Serial.begin(9600);

  Serial.println("Buscando satelites...");
}

void loop() {
  
  Serial.println(SerialGPS.available());

    while (SerialGPS.available()) {  
      if (GPS.encode(SerialGPS.read())) {
  
        //latitude e longitude
        GPS.f_get_position(&lat, &lon);
  
        Serial.print("Latitude: ");
        Serial.println(lat, 6);
        Serial.print("Longitude: ");
        Serial.println(lon, 6);
  
      }
    }

}
  
