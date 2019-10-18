#include<SoftwareSerial.h>
#include "TinyGPS.h"

SoftwareSerial SerialGPS(3, 4); // RX Arduino - TX Arduino
TinyGPS GPS;

float lat, lon, vel;
unsigned short sat;

void setup() {
  SerialGPS.begin(9600);
  Serial.begin(9600);

  Serial.println("Buscando satelites...");
}

void loop() {
  while (SerialGPS.available()) {
    
    if (GPS.encode(SerialGPS.read())) {

      //latitude e longitude
      GPS.f_get_position(&lat, &lon);

      Serial.print("Latitude: ");
      Serial.println(lat, 6);
      Serial.print("Longitude: ");
      Serial.println(lon, 6);

      //velocidade
      vel = GPS.f_speed_kmph();

      Serial.print("Velocidade: ");
      Serial.println(vel);

      //Satelites
      sat = GPS.satellites();

      if (sat != TinyGPS::GPS_INVALID_SATELLITES) {
        Serial.print("Satelites: ");
        Serial.println(sat);
      }

      Serial.println("");
    }
  }
}
