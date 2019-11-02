#include "A4988_DC.h"

// ================================================================
// ===            A4988_DC CLASS EXAMPLE TEST CODE              ===
// ================================================================

Motor* motor;

void setup(){
  Serial.begin(9600);
  motor = new Motor();
  motor->setPins(49, 51, 53); // step, enable, reset
  motor->stop();
  motor->setSpeed(500);
}

void loop(){
  Serial.println("oi");
  motor->toggleDirection();
  motor->run();
  delay(500);
  
  motor->stop();
  delay(1000);

}
