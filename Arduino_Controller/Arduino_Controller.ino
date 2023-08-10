int TouchSensor = 3;
int VibrationSensor = 4;

int blueLED = 9;
int greenLED = 10;

void setup() 
{
  pinMode(TouchSensor, INPUT);
  pinMode(blueLED, OUTPUT);
  pinMode(greenLED, OUTPUT);
  Serial.begin(9600);
}

void loop() 
{
  analogWrite(blueLED, HIGH);
  analogWrite(greenLED, LOW);
  int TouchSensorValue = digitalRead(TouchSensor);
  Serial.println(TouchSensorValue);

  if(TouchSensorValue == 0)
  {
    analogWrite(VibrationSensor,300);
    analogWrite(greenLED, HIGH);
    delay(100);
    analogWrite(VibrationSensor,0);
    analogWrite(greenLED, LOW);
  }
  
  delay(20);
}
