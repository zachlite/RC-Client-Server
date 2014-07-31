#include <Servo.h>

Servo steering_servo;  // create servo object to control a servo 
               

int pos = 0;    // variable to store the servo position 
int offset = 55; 
 
 
void setup() 
{ 

  Serial.begin(9600);
  steering_servo.attach(9);  // attaches the servo on pin 9 to the servo object 

} 
 
 
void loop() 
{ 

  cycle_steering();

} 


void cycle_steering()
{
   
   steering_servo.write(0 + offset);
   delay(2000);
   
   steering_servo.write(90);
   delay(2000);
   
   steering_servo.write(180 - offset);
   delay(2000);
}
