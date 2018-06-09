% Owner:        VT CanSat
% File:         ReceiveData.m
% Description:  This script receives data from the xbee radio
%               over the serial UART port and saves to a .csv
% Modified By:  Sky Hoffert
% LastModified: 6/8/2018

% filename
filename = 'telemetry.csv'
com_port = 'COM6'

% clear out the old file
fout = fopen(filename, 'w');
fclose(fout);
clear fout

% close the old serial connection if it is open already
if exist('serialCon', 'var')
    fclose(serialCon);
    delete(serialCon);
    clear serialCon;
end

% build the serial connection
serialCon = serial(com_port)
set(serialCon, 'BaudRate', 9600);
set(serialCon, 'Parity', 'none');
set(serialCon, 'DataBits', 8);
set(serialCon, 'StopBit', 1);
set(serialCon, 'Timeout', 1.5);
set(serialCon, 'FlowControl', 'none');

% try to open the connection, if not, exit
% NOTE: this must be closed after the program is halted
%       the procedure to close can be found at the bottom of the file
try
    fopen(serialCon);
catch
    fprintf('Could not connect to XBee on ')
    fprintf(com_port)
    fprintf('\n')
    return
end

% the bool for if the program is running
isRunning = true;
% in 2018, we have 16 fields
data_matrix_empty = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
data_matrix = data_matrix_empty;

% main data taking loop
while isRunning
    % get the data from the UART connection
    data = fscanf(serialCon)
    if ~isempty(data)
        % split the data by ',' character
        data_matrix = strsplit(data);
    else
        data_matrix = data_matrix_empty;
    end
    
    % append data to the save file
    dlmwrite(filename, data_matrix, 'delimiter', ',', '-append');
    
    % update displays
    disp_data = csvread(filename);
    mission_time = disp_data(:,2);
    
    for i = 1:16
        figure(i);
        plot(mission_time, disp_data(:,i));
    end
end

% close the connection for future use
% NOTE: this close step is very important for stopping future connections
%       remember to close the connection after each run of the program
fclose(serialCon);
delete(serialCon);
clear serialCon;