#include "bluber_modules.h"

/* Global vars */
uint8_t stateflag = 2;              // variavel
bool enable_con = false;
float lat, lon, old_lat, old_lon;

// -> Gyro vars
bool flag_gyro = true;

/* DC Motor Module */
Motor* motor;

/* GSM Module */
SoftwareSerial GSMSerial(6, 7); //SIM800L Tx & Rx is connected to Arduino #3 & #2
String gsmcheck;
bool send2server = true;

void PrepareGSM(){
  GSMSerial.println("AT+SAPBR=1,1");
  updateSerial();
  GSMSerial.println("AT+HTTPINIT"); 
  updateSerial();
  GSMSerial.println("AT+HTTPSSL=1");
  updateSerial();
  GSMSerial.println("AT+HTTPPARA=\"CID\",1");
  updateSerial();
};

void EndGSM(){
    GSMSerial.println("AT+HTTPTERM");
    updateSerial(); 
    GSMSerial.println("AT+SAPBR=0,1");
    updateSerial();
};

void SendAlarm2Server(){
  GSMSerial.println("AT+HTTPPARA=\"URL\",\"bluberstg.firebaseio.com/bike1/alarm.json\"");
  updateSerial();
  GSMSerial.println("AT+HTTPDATA=8,1000");
  updateSerial();
  GSMSerial.println("\"active\"");
  updateSerial();
  GSMSerial.println("AT+HTTPACTION=1");
  updateSerial();
  while(GSMSerial.available() == 0);
  updateSerial();
};

void SendLat2Server(float GPS_lat){
  GSMSerial.println("AT+HTTPPARA=\"URL\",\"bluberstg.firebaseio.com/bike1/latitude.json\"");
  updateSerial();
  GSMSerial.println("AT+HTTPDATA=10,1000");
  updateSerial();
  GSMSerial.println(GPS_lat);
  updateSerial();
  GSMSerial.println("AT+HTTPACTION=1");
  updateSerial();
  while(GSMSerial.available() == 0);
  updateSerial();
}; 

void SendLong2Server(float GPS_long){
  GSMSerial.println("AT+HTTPPARA=\"URL\",\"bluberstg.firebaseio.com/bike1/longitude.json\"");
  updateSerial();
  GSMSerial.println("AT+HTTPDATA=10,1000");
  updateSerial();
  GSMSerial.println(GPS_long);
  updateSerial();
  GSMSerial.println("AT+HTTPACTION=1");
  updateSerial();
  while(GSMSerial.available() == 0);
  updateSerial();
}; 

/* GPS Module */
TinyGPS GPS;
SoftwareSerial GPSSerial(GPS_RX, GPS_TX);

/* Bluetooth Module */
SoftwareSerial BTSerial(4,5);
//int led =13;
char buf;

void verifyCharFromApp(){
  
  //Serial.println(BTSerial.available());
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
byte speakerState;                                       //gets set before speaker is called

int AcX,AcY,AcZ;                                         //accelerometer values
int OldAcX,OldAcY,OldAcZ = 0;                            //old accelerometer values from last time it was checked
boolean moved = false;                                   //to track if it is moved
boolean isStolen = false;                                //to track if the device has been stolen (exceeds the max movement time and threshold)

unsigned long previousMPUmillis = 0;                     //timer for checking the accelerometer
unsigned long endOfSetupMillis;                          //to track when the setup has ended (user has successfully put in the code to arm the device)
unsigned long previousSerialMillis;                      //for debugging or printing to the serial.  Gets initialized to zero when begin Serial Communication.  Unecessary for sketch to work.

// --ACCELEROMETER--
const int AcSensitivity = 1400;            //high enough so that little bumps dont trigger it, but movement does.  Will need to experiment.
const int maxMovementTime = 1000;          //number of milliseconds of movement allowed before the alarm goes off.  5000 = 5 seconds.
const int maxStillnessThreshold = 20;      // % threshold of stillness above which the thing is moving
const int readMPUinterval = 250;           //number of milliseconds between checks of the accelerometer
const int upfrontSettleTime = 1000;       //number of milliseconds before starts checking accelermeter
const int maxMovementTimeArrayDifference = maxMovementTime / readMPUinterval;    // number of array entries necessary for their to be movement
const int movedRecordLength = maxMovementTimeArrayDifference  * 2;               //need to keep more than just the maxMovementTime otherwise if the first or the last in the array is 'not moved' then sketch will consider it to be not moved.
boolean movedRecord[movedRecordLength];    

 /* Buzzer Module */
const int speakerPin = 13;                                  //suggest PWM pin, depending on your speaker/alarm
//bool enable_buzzer = false;

void BluetoothInterrupt(){  
  switch (digitalRead(2)) {// watch the interrupt pin (UNO)
  case LOW:// lost connection
//     digitalWrite(led,LOW);// shows an external LED for connection status
     enable_con = false;
     Serial.println("Desconectado");
     break;
  case HIGH:// got connection
//     digitalWrite(led,HIGH);
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
//  BTSerial.begin(9600);
 
  BluetoothInterrupt();// sends a menu to the remote
  attachInterrupt(digitalPinToInterrupt(2), BluetoothInterrupt, CHANGE);
   
	/* Gyroscope Module */
  Wire.begin();                 //Start I2C
  Wire.beginTransmission(MPU);  //Start TX to MPU
  Wire.write(0x6B);
  Wire.write(0); 
  Wire.endTransmission(true);
  beginMPUcommunications();                              //start communicating with the accelerometer
  initializeMovedRecord();    

  /* GPS Module */
//  GPSSerial.begin(GPS_Serial_Baud);

//  /* GSM Module */
//  //Begin serial communication with Arduino and SIM800L
  GSMSerial.begin(GSM_Serial_Baud);
  GSMSerial.println("AT"); //Once the handshake test is successful, it will back to OK
  updateSerial();
  GSMSerial.println("AT+SAPBR=3,1,\"APN\",\"tim\""); //Signal quality test, value range is 0-31 , 31 is the best
  updateSerial();  

//  /* Buzzer Module */
   pinMode(speakerPin, OUTPUT);
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

  // Get new timer for each round of the loop
  unsigned long currentMillis = millis();
  //Serial.println("Bikestop");

  float lat = -25.440843;
  float lon = -49.268730;

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
      // PrepareGSM
      PrepareGSM();
      // SendGSM
      SendLat2Server(lat);
      SendLong2Server(lon);
      // End GSM();
      EndGSM();
  }

  if(flag_gyro == true){

    // start reading the MPU on a regular basis (if outside of the upfront settle time) and then check to see if device has been stolen after each reading
    if (((currentMillis - previousMPUmillis) > readMPUinterval) && (isStolen == false) && (currentMillis > (endOfSetupMillis + upfrontSettleTime))){
      
      // read the MPU and process the data
      checkPositionChangeAndShiftRecord();
      printMovedRecord();                                                              
      isStolen = checkIfStolen();
      previousMPUmillis = currentMillis;     //reset timer
    } 

    // Send Alarm notification
    if (isStolen == true){
      Serial.println("ROBARO");      
      // PrepareGSM
      PrepareGSM();
      // SendGSM
      SendAlarm2Server();
      // End GSM();
      EndGSM();
      }
  }
      

  // Enable Buzzer
  // take action if stolen
  if (isStolen == true) {

    speakerState = true;
    flag_gyro = false;
    speakerPlayBuzzer(speakerState);                                               //see comment above about the speaker play function
  }

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
  
  // Owner unlocking means to shutoff the alarm - If Exists
  isStolen = false;
  flag_gyro = true;
  
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
// --Speaker Functions--

int _delay = 0;

void speakerPlayBuzzer(boolean isSpeakerOn) {
  if (isSpeakerOn == true) {

    if(_delay < 20){
      //Serial.println("BAIXO");
      tone(speakerPin,500);
        _delay++;
    }
    else if(_delay >= 20 && _delay  < 50){
      //Serial.println("ALTO");
      tone(speakerPin,800);
      _delay++;
    }
    else{
      _delay  = 0;
    } 
  }
  else //isSpeakerOn == false
  {
    digitalWrite(13,LOW);
    digitalWrite(speakerPin, LOW);
  } //end if isSpeakerOn
  
} //end speakerPlayBuzzer

//--Accelerometer functions--
void initializeMovedRecord() {                                                                  //PURPOSE: set the moved record at all false to begin with.
  for (int x = 0; x < movedRecordLength; x++) {
    movedRecord[x] = false;
  } //end for
} //end initializeMovedRecord

void beginMPUcommunications() {                                                                 //PURPOSE: begin communications with MPU accelerometer. Done once.
  Wire.begin();
  Wire.beginTransmission(MPU);
  Wire.write(0x6B);                                                                             // PWR_MGMT_1 register
  Wire.write(0);                                                                                // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);
} //end beginMPUcommunications

void readMPUrawvalues() {                                                                       //PURPOSE:  read the raw values from the accelerometer.
  Wire.beginTransmission(MPU);
  Wire.write(0x3B);  // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU,14,true);  // request a total of 14 registers
  AcX=Wire.read()<<8|Wire.read();  // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)     
  AcY=Wire.read()<<8|Wire.read();  // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
  AcZ=Wire.read()<<8|Wire.read();  // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
} //end readMPUrawvalues

void checkPositionChangeAndShiftRecord() {                                                      //PURPOSE: read the raw values from the accelerometer, check against the old values.  If there is movement above the sensitivity level, add 'true' to the movement record, if not, add 'false' to the movement record  
   readMPUrawvalues();
  //Check to see if it has moved and add to the move record
  if (abs(OldAcX - AcX) > AcSensitivity) { moved = true; }
  if (abs(OldAcY - AcY) > AcSensitivity) { moved = true; }
  if (abs(OldAcY - AcY) > AcSensitivity) { moved = true; }
  shiftMovedRecord(moved);                                                                      //add the moved value (either true or false) to the moved record
  
//  //turn on Status if moved
//  if (moved == true) {
//    analogWrite(statusLEDPin, movedLEDbrightness);
//  }
  
  //reset the values for next check
  OldAcX = AcX;
  OldAcY = AcY;
  OldAcZ = AcZ;
  moved = false;  
} //end checkPositionChangeAndShiftRecord

void shiftMovedRecord(boolean movedValue) {                                                    //PURPOSE: shifts the movedRecord one to the left, and then adds the value of the most recent moved record the right
  for (int x = 0; x < movedRecordLength; x++) {                                                //step through the movedRecord
    movedRecord[x] = movedRecord[x+1];                                                         //for each record spot, shift it to the left.  the first record gets lost.
    if (x == (movedRecordLength-1)) {                                                          //if the last spot, add the new record from the most recent record
      movedRecord [x] = movedValue;
    } //end if
  }//end for
} //end shiftMovedRecord

boolean checkIfStolen() {                                                                     //PURPOSE:  step through the moved record and see if the record meets the circumstances deemed to mean the at the device is stolen
  boolean stolenStatus = false; //assume it has not been stolen until it has been proven stolen
  
  //---------------First test:  is there movement more than 5 seconds apart
  int firstMoved = movedRecordLength -1;                                                       //initalize as the far end of where it will start
  int lastMoved = 0;                                                                           //initalize as the far end of where it will start
  boolean firstMovedSet = false; 
  boolean lastMovedSet = false;
  boolean movedEnoughTime = false;
  
  for (int x = 0; x < movedRecordLength; x++) {                                                // get first moved, starting from 0.  Note this will cycle through the whole record, even if it finds first moved early.  Okay but slightly inefficient.
    if (movedRecord[x] == true && firstMovedSet == false) {
      firstMoved = x;
      firstMovedSet = true;
    } //end if
  } //end for  

  for (int x = (movedRecordLength - 1); x >= 0; x--) {                                         // get last moved, starting from the end of the moved record.  Note this will cycle through the whole record, even if it finds last moved early.  Okay but slightly inefficient.
    if (movedRecord[x] == true && lastMovedSet == false) {
      lastMoved = x;
      lastMovedSet = true;
    } //end if
  } //end for 
 
  if ((lastMoved - firstMoved) > maxMovementTimeArrayDifference){
     movedEnoughTime = true;
  } 
  //-------------end First test -----------------------------------------

  //---------------Second test:  if there is movement over 5 seconds, is it more than the threshold

  if (movedEnoughTime == true){
    int trueCounter = 0;
    for (int x = firstMoved; x <= lastMoved; x++) {                                                //step through the movedRecord between the first moved and the last moved positions
      if (movedRecord[x] == true) {
        trueCounter++;                                                                             //count the number of trues in the section of movedRecord
      } //end if
    } //end for
    
    int movementPercent = map(trueCounter, 0, lastMoved - firstMoved + 1, 0, 100);                 //map the trueCounter amount out of the number of records being checked, to a 0 to 100 percentage.  This allows the use of interger math.
    if (movementPercent > maxStillnessThreshold) {
      stolenStatus = true;
    } //end greater than maxStillnessThreshold
    else {
      stolenStatus = false;
    } //end less than maxStillnessThreshold
  
  } //end-----------------Second test --------- if movement over difference in array

  return stolenStatus;
} //end checkIfStolen
//--------------------SERIAL COMMUNICATIONS --------------------------------------
//only for debugging.  Unnecessary for the sketch to run.
void printMovedRecord() {
  for (int x = 0; x < movedRecordLength; x++) {
    Serial.print(movedRecord[x]);
  } //end for
  Serial.println();
} //end initializeMovedRecord

void updateSerial()
{
  delay(750);
  while (Serial.available()) 
  {
    GSMSerial.write(Serial.read());//Forward what Serial received to Software Serial Port
  }
  while(GSMSerial.available()) 
  {
    Serial.write(GSMSerial.read());//Forward what Software Serial received to Serial Port
  }
}
