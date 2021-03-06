% Owner:        VT CanSat
% File:         main.m
% Description:  This file runs the GUI which displays plots in
%               real time as the glider descends.
% Modified By:  Sky Hoffert
% LastModified: 6/8/2017

function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 08-Jun-2017 13:34:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% timer for updating display
handles.timer = timer('ExecutionMode', 'fixedRate', 'Period', 1, ...
    'TimerFcn', {@update_display, hObject, handles});

start(handles.timer);

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_release.
function btn_release_Callback(hObject, eventdata, handles)
% hObject    handle to btn_release (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% update output
set(handles.str_output, 'String', 'Release command sent');

% code for releasing the payload
disp('INVALID CODE FOR PAYLOAD RELEASE COMMAND');

% timer callback function
function update_display(obj, event, text_arg, handles)
% update everything

% try to open file
filename = get(handles.str_filename, 'String');

try
    % attempt to open file
    fid = fopen(filename, 'r');
    
    % import the data from the given filename
    data = textscan(fid, repmat('%s', 1, 11), 'delimiter', ',', ...
        'CollectOutput', true);
catch
    % d
    return
end

data = data{1};

% close the file we opened
fclose(fid);

% transfer data to easy matrices to work with
ar_teamid = data(:,1);
ar_glider = data(:,2);
ar_miss_time = data(:,3);
ar_packets = data(:,4);
ar_alt = str2double(data(:,5));
ar_press = str2double(data(:,6));
ar_speed = str2double(data(:,7));
ar_temp = str2double(data(:,8));
ar_voltage = str2double(data(:,9));
ar_heading = str2double(data(:,10));
ar_sw_state = str2double(data(:,11));

% output some info
buffer = 'Output';
set(handles.str_output, 'String', buffer);

% update plots
plot(handles.plot_volt, ar_voltage);
plot(handles.plot_alt, ar_alt);
plot(handles.plot_press, ar_press);
plot(handles.plot_temp, ar_temp);
plot(handles.plot_pos, ar_speed.*cos(ar_heading), ...
    ar_speed.*sin(ar_heading));
plot(handles.plot_speed, ar_speed);
plot(handles.plot_swstate, ar_sw_state);
plot(handles.plot_heading, ar_heading);

% apply titles and other info
title(handles.plot_volt, 'Voltage');
title(handles.plot_alt, 'Altitude');
title(handles.plot_press, 'Pressure');
title(handles.plot_temp, 'Temperature');
title(handles.plot_pos, 'Position');
title(handles.plot_speed, 'Speed');
title(handles.plot_swstate, 'Software State');
title(handles.plot_heading, 'Heading');

ylabel(handles.plot_volt, 'Voltage (V)');
ylabel(handles.plot_alt, 'Altitude (m)');
ylabel(handles.plot_press, 'Pressure (Pa)');
ylabel(handles.plot_temp, 'Temperature (C)');
ylabel(handles.plot_speed, 'Speed (m/s)');
ylabel(handles.plot_swstate, 'Software State');
ylabel(handles.plot_pos, 'Y Position (m)');
xlabel(handles.plot_pos, 'X Position (m)');
ylabel(handles.plot_heading, 'Heading (from N)');

% update status info
set(handles.str_teamid, 'String', ar_teamid{length(ar_teamid)});
set(handles.str_misstm, 'String', ar_miss_time{length(ar_miss_time)});
set(handles.str_pckcnt, 'String', ar_packets{length(ar_packets)});
set(handles.str_swstate, 'String', ar_sw_state(length(ar_sw_state)));

% --- Executes during object creation, after setting all properties.
function str_teamid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str_teamid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function str_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function str_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
