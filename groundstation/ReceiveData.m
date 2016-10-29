% Owner:        VT CanSat
% File:         ReceiveData.m
% Description:  This script receives data from the xbee radio
%               over the serial UART port
% Modified By:  Sky Hoffert
% LastModified: 10/29/2016

serialCon = serial('COM6')
set(serialCon, 'BaudRate', 9600);
set(serialCon, 'Parity', 'none');
set(serialCon, 'DataBits', 8);
set(serialCon, 'StopBit', 1);
set(serialCon, 'Timeout', 2);
set(serialCon, 'FlowControl', 'none');
fopen(serialCon);
isRunning = true;

while isRunning
    data = fscanf(serialCon)
    
    user_in = input('Enter Key: ', 's');
    if user_in == 'q'
        break
    end
end

fclose(serialCon);
delete(serialCon);
clear serialCon;