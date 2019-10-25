/* Arduino tutorial - Passive Buzzer Module 
   More info and circuit: http://www.ardumotive.com
   Dev: Giannis Vasilakis // Date: 12/11/2017  */
   
#define buzzer 13
void setup ()
{
  pinMode (buzzer, OUTPUT) ;
}
void loop ()
{
  unsigned char i, j ;
  while (1)
  {
    for (i = 0; i <80; i++) // When a frequency sound
    {
      digitalWrite (buzzer, HIGH) ; //send tone
      delay (1) ;
      digitalWrite (buzzer, LOW) ; //no tone
      delay (1) ;
    }
    for (i = 0; i <100; i++) 
    {
      digitalWrite (buzzer, HIGH) ;
      delay (2) ;
      digitalWrite (buzzer, LOW) ;
      delay (2) ;
    }
  }
}
