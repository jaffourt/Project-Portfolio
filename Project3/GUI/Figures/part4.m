function varargout = part4(varargin)
% PART4 MATLAB code for part4.fig
%      PART4, by itself, creates a new PART4 or raises the existing
%      singleton*.
%
%      H = PART4 returns the handle to a new PART4 or the handle to
%      the existing singleton*.
%
%      PART4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PART4.M with the given input arguments.
%
%      PART4('Property','Value',...) creates a new PART4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before part4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to part4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help part4

% Last Modified by GUIDE v2.5 15-Aug-2018 09:09:46

% Begin initialization code - DO NOT EDIT 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @part4_OpeningFcn, ...
                   'gui_OutputFcn',  @part4_OutputFcn, ...
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
            


% --- Executes just before part4 is made visible.
function part4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to part4 (see VARARGIN)

% Choose default command line output for part4
handles.output = hObject;
 
% Update handles structure
guidata(hObject, handles);

addpath c:\Users\jaffourtit\desktop\GUI\functions
set(handles.slider2, 'Min', .5);
set(handles.slider2, 'Max', 20);
set(handles.slider2, 'Value', 1.5);
set(handles.slider2, 'SliderStep', [1/(39), 1/(19.5)]);
set(handles.text2, 'String', num2str(get(handles.slider2, 'Value')));

set(handles.slider3, 'Min', 0.0);
set(handles.slider3, 'Max', 1);
set(handles.slider3, 'Value', 0.9);
set(handles.slider3, 'SliderStep', [1/(100), 1/(50)]);
set(handles.text6, 'String', num2str(get(handles.slider3, 'Value')));

reward_field = zeros(46,7);%.*5.01;
setappdata(handles.axes1, 'reward_field', reward_field);

%data = getappdata(0,'Struct');
%x = data.x;
hsi_image1 = load('hsi_image.mat');
hsi_image = hsi_image1.hsi_image;
imshow(hsi_image, 'Parent', handles.axes1);
axis(handles.axes1, [1 224 1 1472]);
struct1 = struct('s1', size(hsi_image,1), 's2', size(hsi_image,2));
setappdata(handles.axes1, 'struct', struct1);




% UIWAIT makes part4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = part4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in set_reward.
function set_reward_Callback(hObject, eventdata, handles)
% hObject    handle to set_reward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


loc = getappdata(handles.axes1, 'counter');
founter = loc.x;
sounter = loc.y;
[sounter, founter] = check_occupied(sounter, founter, 0, handles);

tatt1 = (((founter-1) * 32) + 1);  
tatt2 = founter * 32;
tat1 = (((sounter-1) * 32) + 1);   
tat2 = sounter * 32; 

if handles.lowbutton.Value == 1
    reward = 10;
    text(handles.axes1, ((tatt1+tatt2)/2)-12, (tat1+tat2)/2 , 'L', 'FontSize', 12, 'Color', 'red');
elseif handles.mediumbutton.Value == 1
    reward = 20;
    text(handles.axes1, ((tatt1+tatt2)/2)-12, (tat1+tat2)/2 , 'M', 'FontSize', 12, 'Color', 'red');
else
    reward = 60;
    text(handles.axes1, ((tatt1+tatt2)/2)-12, (tat1+tat2)/2 , 'H', 'FontSize', 12, 'Color', 'red');
end
reward_field = getappdata(handles.axes1,'reward_field');
reward_field(sounter, founter) = reward;
setappdata(handles.axes1,'reward_field',reward_field);
uiresume();


% --- Executes on button press in set_high.
function set_high_Callback(hObject, eventdata, handles)
% hObject    handle to set_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try 
    [y, x] = getpts(handles.axes1);
catch
end
reward = str2double(get(handles.edit1,'String'));
place_reward_values(y, x, reward, false, handles);

% --- Executes on button press in set_low.
function set_low_Callback(hObject, eventdata, handles)
% hObject    handle to set_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [y, x] = getpts(handles.axes1);
catch
end
place_reward_values(y, x, 1, true, handles);

% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.set_reward, 'Enable', 'on');
iterate_image(handles);

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hsi_image1 = load('hsi_image.mat');
hsi_image = hsi_image1.hsi_image;
reward_field = getappdata(handles.axes1,'reward_field');
if get(handles.checkbox3, 'Value') == 1
    Run_Algorithm_4(reward_field,handles);
else
    setappdata(0,'root', reward_field);
end

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2, 'String', num2str(get(handles.slider2, 'Value')));
set(handles.text4,'Visible', 'off');
if (get(handles.slider2,'Value') == 1.5)
    set(handles.text4, 'Visible', 'on');
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
buffer = get(handles.slider3,'Value');
set(handles.text6, 'String', num2str(buffer));
set(handles.slider3, 'Value', roundn(buffer,-2));



% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
% 
% 
function iterate_image(handles)

        founter = 0; 


        for QQ = 1 : 8 %num_blockx

             founter = founter + 1;
             sounter = 0;
             Q = 1;
            
             while Q <= 46 %num_blocky


                sounter = sounter + 1;
                   
                [sounter, founter, skipped] = check_occupied(sounter, founter, 0, handles);
                Q = Q + skipped;
                tatt1 = (((founter-1) * 32) + 1);  
                tatt2 = founter * 32;
                tat1 = (((sounter-1) * 32) + 1);   
                tat2 = sounter * 32; 
                hold(handles.axes1,'on');
                plot(handles.axes1,[tatt1 tatt2 tatt2 tatt1 tatt1], [tat1 tat1 tat2 tat2 tat1],'r-')
                drawnow;
                
                counter = struct('x', founter, 'y', sounter);
                setappdata(handles.axes1, 'counter', counter);
                Q = Q + 1;
                
               uiwait();
            end
        end

function place_reward_values(y, x, reward, isLow, handles)
% number of getpts
n = size(y, 1);

% appdata
struct1 = getappdata(handles.axes1, 'struct');
reward_field = getappdata(handles.axes1,'reward_field');
hold(handles.axes1,'on');

% iteration details
rowsize = struct1.s1;
colsize = struct1.s2;
col = zeros(46, 7);
row = zeros(46, 7);

% map where the points are with respect to image chips
for i = 1 : n
    for j = 1: floor(colsize/32)
        if (y(i) <= j*32)
            col(i) = j;
            break;
        end
    end

    for j = 1 : floor(rowsize/32)
        if (x(i) <= j*32)
            row(i) = j;
            break;
        end
    end  
    
    tatt1 = (((col(i)-1) * 32) + 1);  
    tatt2 = col(i) * 32;
    tat1 = (((row(i)-1) * 32) + 1);   
    tat2 = row(i) * 32;
    
    plot(handles.axes1,[tatt1 tatt2 tatt2 tatt1 tatt1], [tat1 tat1 tat2 tat2 tat1],'r-')
    
    if isLow
        text(handles.axes1, ((tatt1+tatt2)/2)-12, (tat1+tat2)/2 , num2str(reward), 'FontSize', 12, 'Color', 'red');
    else
        text(handles.axes1, ((tatt1+tatt2)/2)-12, (tat1+tat2)/2 , num2str(reward), 'FontSize', 12, 'Color', 'red');
    end
    drawnow;

    reward_field(row(i), col(i)) = reward;
end            
% return reward field to root
setappdata(handles.axes1,'reward_field',reward_field);



function [new_sounter, new_founter, skipped] = check_occupied(sounter, founter, skipped, handles)

reward_abundance1 = getappdata(handles.axes1, 'reward_field');

%check edge case
if sounter == 47
    
    new_sounter = sounter;
    new_founter = founter;
  
    return; 
    
elseif founter == 8
     
    new_sounter = sounter;
    new_founter = founter;

    return;
end

% annoying matlab syntax.. values change
new_sounter = 1;
new_founter = 1;

if reward_abundance1(sounter, founter) ~= 0 %
    skipped = skipped + 1;
    if sounter == 47
        new_sounter = 1;
        new_founter = founter + 1;
    else
        new_sounter = sounter + 1;    
    end
else
    new_sounter = sounter;
    new_founter = founter;

    return;
end

[new_sounter, new_founter, skipped] = check_occupied(new_sounter, new_founter, skipped, handles);


% --- Executes on button press in policybutton.
function policybutton_Callback(hObject, eventdata, handles)
% hObject    handle to policybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of policybutton


% --- Executes on button press in dijkstrabutton.
function dijkstrabutton_Callback(hObject, eventdata, handles)
% hObject    handle to dijkstrabutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dijkstrabutton


% --- Executes on button press in meshbutton.
function meshbutton_Callback(hObject, eventdata, handles)
% hObject    handle to meshbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hsi_image1 = load('hsi_image.mat');
hsi_image = hsi_image1.hsi_image;
reward_field = getappdata(handles.axes1,'reward_field');
if get(handles.checkbox1, 'Value') == 1
    filt_val = get(handles.slider2, 'Value');
    meshCanopy(rgb2gray(hsi_image),imgaussfilt(reward_field, filt_val),'jet', 20);
else
    meshCanopy(rgb2gray(hsi_image), reward_field, 'jet', 20);
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
