#include <SoftwareSerial.h>
//Declaração de Variáveis

int pushButton = 2;
int led = 13;
int stateOfButton =0;
int LastState = LOW;
char buf;


void setup() {
  // declaração dos pinos e inicialização
  Serial.begin(9600);
  pinMode(pushButton, INPUT);
  pinMode(led, OUTPUT);
  delay(1000);

}

void loop() {
  // Verifica se houve alguma mudança no estado do push button

  if(LastState != digitalRead(pushButton))
  {
    if(digitalRead(pushButton) == HIGH)
    {
      Serial.println("Estado da chave = Ligado");
      LastState = HIGH;
    }
    else
    {
      Serial.println("Estado da chave = Desligado");
      LastState = LOW;  
    }

    verificaComandoCelular();
    delay(1000);
    
  }
}

void verificaComandoCelular()
{
  int watchDogCounter = 0;
  while( Serial.available() > 0)
  {
    buf = Serial.read();

     //Caracter L para ligar o led
     Serial.println(buf);
     if(buf == 'L')
      digitalWrite(13, HIGH);

    delay(100);

    watchDogCounter++;
    if(watchDogCounter > 50)
      break;
  }
}
