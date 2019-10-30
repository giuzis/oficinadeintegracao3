//Carrega a biblioteca SoftwareSerial
#include <SoftwareSerial.h>
 
//SoftwareSerial BTSerial(18,19);
#define BTSerial Serial2
 
int pushButton = 2;// digital pin 10 will read the state of a pushbutton
int led =13;
int stateOfButton = 0;
int LastState = LOW;
char buf;

void setup()
{
  Serial.begin(9600);
  BTSerial.begin(9600);
  pinMode(pushButton, INPUT);
  pinMode(led, OUTPUT);
  delay(1000); 

  handleConnectionLED();// sends a menu to the remote
  attachInterrupt(digitalPinToInterrupt(2), handleConnectionLED, CHANGE);// attach BT STATE pin to PIN 3, this provides a user menu on connection

}
 
void loop()
{
  verificaComandoCelular();
  delay(1000);
}

void verificaComandoCelular()
{
    Serial.println(BTSerial.available());

  //BTSerial.print("Teste\n");
  int watchDogCounter=0;
  while( BTSerial.available() > 0 )
  {
     buf = BTSerial.read();
     //Caracter L  para ligar o led
     Serial.println(buf);
     if (buf == 'L')
      digitalWrite(13, HIGH);

     //Caracter D  para desligar o led
     if (buf == 'D')
      digitalWrite(13, LOW);
     
    //se ficar mais de 5 segundos no loop,sai automaticamente
    delay(100);
    watchDogCounter++;
    if(watchDogCounter >50)
      break;
  }
}

void handleConnectionLED() {
  switch (digitalRead(2)) {// watch the interrupt pin (UNO)
  case LOW:// lost connection
     digitalWrite(led,LOW);// shows an external LED for connection status
     Serial.println("Desconectado");
     break;
  case HIGH:// got connection
     digitalWrite(led,HIGH);
     Serial.println("Connectado");                                        
     break;
  }
}
