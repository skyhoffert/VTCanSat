% Owner:        VT CanSat
% File:         ReceiveData.m
% Description:  This script receives data from the xbee radio
%               over the serial UART port
% Modified By:  Sky Hoffert
% LastModified: 6/8/2017

% filename
filename = 'log.csv'

% close the old serial connection if it is open already
if exist('serialCon', 'var')
    fclose(serialCon);
    delete(serialCon);
    clear serialCon;
end

% build the serial connection
serialCon = serial('COM6')
set(serialCon, 'BaudRate', 9600);
set(serialCon, 'Parity', 'none');
set(serialCon, 'DataBits', 8);
set(serialCon, 'StopBit', 1);
set(serialCon, 'Timeout', 1.5);
set(serialCon, 'FlowControl', 'none');

% open the connection
% NOTE: this must be closed after the program is halted
%       the procedure to close can be found at the bottom of the file
fopen(serialCon);

% the bool for if the program is running
isRunning = true;

% main data taking loop
while isRunning
    % get the data from the UART connection
    data = fscanf(serialCon)
    if ~isempty(data)
        data_matrix(1) = str2num(data(1:4));
        data_matrix(2) = str2num(data(6:9));
        data_matrix(3) = str2num(data(11:14));
        data_matrix(4) = str2num(data(16:19));
        data_matrix(5) = str2num(data(21:24));
        data_matrix(6) = str2num(data(26:29));
        data_matrix(7) = str2num(data(31:34));
        data_matrix(8) = str2num(data(36:39));
        data_matrix(9) = str2num(data(41:44));
        data_matrix(10) = str2num(data(46:49));
    else
        data_matrix = [0 0 0 0 0 0 0 0 0 0];
    end
    
    % append data to the save file
    dlmwrite(filename, data_matrix, 'delimiter', ',', '-append');
end

% close the connection for future use
% NOTE: this close step is very important for stopping future connections
%       remember to close the connection after each run of the program
fclose(serialCon);
delete(serialCon);
clear serialCon;