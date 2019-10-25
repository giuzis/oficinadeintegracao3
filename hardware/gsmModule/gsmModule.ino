#include <SoftwareSerial.h>

//Create software serial object to communicate with SIM800L
SoftwareSerial mySerial(6, 7); //SIM800L Tx & Rx is connected to Arduino #3 & #2

int gsmcheck;
char atRxBuffer[100];
uint8_t index = 0;

char buf[5] = {'\0','\0','\0','\0','\0'};
char i=0;

void setup()
{
  //Begin serial communication with Arduino and Arduino IDE (Serial Monitor)
  Serial.begin(9600);
  //Begin serial communication with Arduino and SIM800L
  mySerial.begin(9600);
  
  Serial.println("Initializing...");
  delay(1000);

//  mySerial.println("AT"); //Once the handshake test is successful, it will back to OK
//  updateSerial();
//  mySerial.println("AT+SAPBR=3,1,\"APN\",\"tim\""); //Signal quality test, value range is 0-31 , 31 is the best
//  updateSerial();
//  mySerial.println("AT+SAPBR=1,1"); //Read SIM information to confirm whether the SIM is plugged
//  updateSerial();
//  mySerial.println("AT+HTTPINIT"); //Check whether it has registered in the network
//  updateSerial();
////  mySerial.println("AT");
////    updateSerial();
////  mySerial.println("AT+SAPBR=3,1,\"APN\",\"tim\"");
////    updateSerial();    
////  mySerial.println("AT+SAPBR=1,1");
////  updateSerial();
////  mySerial.println("AT+HTTPINIT");
////  updateSerial();
//  mySerial.println("AT+HTTPSSL=1");
//  updateSerial();
//  mySerial.println("AT+HTTPPARA=\"CID\",1");
//  updateSerial();
//  mySerial.println("AT+HTTPPARA=\"URL\",\"bluberstg.firebaseio.com/usuario.json\"");
//  updateSerial();
//  mySerial.println("AT+HTTPDATA=10,1000");
//  updateSerial();
//  mySerial.write("-25,146458");
//  updateSerial();
//  mySerial.write("AT+HTTPACTION=0");
//  updateSerial();
////  mySerial.println("AT+HTTPTERM");
////  updateSerial();
////  mySerial.println("AT+SAPBR=0,1");
////  updateSerial();
}
void loop()
{
  updateSerial();
}

void updateSerial()
{
  delay(500);
  while (Serial.available()) 
  {
    mySerial.write(Serial.read());//Forward what Serial received to Software Serial Port
  }
  while(mySerial.available()) 
  {
    Serial.write(mySerial.read());//Forward what Software Serial received to Serial Port
  }
}
