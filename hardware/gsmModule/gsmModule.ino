#include <SoftwareSerial.h>

//Create software serial object to communicate with SIM800L
SoftwareSerial mySerial(6, 7); //SIM800L Tx & Rx is connected to Arduino #3 & #2

int gsmcheck;
char atRxBuffer[100];
uint8_t index = 0;



void setup()
{
  //Begin serial communication with Arduino and Arduino IDE (Serial Monitor)
  Serial.begin(9600);
  //Begin serial communication with Arduino and SIM800L
  mySerial.begin(9600);
  
  mySerial.println("AT");
  updateSerial();
  mySerial.println("AT+SAPBR=3,1,\"APN\",\"tim\"");
  updateSerial();
  mySerial.println("AT+SAPBR=1,1");
  updateSerial();
  mySerial.println("AT+HTTPINIT");
  updateSerial();
  mySerial.println("AT+HTTPSSL=1");
  updateSerial();
  mySerial.println("AT+HTTPPARA=\"CID\",1");
  updateSerial();
  mySerial.println("AT+HTTPPARA=\"URL\",\"bluberstg.firebaseio.com/usuario/latitude.json\"");
  updateSerial();
  mySerial.println("AT+HTTPDATA=10,10000");
  updateSerial();
  mySerial.println("-25,146458");
  updateSerial();
  mySerial.println("AT+HTTPACTION=1");
  delay(5000);
  updateSerial();
  mySerial.println("AT+HTTPTERM");
  updateSerial();
  mySerial.println("AT+SAPBR=0,1");
  updateSerial();
}

void loop()
{
  updateSerial();
}

void updateSerial()
{
  while (Serial.available()) 
  {
    mySerial.write(Serial.read());//Forward what Serial received to Software Serial Port
  }
  while(mySerial.available()) 
  {
    Serial.write(mySerial.read());//Forward what Software Serial received to Serial Port
  }
}
