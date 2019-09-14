#include "A4988_DC.h"

// ================================================================
// ===            A4988_DC CLASS EXAMPLE TEST CODE              ===
// ================================================================

Motor* motor;

void setup(){
  motor = new Motor();
  motor->setPins(3, 5, 4); // step, enable, reset
  motor->stop();
  motor->setSpeed(100);
}

void loop(){
  motor->toggleDirection();
  motor->run();
  delay(1000);
  
  motor->stop();
  delay(5000);  
}
