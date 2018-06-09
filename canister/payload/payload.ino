// VTCanSat
// payload.ino
// Main program for CanSat 2018 competition payload
// Last Modified by Sky Hoffert
// Last Modified on June 9, 2018

#include <SPI.h>
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BME280.h>
#include <Adafruit_LSM303.h>
#include <Adafruit_LSM303_U.h>
#include <Adafruit_GPS.h>
#include <SoftwareSerial.h>
#include <Servo.h>

#define gpsrx 7
#define gpstx 8

SoftwareSerial gps =  SoftwareSerial(gpsrx, gpstx);
Adafruit_GPS GPS(&gps);

//Adafruit_BME280 bme; // I2C
/* Assign a unique ID to this sensor at the same time */
Adafruit_LSM303_Accel_Unified accel = Adafruit_LSM303_Accel_Unified(54321);

Servo servo_deploy;
Servo servo_detach;

#define SEALEVELPRESSURE_HPA (1013.25)

// constants ----------------------------------------------------------------------------------------------------------------
enum STATE { STARTUP, FLIGHT, LAND };
bool has_sd_reader = false;
float THRESH_ACCEL = 5;

// global variables ---------------------------------------------------------------------------------------------------------
long time_startup    = 0;
STATE state = STARTUP;
int teamid       = 6290;
long time_mission = 0;
long time_now     = 0;
long time_last    = 0;
long time_ejected = 0;
int packet_count = 0;
float telem_altitude    = 0.0;
float telem_temperature = 0.0;
float telem_pressure    = 0.0;
float telem_voltage     = 0.0;
float telem_gpstime     = 0.0;
float telem_gpslat      = 0.0;
float telem_gpslon      = 0.0;
float telem_gpsalt      = 0.0;
float telem_gpssats     = 0;
float telem_tilt_x      = 0.0;
float telem_tilt_y      = 0.0;
float telem_tilt_z      = 0.0;
float last_accels[3];
bool ejected = false;

// util functions -----------------------------------------------------------------------------------------------------------

// main functions -----------------------------------------------------------------------------------------------------------
void setup() {
  if (has_sd_reader == true){
    // TODO -- startup routine
  } else {
    state = FLIGHT;
    time_startup = millis();
  }
  
  last_accels[2] = 0;
  last_accels[1] = 0;
  last_accels[0] = 0;
  
  // serial output for XBee
  Serial.begin(9600);
  
  // gps
  GPS.begin(9600);
  GPS.sendCommand(PMTK_SET_NMEA_OUTPUT_RMCGGA);
  GPS.sendCommand(PMTK_SET_NMEA_UPDATE_1HZ);
  GPS.sendCommand(PGCMD_ANTENNA);
  
  // init sensors
  accel.begin();
  
  /*
  // servos
  servo_deploy.attach(6);
  servo_detach.attach(5);
  */
  
  // LED Status pin
  pinMode(13, OUTPUT);
}

void loop() {
  if (state == STARTUP){
    return;
  } else if (state == FLIGHT){
    time_now = millis();
    
    // 1 Hz loop
    if (time_now - time_last > 1000){
      // get the mission time
      time_mission = ((int) (time_now - time_startup)/1000);
      int i_state = 1;
      digitalWrite(13, HIGH);
      
      // sample sensors
      //telem_altitude = bme.readAltitude(SEALEVELPRESSURE_HPA);
      
      /* Get a new sensor event */
      sensors_event_t event;
      accel.getEvent(&event);
      telem_tilt_x = event.acceleration.x;
      telem_tilt_y = event.acceleration.y;
      telem_tilt_z = event.acceleration.z;
      float abs_accel = sqrt(pow(telem_tilt_x, 2) + pow(telem_tilt_y, 2) + pow(telem_tilt_z, 2));
      char c = GPS.read();
      if (GPS.fix){
        telem_gpslat  = GPS.latitudeDegrees;
        telem_gpslon  = GPS.longitudeDegrees;
        telem_gpssats = (int) GPS.satellites;
        telem_gpsalt  = GPS.altitude;
        telem_gpstime = GPS.minute;
      }
      
      if (!ejected && last_accels[2] > THRESH_ACCEL && last_accels[1] > THRESH_ACCEL && last_accels[0] > THRESH_ACCEL){
        ejected = true;
        time_ejected = time_now;
      }
      
      last_accels[2] = last_accels[1];
      last_accels[1] = last_accels[0];
      last_accels[0] = abs_accel;
      
      /*
      if (ejected){
        if (time_now - time_ejected > 6500){
          servo_deploy.write(0);
        }
        if (time_now - time_ejected > 10000){
          servo_detach.write(0);
          ejected = false;
        }
      }
      */
      
      // print telemetry to the serial pins (XBee)
      Serial.print(teamid);
      Serial.print(',');
      Serial.print(time_mission);
      Serial.print(',');
      Serial.print(packet_count);
      Serial.print(',');
      Serial.print(telem_altitude);
      Serial.print(',');
      Serial.print(telem_pressure);
      Serial.print(',');
      Serial.print(telem_temperature);
      Serial.print(',');
      Serial.print(telem_voltage);
      Serial.print(',');
      Serial.print(telem_gpstime);
      Serial.print(',');
      Serial.print(telem_gpslat);
      Serial.print(',');
      Serial.print(telem_gpslon);
      Serial.print(',');
      Serial.print(telem_gpsalt);
      Serial.print(',');
      Serial.print(telem_gpssats);
      Serial.print(',');
      Serial.print(telem_tilt_x);
      Serial.print(',');
      Serial.print(telem_tilt_y);
      Serial.print(',');
      Serial.print(telem_tilt_z);
      Serial.print(',');
      Serial.print(i_state);
      Serial.print('\n');
      digitalWrite(13, LOW);

      // save the previous time we sent a message
      time_last = millis();
      // increment packet count for next message
      packet_count += 1;
    }
    
    return;
  } else if (state == LAND){
    // TODO -- landed code
    return;
  }
}
