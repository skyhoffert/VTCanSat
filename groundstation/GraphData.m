% Owner:        VT CanSat
% File:         GraphData.m
% Description:  This script graphs the data saved by ReceiveData.m in
%               real time
% Modified By:  Sky Hoffert
% LastModified: 11/6/2016

% variables
Filename_csv = 'output.csv';
isRunning = true;
sleepTime = 1;

% create usable time array
for i = 1:100000
    Time(i) = i;
end

% read in the data
Data_Matrix = importdata(Filename_csv);

% extract the data into separate vectors
% NOTE: the location of each column should be changed
Data_Alt = Data_Matrix(:,4)';

% create plots
ALT = plot(Time(1:length(Data_Alt)), Data_Alt);
title('Altitude Data');
xlabel('Time (s)');
ylabel('Altitude (m)');
figure();

% main program loop
while isRunning
    % read in the data
    Data_Matrix = importdata(Filename_csv);

    % extract the data into a matrix
    % NOTE: the location of each column should be changed
    Data_Alt = Data_Matrix(:,4)';
    
    % set the new altitude data
    set(PRES, 'XData', Time(1:length(Data_Pressure)), 'YData', Data_Pressure);
    
    % pause
    pause(sleepTime);
end