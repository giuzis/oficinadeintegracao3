#include <SoftwareSerial.h>

//Create software serial object to communicate with SIM800L
SoftwareSerial mySerial(6, 7); //SIM800L Tx & Rx is connected to Arduino #3 & #2

void setup()
{
  //Begin serial communication with Arduino and Arduino IDE (Serial Monitor)
  Serial.begin(9600);
  
  //Begin serial communication with Arduino and SIM800L
  mySerial.begin(9600);

  Serial.println("Initializing..."); 
  delay(1000);
  mySerial.println("AT"); //Once the handshake test is successful, it will back to OK
  updateSerial();
  delay(1000);
  mySerial.println("ATE1&W"); //Once the handshake test is successful, it will back to OK
  updateSerial();
  delay(1000);
  mySerial.println("AT+HTTPINIT"); // Configuring TEXT mode
  updateSerial();
  delay(1000);
  mySerial.println("AT+HTTPSSL=1"); // Configuring TEXT mode
  updateSerial();
  delay(1000);
  mySerial.println("AT+CGATT?"); // Configuring TEXT mode
  updateSerial();
  delay(1000);
  mySerial.println("AT+CIPMUX=0"); // Configuring TEXT mode
  updateSerial();
  delay(1000);
  mySerial.println("AT+CFUN=1"); // Enable All
  updateSerial();
  delay(1000);
  mySerial.println("AT+CPIN?");
  updateSerial();
  delay(1000);
  mySerial.println("AT+CSTT=\"tim.br\", \"tim\", \"tim\"");
  updateSerial();
  delay(1000);
  mySerial.println("AT+CIICR");
  updateSerial();
  delay(1000);
  mySerial.println("AT+CIFSR");
  updateSerial();
  delay(1000);
  mySerial.println("AT+CIPSTART=\"TCP\",\"bluberstg.firebaseio.com\",80");
  updateSerial();
  delay(3000);
  mySerial.println("AT+CIPSEND=50");
  updateSerial();
  delay(1000);
  mySerial.println("POST /users.json HTTP/1.1 { \"alarm\": \"jonas\" }");
  updateSerial();
  //mySerial.println("AT+CIPSHUT");
  //updateSerial();
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