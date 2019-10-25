#include <SoftwareSerial.h>
#include <Wire.h>
#include "A4988_DC.h"
#include "TinyGPS.h"

#define GPS_RX 8
#define GPS_TX 9
#define GPS_Serial_Baud 9600

#define GSM_RX 6
#define GSM_TX 7
#define GSM_Serial_Baud 9600

#define BT_RX 4
#define BT_TX 5

#define SENSOR_LOCK A1
#define SENSOR_UNLOCK A3
