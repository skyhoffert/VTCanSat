// VTCanSat
// payload.ino
// Main program for CanSat 2018 competition payload
// Last Modified by Sky Hoffert
// Last Modified on May 28, 2018



// constants ----------------------------------------------------------------------------------------------------------------
enum STATE { STARTUP, FLIGHT, LAND };
bool has_sd_reader = false;

// global variables ---------------------------------------------------------------------------------------------------------
long time_startup    = 0;
STATE state = STARTUP;
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
    // TODO -- main flight code
    return;
  } else if (state == LAND){
    // TODO -- landed code
    return;
  }
}
