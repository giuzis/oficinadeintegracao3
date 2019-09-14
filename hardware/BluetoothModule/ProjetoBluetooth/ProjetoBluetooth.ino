//Carrega a biblioteca SoftwareSerial
#include <SoftwareSerial.h>
 
 
int pushButton = 2;// digital pin 10 will read the state of a pushbutton
int led =13;
int stateOfButton = 0;
int LastState = LOW;
char buf;

void setup()
{
  Serial.begin(9600);
  pinMode(pushButton, INPUT);
  pinMode(led, OUTPUT);
  delay(1000); 

  handleConnectionLED();// sends a menu to the remote
  attachInterrupt(1, handleConnectionLED, CHANGE);// attach BT STATE pin to PIN 3, this provides a user menu on connection

}
 
void loop()
{
 
  if(LastState != digitalRead(pushButton) )
  {
    if( digitalRead(pushButton) == HIGH)
    {
      Serial.println("Estado da chave= Ligado");
      LastState = HIGH;
    }
    else
    {
      Serial.println("Estado da chave= Desligado");
      LastState = LOW;
    }
  }
  
  verificaComandoCelular();
  delay(1000);
}

void verificaComandoCelular()
{
  int watchDogCounter=0;
  while( Serial.available() > 0 )
  {
     buf = Serial.read();
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
  switch (digitalRead(3)) {// watch the interrupt pin (UNO)
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
