#include "bluber_modules.h"

/* Global vars */
uint8_t stateflag = 0;              // variavel
bool enable_con = false;
float lat, lon, old_lat, old_lon;

// -> Gyro vars
bool send2server;
bool flag_gyro;

/* DC Motor Module */
Motor* motor;

/* GSM Module */
SoftwareSerial GSMSerial(GSM_TX, GSM_RX); //SIM800L Tx & Rx is connected to Arduino #3 & #2
String gsmcheck;

/* GPS Module */
TinyGPS GPS;
SoftwareSerial GPSSerial(GPS_RX, GPS_TX);

/* Bluetooth Module */
SoftwareSerial BTSerial(4,5);
int led =13;
char buf;

void verifyCharFromApp(){
  
  Serial.println(BTSerial.available());
  int watchDogCounter=0;
  while( BTSerial.available() > 2 )
  {
      BTSerial.print("Disp\n");

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

/* Gyro Module */
//Adress of I2C 
const int MPU=0x68;
//int acelX,acelY,acelZ,temperatura,giroX,giroY,giroZ;

 /* Buzzer Module */
//int buzzer = A6;
//bool enable_buzzer = false;

void BluetoothInterrupt(){  
  switch (digitalRead(2)) {// watch the interrupt pin (UNO)
  case LOW:// lost connection
     digitalWrite(led,LOW);// shows an external LED for connection status
     enable_con = false;
     Serial.println("Desconectado");
     break;
  case HIGH:// got connection
     digitalWrite(led,HIGH);
     // Enable the connection flag
     enable_con = true;
     Serial.println("Connectado");                                        
     break;
  }

       enable_con = true;


};
void setup() {
	/* Sensors */
	pinMode(A0, OUTPUT);
	pinMode(SENSOR_LOCK, INPUT_PULLUP); // Lock Sensor - Close to the battery
	pinMode(A2, OUTPUT);
	pinMode(SENSOR_UNLOCK, INPUT_PULLUP); // Unlock Sensor - Close to the circuit
	digitalWrite(A0, LOW);
	digitalWrite(A2, LOW);

	/* Serial Monitor */
	Serial.begin(9600);

  /* DC Motor Module */
  motor = new Motor();
  digitalWrite(12, LOW);
  digitalWrite(11, LOW);
  digitalWrite(10, LOW);
  motor->setPins(12, 11, 10); // step, enable, reset
  motor->stop();
  motor->setSpeed(50);
 
	/* Bluetooth Module */
  BTSerial.begin(9600);
  pinMode(led, OUTPUT);
  delay(1000); 
 
  BluetoothInterrupt();// sends a menu to the remote
  attachInterrupt(digitalPinToInterrupt(2), BluetoothInterrupt, CHANGE);
   
	/* Gyroscope Module */
  Wire.begin();                 //Start I2C
  Wire.beginTransmission(MPU);  //Start TX to MPU
  Wire.write(0x6B);
  Wire.write(0); 
  Wire.endTransmission(true);    

  /* GPS Module */
//  GPSSerial.begin(GPS_Serial_Baud);

//  /* GSM Module */
//  //Begin serial communication with Arduino and SIM800L
// GSMSerial.begin(GSM_Serial_Baud);

//  /* Buzzer Module */
   pinMode(A6, OUTPUT);
}

/* General System Functions */
void Unavailable(){

	// While Bluetooth doesn't receive a connection
	while(!enable_con);

    // Read BT Data 
    verifyCharFromApp();
    delay(1000);
    
    Serial.println("DENTRO");

    Serial.println(buf);
    //Serial.println(stateflag);
    if(buf == 'L'){ // L to lock
      Serial.println("Foi!");
      stateflag = 1;
    }
}
void LockFromUnavailable(){

  Serial.println("Fechando!");
  // Motor movement to lock the mechanism
  // motor->toggleDirection();

  motor->run();

  // While does not have an LOW input
  while(digitalRead(SENSOR_LOCK)); // Check sensors
  
  motor->stop();
   
  // Changing flag state
  stateflag = 2; //BikeStop

  motor->toggleDirection();
  
}
void BikeStop(){
  
	// GPS Read location
//  if (GPS.encode(GPSSerial.read()) == true) {
//  	GPS.f_get_position(&lat, &lon);
//  	if(old_lat != lat || old_lon != lon){
//  		old_lat = lat;
//  		old_lon = lon;
//  		send2server = true;
//  	}
//  }

  if(send2server == true){
  		send2server = false;
  		// Send data to server
  		// 
  		// 
  		// 
  		// 
  		// 
  }

  if(flag_gyro == true){
  	// Medição de dados do gyro
  	// Matemática para descobrir se há roubo

  	// Se posição muito diferente da ultima medição

  	  // Enable Buzzer
      

  	// Send Alarm notification
  }

  // Chamo a funcao se a flag do buzzer estiver ativa



  // Read BT Data 
  verifyCharFromApp();

  // Go to BikeWaitRenting if 'R'
  if(buf == 'R')
    stateflag = 4;
  else
  // Go to UnlockFromOwner if 'U'
  if(buf == 'U')
    stateflag = 3;
  else
    stateflag = 2;
}
void UnlockFromOwner(){
  // Motor movement to unlock the mechanism

  motor->run();

  // While does not have an LOW input
  while(digitalRead(SENSOR_UNLOCK)); // Check sensors
  
  motor->stop();
   
  // Changing flag state
  stateflag = 0; //Unavailable

  motor->toggleDirection();
}
void BikeWaitRenting(){
  char buf = '\0';
  
   buf = BTSerial.read();

   // K comes from the smartphone to unlock the mechanism
 	 if (buf == 'U')
 	 	// if K, goes to UnlockFromRent
   	stateflag = 5;
   else
   	//Back to this function
   	stateflag = 4;	
}
void UnlockFromRent(){
  // Motor movement to unlock the mechanism
  // motor->toggleDirection();

  motor->run();

  // While does not have an LOW input
  while(digitalRead(SENSOR_UNLOCK)); // Check sensors
  
  motor->stop();
   
  // Changing flag state
  stateflag = 6; //Unavailable

  motor->toggleDirection();
}
void BikeRented(){
	char buf;
	// GPS Read Location

	// GPS Send to the server

	// Bluetooth read data
	verifyCharFromApp();

   // K comes from the smartphone to unlock the mechanism
 	 if (buf == 'E')
 	 	// if K, goes to UnlockFromRent
   	stateflag = 7;
   else
   	//Back to this function
   	stateflag = 6;	
}
void EndTrip(){
	// GPS Read Location

	// GSM Send Location

	// Change state flag
	stateflag = 8;
}
void LockFromEndTrip(){

  // Motor movement to lock the mechanism
  // motor->toggleDirection();

  motor->run();

  // While does not have an HIGH input
  while(digitalRead(SENSOR_LOCK)); // Check sensors
  
  motor->stop();
   
  // Changing flag state
  stateflag = 2; //BikeStop
  
  motor->toggleDirection();
}

void loop() {
  // Simulating a state machine

  if(!(stateflag >=0 && stateflag < 10)){
  	Serial.println("Error - stateflag");
    while(1);
  }


  switch(stateflag){
    
    case 0 :
    Unavailable();
    break;    
   
    case 1 :
    LockFromUnavailable();
    break;
    
    case 2 :
    BikeStop();
    break;

    case 3 : 
    UnlockFromOwner();
    break;

    case 4 :
    BikeWaitRenting();
    break;

    case 5 :
    UnlockFromRent();
    break;

    case 6 :
    BikeRented();
    break;
  
    case 7:
    EndTrip();
    break;

    case 8:
    LockFromEndTrip();
    break;

    default:
    Serial.println("stateflag miss value");    
    }

}
