clear
clc

% initialize random generator
rng(0,'twister');

position = [0;0;0];
numPoints = 50;
floor_altitude = 0;
numLoops = 4;
heading_random_factor = .1;

for i = 1:numPoints

    % generate the random velocity, centered around 2.0 m/s
    velocity = rand(1)*.2 + 1.9;
    % generate the random heading, rotating around from 0 to 2pi
    % 0 in this case would be cardinal West
    heading = 0 + mod(5*numLoops*i/numPoints,2*pi) - heading_random_factor/2 + rand(1)*heading_random_factor;
    % in millibars
    pressure = 999 + i*15/numPoints + rand(1)*.1;
    % in meters
    altitude = 145366.45 * (1 - (pressure/1013.25)^.190284);
    % don't let altitude go below 0, just for testing
    if altitude < floor_altitude
        altitude = floor_altitude;
    end
    
    if (i > 1)
        position(1,i) = position(1,i-1) + velocity*cos(heading);
        position(2,i) = position(2,i-1) + velocity*sin(heading);
        position(3,i) = altitude;
    else
        position(1,i) = 0 + velocity*cos(heading);
        position(2,i) = 0 + velocity*sin(heading);
        position(3,i) = altitude;
        
    end
    
    plot3(position(1,:), position(2,:), position(3,:));
    
    pause(1);

end


% plot(position(1,:), position(2,:));

