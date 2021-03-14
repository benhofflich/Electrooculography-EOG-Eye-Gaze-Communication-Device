int sensorValueH=0;
int sensorValueV=0;
float voltageH;
float voltageV;
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}
void loop() {
  // read the input on analog pin 0:
  sensorValueH = analogRead(A0);
  sensorValueV = analogRead(A1);
  // Convert the analog reading (which goes from 0 - 1023)
  // to a voltage (0 - 5V):
  voltageH = sensorValueH * (5.0 / 1023.0);
  voltageV = sensorValueV * (5.0 / 1023.0);
  //When doing floating point arithmetic, be sure and include .0 after
  // the number to be clear that you are using a float not an integer. 
  // If you don’t, the numbers may be rounded off to integers and 
  // can produce strange results.
  //
  // print out the value you read:
  Serial.print("Horizontal: "); Serial.print(voltageH); Serial.println(" ");
  Serial.print("Vertical: "); Serial.print(voltageV); Serial.println(" ");
  delay(1);
}
