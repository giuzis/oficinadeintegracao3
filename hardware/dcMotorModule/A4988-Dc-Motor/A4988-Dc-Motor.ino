#include "A4988_DC.h"

// ================================================================
// ===            A4988_DC CLASS EXAMPLE TEST CODE              ===
// ================================================================

Motor* motor;

void setup(){
  motor = new Motor();
  motor->setPins(12, 11, 10); // step, enable, reset
  motor->stop();
  motor->setSpeed(50);
}

void loop(){
  motor->toggleDirection();
  motor->run();
  delay(500);
  
  motor->stop();
  delay(1000);

}
