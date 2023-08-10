#include <OneWire.h>
#include <DS18B20.h>
#include <MS5611.h>

MS5611 MS5611 (0x77); //기압센

int temperatureSensorLocation = 2;

DS18B20 temperatureSensor(temperatureSensorLocation);

int MQ9gasSensorPin = A0;
int MQ2gasSensorPin = A1;
int MQ3gasSensorPin = A2;
int MQ7gasSensorPin = A3;

int MQ9gasSensorData;
int MQ2gasSensorData;
int MQ3gasSensorData;
int MQ7gasSensorData;
float MS5611SensorData;
float tempSensorData;

void setup()
{
  Serial.begin(9600);

  if(!MS5611.begin())
  {
    Serial.println("chkPS");
  }
}

void loop()
{
  MS5611.read();
  MQ9gasSensorData = analogRead(MQ9gasSensorPin);
  MQ2gasSensorData = analogRead(MQ2gasSensorPin);
  MQ3gasSensorData = analogRead(MQ3gasSensorPin);
  MQ7gasSensorData = analogRead(MQ7gasSensorPin);
  MS5611SensorData = MS5611.getPressure();
  tempSensorData = temperatureSensor.getTempC();

  Serial.print(MQ9gasSensorData);
  Serial.print(" ");
  Serial.print(MQ2gasSensorData);
  Serial.print(" ");
  Serial.print(MQ3gasSensorData);
  Serial.print(" ");
  Serial.print(MQ7gasSensorData);
  Serial.print(" ");
  Serial.print(MS5611SensorData);
  Serial.print(" ");
  Serial.println(tempSensorData);
}
