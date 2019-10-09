#include "bluber_HW.h"

/* Global vars */
uint8_t stateflag = 0;

/* DC Motor Module */
Motor* motor;

void setup() {
	/* Serial Monitor */
	Serial.begin(9600);

  /* DC Motor Module */
  motor = new Motor();
  motor->setPins(3, 5, 4); // step, enable, reset
  motor->stop();
  motor->setSpeed(100);

	/* Bluetooth Module */
  BluetoothInterrupt();// sends a menu to the remote
  attachInterrupt(2, BluetoothInterrupt, CHANGE);// attach BT STATE pin to PIN 3, this provides a user menu on connection

	/* Gyroscope Module */


  /* GPS Module */

  /* GSM Module */




}

/* General System Functions */

void Unavailable(){}
void LockFromUnavailable(){

  // Changing flag state
  stateflag = 1; //locking
  
  // Motor movement to lock the mechanism
  /* ------- Check the right side -------- */
  // motor->toggleDirection();

  motor->run();

  //while(button != 0); // Check sensors
  
  motor->stop();
   
  // Changing flag state
  stateflag = 2; //available
}
void BikeStop(){}
void UnlockFromOwner(){}
void BikeWaitRenting(){}
void UnlockFromRent(){}
void BikeRented(){}
void EndTrip(){}
void LockFromEndTrip(){}

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
