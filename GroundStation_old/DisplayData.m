function [] = DisplayData(Data)

% create time array
for i = 1:100000
    Time(i) = i;
end

%plot the data
plot(Time(1:length(Data)), Data);