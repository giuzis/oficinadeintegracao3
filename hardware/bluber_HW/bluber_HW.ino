#include "bluber_modules.h"

/* Global vars */
uint8_t stateflag = 0;
bool enable_con = false;

float lat, lon, old_lat, old_lon;
// -> Gyro vars
bool send2server;
bool flag_gyro;

/* DC Motor Module */
Motor* motor;

/* GSM Module */
SoftwareSerial GSMSerial(GSM_TX, GSM_RX); //SIM800L Tx & Rx is connected to Arduino #3 & #2

/* GPS Module */
TinyGPS gps;
SoftwareSerial GPSSerial(GPS_RX, GPS_TX);

/* Bluetooth Module */
SoftwareSerial BTSerial(BT_RX,BT_TX);

/* Gyro Module */
//Adress of I2C 
const int MPU=0x68;  

void BluetoothInterrupt(){
  // Enable the connection flag
  enable_con = true;    
};

void setup() {
	/* Sensors */
	pinMode(A0, OUTPUT);
	pinMode(A1, INPUT);
	pinMode(A2, OUTPUT);
	pinMode(A3, INPUT);
	digitalWrite(A0, HIGH);
	digitalWrite(A2, HIGH);

	/* Serial Monitor */
	Serial.begin(9600);

  /* DC Motor Module */
  motor = new Motor();
  motor->setPins(3, 5, 4); // step, enable, reset
  motor->stop();
  motor->setSpeed(100);

	/* Bluetooth Module */
  BTSerial.begin(9600);
  BluetoothInterrupt();// sends a menu to the remote
  attachInterrupt(2, BluetoothInterrupt, RISING);// attach BT STATE pin to PIN 3, this provides a user menu on connection

	/* Gyroscope Module */
  Wire.begin();                 //Start I2C
  Wire.beginTransmission(MPU);  //Start TX to MPU
  Wire.write(0x6B);
  Wire.write(0); 
  Wire.endTransmission(true);    

  /* GPS Module */
  GPSSerial.begin(GPS_Serial_Baud);

  /* GSM Module */
  //Begin serial communication with Arduino and SIM800L
  GSMSerial.begin(GSM_Serial_Baud);

  /* Buzzer Module */
}

/* Start up and tests functions */
void startUp(){

}

/* General System Functions */
void Unavailable(){

	// While Bluetooth doesn't receive a connection
	while(!enable_con);
  
  // Read BT Data 
  while( BTSerial.available() > 0 ){
   buf = BTSerial.read();
   //Char to Lock the mechanism
   //Serial.println(buf);
   if (buf == 'L')
   	// Change state to LockFromUnavailable
    stateflag = 1;
  
  //More than 10 seconds in the Loop, break the connection
  delay(100);
  watchDogCounter++;
  if(watchDogCounter > 100){
  	enable_con = false;
    break;
  	}
	}   
}
void LockFromUnavailable(){

  // Motor movement to lock the mechanism
  /* ------- Check the right side -------- */
  // motor->toggleDirection();

  motor->run();

  // While does not have an HIGH input
  while(!digitalRead(A1)); // Check sensors
  
  motor->stop();
   
  // Changing flag state
  stateflag = 2; //BikeStop
}
void BikeStop(){

	// GPS Read location
  if (GPS.encode(SerialGPS.read()) == true) {
  	GPS.f_get_position(&lat, &lon);
  	if(old_lat != lat || old_lon != lon){
  		old_lat = lat;
  		old_lon = lon;
  		send2server = true;
  	}
  }

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

  // Read BT Data 
  while (BTSerial.available() > 0 ){
   buf = BTSerial.read();
   //Char to Lock the mechanism
   //Serial.println(buf);
 	 if (buf == 'R')
 	 // Change state to LockFromUnavailable
   	stateflag = 4;	
   else
   if( buf == 'O')
 		stateflag = 3;

  //More than 5 seconds in the Loop, break the connection
  delay(100);
  watchDogCounter++;
  if(watchDogCounter > 50){
    break;
  	}
	}   
}
void UnlockFromOwner(){
  // Motor movement to lock the mechanism
  /* ------- Check the right side -------- */
  // motor->toggleDirection();

  motor->run();

  // While does not have an HIGH input
  while(!digitalRead(A1)); // Check sensors
  
  motor->stop();
   
  // Changing flag state
  stateflag = 0; //Unavailable
}
void BikeWaitRenting(){
  // Read BT Data 
  while (BTSerial.available() > 0 ){
	 	//More than 5 seconds in the Loop, break the connection
  	delay(100);
  	watchDogCounter++;
  	if(watchDogCounter > 50)
    	break;
	}

   buf = BTSerial.read();

   // K comes from the smartphone to unlock the mechanism
 	 if (buf == 'K')
 	 	// if K, goes to UnlockFromRent
   	stateflag = 5;
   else
   	//Back to this function
   	stateflag = 4;	
}
void UnlockFromRent(){
	// Motor movement to lock the mechanism
  /* ------- Check the right side -------- */
  // motor->toggleDirection();

  motor->run();

  // While does not have an HIGH input
  while(!digitalRead(A1)); // Check sensors
  
  motor->stop();
   
  // Changing flag state
  stateflag = 6; //BikeRented
}
void BikeRented(){
	// GPS Read Location

	// GPS Send to the server

	// Bluetooth read data
	 buf = BTSerial.read();

   // K comes from the smartphone to unlock the mechanism
 	 if (buf == 'S')
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
  /* ------- Check the right side -------- */
  // motor->toggleDirection();

  motor->run();

  // While does not have an HIGH input
  while(!digitalRead(A1)); // Check sensors
  
  motor->stop();
   
  // Changing flag state
  stateflag = 2; //BikeStop
}

void loop() {

  // Simulating a state machine

  if(!(stateflag >=0 && stateflag < 10))
    while(1);
  

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
    while(1);
    
    }

}
