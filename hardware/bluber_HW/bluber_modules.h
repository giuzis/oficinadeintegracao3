#include <SoftwareSerial.h>
#include <Wire.h>
#include "A4988_DC.h"
#include "TinyGPS.h"

#define GPS_RX 11
#define GPS_TX 12
#define GPS_Serial_Baud 9600

#define GSM_RX 7
#define GSM_TX 8
#define GSM_Serial_Baud 9600

#define BT_RX 11
#define BT_TX 11

#define Sensor_lock A0
#define Sensor_unlock A1

