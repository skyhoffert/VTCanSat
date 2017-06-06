% This matlab file is to determine if real time plotting
% is possible with the matlab software
clear, clc

% variables
filename = 'log.csv';

% output at 1 Hz
for i = 1:400
    % open file
    % happens every iteration to account for user cancelation
    fid = fopen(filename, 'a');
    
    % set values
    teamid = '4542';
    glider = 'glider';
    miss_time = i;
    packets = i;
    alt = 400 - i - rand();
    press = 101325 - alt;
    speed = 5 + rand() - .5;
    temp = 32 - alt / 100;
    voltage = 3.3 + rand() * .1 - .05;
    heading = cos(i/10 + rand()*.1 - .05);
    sw_state = 1;
    
    % print to file
    fprintf(fid, ...
        '%s,%s,%4d,%4d,%3.01f,%6.01f,%1.01f,%2.01f,%1.02f,%03.0f,%d\n', ...
        teamid, glider, miss_time, packets, alt, press, speed, temp, ...
        voltage, heading, sw_state);
    
    % close all files
    fclose('all');
    
    % pause for 1 second
    pause(1);
end