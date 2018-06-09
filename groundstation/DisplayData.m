% Owner:        VT CanSat
% File:         DisplayData.m
% Description:  This script plots data logged by the Receive-
%               Data script to a .csv
% Modified By:  Sky Hoffert
% LastModified: 6/8/2018

% KEY:
% 1  - Team ID
% 2  - Mission Time
% 3  - Packet Count
% 4  - Altitude
% 5  - Pressure
% 6  - Temperature
% 7  - Voltage
% 8  - GPS Time
% 9  - GPS Lat
% 10 - GPS Lon
% 11 - GPS Alt
% 12 - GPS Sats
% 13 - Tilt X
% 14 - Tilt Y
% 15 - Tilt Z
% 16 - Software State

% filename
filename = 'telemetry.csv'
isRunning = 1;
sleep_time = 5;

while isRunning
    % read the file data with csvread
    data = csvread(filename);
    mission_time = data(:,2);
    
    for i = 1:16
        figure(i);
        plot(mission_time, data(:,i));
    end
    
    pause(sleep_time);
end

