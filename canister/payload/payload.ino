// VTCanSat
// payload.ino
// Main program for CanSat 2018 competition payload
// Last Modified by Sky Hoffert
// Last Modified on May 28, 2018

#include <XBee.h>

// constants ----------------------------------------------------------------------------------------------------------------
enum STATE { STARTUP, FLIGHT, LAND };
bool has_sd_reader = false;

// global variables ---------------------------------------------------------------------------------------------------------
long time_startup    = 0;
STATE state = STARTUP;
XBee xbee = XBee();
float telem_temperature = 0.0;
float telem_pressure    = 0.0;
// TODO -- add more telemetry fields

// util functions -----------------------------------------------------------------------------------------------------------


void setup() {
  if (has_sd_reader == true){
    // TODO -- startup routine
  } else {
    state = STARTUP;
    time_startup = millis();
  }
}

void loop() {
  if (state == STARTUP){
    return;
  } else if (state == FLIGHT){
    time_now = millis();
    
    // 1 Hz loop
    if (time_now - time_last > 1000){
      // TODO -- main program code
      
      time_last = millis();
    }
    
    return;
  } else if (state == LAND){
    // TODO -- landed code
    return;
  }
}
