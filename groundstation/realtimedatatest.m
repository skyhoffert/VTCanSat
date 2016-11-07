% This matlab file is to determine if real time plotting
% is possible with the matlab software
clear, clc

% variables
Filename_Pressure = 'pressure.txt';
Filename_GPS = 'gps.txt';
Filename_Current = 'current.txt';

% create usable time array
for i = 1:100000
    Time(i) = i;
end

% load the data a first time
Data_Pressure = importdata(Filename_Pressure);
Data_GPS = importdata(Filename_GPS);
Data_Current = importdata(Filename_Current);

% create plots
PRES = plot(Time(1:length(Data_Pressure)), Data_Pressure);
title('Pressure Data');
xlabel('Time (s)');
ylabel('Pressure (kPa)');
figure();
GPS = plot(Time(1:length(Data_GPS)), Data_GPS);
figure();
CURRENT = plot(Time(1:length(Data_Current)), Data_Current);
title('Current Data');
xlabel('Time (s)');
ylabel('Current (mA)');

% keep checking for changes in file
while (1)
    Data_Pressure = importdata(Filename_Pressure);
    Data_GPS = importdata(Filename_GPS);
    Data_Current = importdata(Filename_Current);
    set(PRES, 'XData', Time(1:length(Data_Pressure)), 'YData', Data_Pressure);
    %set(GPS, 'XData', Time(1:length(Data_GPS)), 'YData', Data_GPS);
    set(CURRENT, 'XData', Time(1:length(Data_Current)), 'YData', Data_Current);
    %DisplayData(Data_Pressure);
    %figure();
    %DisplayData(Database_GPS);
    pause(1);
end