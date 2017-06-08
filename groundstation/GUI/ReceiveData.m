% Owner:        VT CanSat
% File:         ReceiveData.m
% Description:  This script receives data from the xbee radio
%               over the serial UART port
% Modified By:  Sky Hoffert
% LastModified: 6/8/2017

% filenames
filename_glider = 'log_glider.csv';
filename_container = 'log_container.csv';

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
    
    % check the data
    if ~isempty(data)
        % decide if glider or container data
        if (strcmp(data(6:11), 'GLIDER'))
            % glider collection
            data_matrix(1) = str2num(data(1:4)); % teamid
            data_matrix(2) = data(6:11); % origin
            data_matrix(3) = str2num(data(13:16)); % mission time
            data_matrix(4) = str2num(data(18:21)); % packet count
            data_matrix(5) = str2num(data(23:26)); % altitude
            data_matrix(6) = str2num(data(28:31)); % pressure
            data_matrix(7) = str2num(data(33:36)); % speed
            data_matrix(8) = str2num(data(38:41)); % temp
            data_matrix(9) = str2num(data(43:46)); % voltage
            data_matrix(10) = str2num(data(48:51)); % heading
            data_matrix(11) = str2num(data(48:51)); % sw state
            
            % append data to the save file
            dlmwrite(filename_glider, data_matrix, 'delimiter', ',', '-append');
        elseif (strcmp(data(6:14), 'CONTAINER'))
            % container collection
            data_matrix(1) = str2num(data(1:4)); % teamid
            data_matrix(2) = data(6:14); % origin
            data_matrix(3) = str2num(data(15:18)); % mission time
            data_matrix(4) = str2num(data(20:23)); % packet count
            data_matrix(5) = str2num(data(25:28)); % altitude
            data_matrix(6) = str2num(data(30:33)); % temperature
            data_matrix(7) = str2num(data(35:38)); % voltage
            data_matrix(8) = str2num(data(40:43)); % sw state
            
            % append data to the save file
            dlmwrite(filename_container, data_matrix, 'delimiter', ',', '-append');
        end
    else
        % empty data
        data_matrix = {0 0 0 0 0 0 0 0 0 0 0};
    end
    
    % allow a transmission to be complete
    % this may need to be removed
    pause(.333);
end

% close the connection for future use
% NOTE: this close step is very important for stopping future connections
%       remember to close the connection after each run of the program
fclose(serialCon);
delete(serialCon);
clear serialCon;