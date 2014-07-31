
int MotorPin = 6; 

 
void setup() 
{ 
  Serial.begin(9600);

} 
 
 
void loop() 
{ 
 
   for(int motor_speed = 120 ; motor_speed <= 255; motor_speed ++)
   { 
     move_motor(motor_speed);                        
   } 
  

} 

void move_motor(int motor_speed)
{
        analogWrite(MotorPin, motor_speed); 
        Serial.println(motor_speed);        
        delay(500);    
}


