#include <SoftwareSerial.h>

int TouchSensor = 3;
int VibrationSensor = 4;

int blueLED = 9;
int greenLED = 10;

SoftwareSerial BluetoothSerial (6,7);

void setup() 
{
  pinMode(TouchSensor, INPUT);
  pinMode(blueLED, OUTPUT);
  pinMode(greenLED, OUTPUT);
  Serial.begin(9600);
  BluetoothSerial.begin(9600);
}

void loop() 
{
  char messageFromRaspberryPi = Serial.read();

  if(messageFromRaspberryPi == '1')
  {
    analogWrite(greenLED, HIGH);
    for(int i=1;i<=5;i++)
    {
        analogWrite(VibrationSensor, 300);
        delay(100);
        analogWrite(VibrationSensor, 0);
        delay(100);
        analogWrite(VibrationSensor, 300);
        delay(100);
        analogWrite(VibrationSensor, 0);
        delay(100);
        delay(1000);
    }
    analogWrite(greenLED, LOW);
    BluetoothSerial.write("1");
  }

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
