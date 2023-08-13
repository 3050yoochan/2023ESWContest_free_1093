import serial
from sklearn.neighbors import KNeighborsClassifier
import time

TrufflebotSerial = serial.Serial('/dev/ttyUSB0', 9600, timeout=1)
ControllerSerial = serial.Serial(port = "/dev/ttyUSB1", baudrate = 9600, bytesize = serial.EIGHTBITS, parity = serial.PARITY_NONE, timeout = 1)

Classifier_MQ9_MQ2 = KNeighborsClassifier()
Classifier_MQ3_MQ7 = KNeighborsClassifier()
Classifier_Pressure_Temperature = KNeighborsClassifier()

ndrug_MQ9 = [103,115,102]
ndrug_MQ2 = [110,112,104]
ndrug_MQ3 = [294,295,296]
ndrug_MQ7 = [121,123,125]
ndrug_Pressure = [994.45,998.62,997.53]
ndrug_Temperature = [29.56, 29.88, 34.25]

drug_MQ9 = [45,15,32]
drug_MQ2 = [10,25,45]
drug_MQ3 = [45,12,33]
drug_MQ7 = [66,42,53]
drug_Pressure = [88.27, 88.64, 95.45]
drug_Temperature = [50.45, 88.25, 121.45]

dnd_MQ9 = drug_MQ9 + ndrug_MQ9
dnd_MQ2 = drug_MQ2 + ndrug_MQ2
dnd_MQ3 = drug_MQ3 + ndrug_MQ3
dnd_MQ7 = drug_MQ7 + ndrug_MQ7
dnd_Pressure = drug_Pressure + ndrug_Pressure
dnd_Temperature = drug_Temperature + ndrug_Temperature

drug_MQ9MQ2_data = [[n,t] for n,t in zip(dnd_MQ9, dnd_MQ2)]
drug_MQ3MQ7_data = [[n,t] for n,t in zip(dnd_MQ3, dnd_MQ7)]
drug_PressTemp_data = [[n,t] for n,t in zip(dnd_Pressure, dnd_Temperature)]
drug_all_target = [1] * 3 + [0] * 3

Classifier_MQ9_MQ2.fit(drug_MQ9MQ2_data, drug_all_target)
Classifier_MQ3_MQ7.fit(drug_MQ3MQ7_data, drug_all_target)
Classifier_Pressure_Temperature.fit(drug_PressTemp_data, drug_all_target)

if __name__ == '__main__':
    
    TrufflebotSerial.flush()
    
    while True:
        if TrufflebotSerial.in_waiting > 0:
            line = TrufflebotSerial.readline().decode('utf-8').rstrip()
            print(line)
            MQ9,MQ2,MQ3,MQ7,Pressure,Temperature = line.split()
            MQ9 = int(MQ9)
            MQ2 = int(MQ2)
            MQ3 = int(MQ3)
            MQ7 = int(MQ7)
            predicted_value = Classifier_MQ3_MQ7.predict([[MQ3,MQ7]])
            print(predicted_value)
            
            if predicted_value == 1:
                messageToController = "1"
                ControllerSerial.write(messageToController.encode())
                
            
            
            
