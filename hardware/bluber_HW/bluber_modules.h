#include <SoftwareSerial.h>
#include "A4988_DC.h"
#include "TinyGPS.h"

#define GPS_RX 4
#define GPS_TX 3
#define GPS_Serial_Baud 9600

#define GSM_RX 7
#define GSM_TX 8
#define GSM_Serial_Baud 9600

#define BT_RX 11
#define BT_TX 11


void Unavailable();
void LockFromUnavailable();
