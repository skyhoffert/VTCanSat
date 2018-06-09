#include <SoftwareSerial.h>

#define rxPin 0
#define txPin 1

SoftwareSerial xbee =  SoftwareSerial(rxPin, txPin);
void setup(){
  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);
  xbee.begin(9600);
}

void loop(){
  xbee.print('CommTest');
  delay(500);
}
