#include <SoftwareSerial.h>
#define rxPin 2
#define txPin 3
#define ledPin 13
SoftwareSerial xbee =  SoftwareSerial(rxPin, txPin);
void setup(){
  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);
  xbee.begin(9600);
}

void loop(){
  xbee.print('S');
  delay(100);
  xbee.print('K');
  delay(100);
  xbee.print('Y');
  delay(100);
  xbee.print('S');
  delay(100);
  xbee.print('U');
  delay(100);
  xbee.print('C');
  delay(100);
  xbee.print('K');
  delay(100);
  xbee.print('S');
  delay(100);
}
