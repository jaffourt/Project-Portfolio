function varargout = part1(varargin)
% part1 MATLAB code for part1.fig
%      part1, by itself, creates a new part1 or raises the existing
%      singleton*.
%
%      H = part1 returns the handle to a new part1 or the handle to
%      the existing singleton*.
%
%      part1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in part1.M with the given input arguments.
%
%      part1('Property','Value',...) creates a new part1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before part1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to part1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help part1

% Last Modified by GUIDE v2.5 05-Jul-2018 13:55:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @part1_OpeningFcn, ...
                   'gui_OutputFcn',  @part1_OutputFcn, ...
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


% --- Executes just before part1 is made visible.
function part1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to part1 (see VARARGIN)

% Choose default command line output for part1
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes part1 wait for user response (see UIRESUME)
% uiwait(handles.part1);
set(handles.slider1, 'Min', 1);
set(handles.slider1, 'Max', 251);
set(handles.slider1, 'Value', 1);
set(handles.slider1, 'SliderStep', [1/(250), 1/(250)]);
set(handles.text16, 'String', 8.209229 + 406.68);






% --- Outputs from this function are returned to the command line.
function varargout = part1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
  
%{
    cd c:/jaffourtit/Affourtit_files/SCC_data/three/Scan_00100
    x = multibandread('2012-09-26_18-31-18.HSI.Scan_00100.scene.corrected.hsi',[1480,256,256],'int16',0,'bip','ieee-be');
    cd C:\Users\jaffourtit\Desktop
    %}

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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% make this a function :: x = get_file(handles);
list_no = get(handles.popupmenu1, 'Value');
switch list_no
    case 1
        
        filename = '2012-09-26_18-31-18.HSI.Scan_00100.scene.corrected.hsi';
    case 2 
end
     x = multibandread(filename,[1480,256,256],'int16',0,'bip','ieee-be');
     main(x,handles)
     
function main(x,handles)

[spec_cube1, spec_cube2, image_PCs_cube] = Run_Algorithm(x,handles);
data = struct('spec1', spec_cube1,'spec2',spec_cube2,'x',x);
setappdata(0,'Struct',data);
setappdata(handles.axes21, 'cube', image_PCs_cube);
image = x(1344:1376, 224:256, 6:256);
setappdata(handles.axes1,'new_cut',image);
set(handles.next_button, 'enable','on');
%part2


%%%%%%%%%%%%%%%%%%%%%%%%% Import File %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,path] = uigetfile('c:\jaffourtit\affourtit_files\scc_data\*.*','Select HSI data');
set(handles.file_name,'String',filename);
addpath(path);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
name = get(handles.file_name,'String');
% try and catch loop -> try different HSI sizes otherwise print error 
% this try catch also gives an error for non-HSI files
try
    x = multibandread(name,[1480,256,256],'int16',0,'bip','ieee-be');
    main(x,handles);
catch
    try 
        x = multibandread(name,[1400,256,256],'int16',0,'bip','ieee-be');
        main(x,handles);
    catch
        try
            x = multibandread(name,[1320,256,256],'int16',0,'bip','ieee-be');
            main(x,handles);
        catch
            try
                x = multibandread(name,[1300,256,256],'int16',0,'bip','ieee-be');
                main(x,handles);
            catch
                error('Error: File size not recognizable'); 
            end
        end
    end
end
%% end import functions

% --- Executes on button press in display_sig_button.
function display_sig_button_Callback(hObject, eventdata, handles)
% hObject    handle to display_sig_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[xpnt,ypnt] = getpts(handles.axes2);

image = getappdata(handles.axes1, 'new_cut');

pixel = reshape(image(floor(xpnt),floor(ypnt),:),[251 1]);
plot(handles.axes12,pixel);
axis(handles.axes12,[0 300 0 7000]);
xlabel(handles.axes12, 'Wavelength Band (\lambda)');
ylabel(handles.axes12, 'Energy');
drawnow

% --- Executes on button press in select_pixel_button
function select_pixel_button_Callback(hObject, eventdata, handles)
% hObject    handle to select_pixel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[xpnt, ypnt] = getpts(handles.axes1);
x = floor(xpnt);
y = floor(ypnt);
data = getappdata(0,'Struct');
r_old = data.x;
r = r_old(1:1376, 1:256, 6:256);
[rowsize,colsize] = size(r);

for i = 1: floor(colsize/32)
    if (x <= i*32)
        col = i;
        break;
    end
end

for i = 1 : floor(rowsize/32)
    if (y<= i*32)
        row = i;
        break;
    end
end

% check for edge cases or just display cut
try
    image = r( (row-1)*32 : row*32 , (col-1)*32 : col*32, : );
catch
    try
        image = r( 1 : row*32 , (col-1)*32 : col*32, : );
    catch
        try 
            image = r( (row-1)*32 : row*32 , 1 : col*32, : );
        catch
            
                image = r( 1 : 32 , 1 : 32, : );   
        end
    end
end
        

pixel = reshape(image(16,16,:),[251 1]);
plot(handles.axes12,pixel);
axis(handles.axes12,[0 300 0 7000]);
xlabel(handles.axes12, 'Wavelength Band (\lambda)');
ylabel(handles.axes12, 'Energy');
image_PCs_cube = PCA(image,handles);
setappdata(handles.axes21, 'cube', image_PCs_cube);
drawnow
setappdata(handles.axes1,'new_cut',image);
val = get(handles.slider1, 'Value');
imagesc(handles.axes2, image(:,:,floor(val)));





% --- Executes on button press in next_button.
function next_button_Callback(hObject, eventdata, handles)
% hObject    handle to next_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
part2;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
dummy = floor(get(handles.slider1,'Value'));
lambda = 8.209229*dummy + 406.68;
set(handles.text16, 'String', lambda);
val = get(handles.slider1, 'Value');
image = getappdata(handles.axes1, 'new_cut');
imagesc(handles.axes2, image(:,:,floor(val)));
if (lambda >= 380 && lambda < 450)
    set(handles.label, 'String', 'Violet');
elseif (lambda >= 450 && lambda < 495)
    set(handles.label, 'String', 'Blue');
elseif (lambda >= 495 && lambda < 570)
    set(handles.label, 'String', 'Green');
elseif (lambda >= 570 && lambda < 590)
    set(handles.label, 'String', 'Yellow');
elseif (lambda >= 590 && lambda < 620)
    set(handles.label, 'String', 'Orange');
elseif (lambda >= 620 && lambda < 750)
    set(handles.label, 'String', 'Red');
elseif (lambda >= 750)
    set(handles.label, 'String', 'Infrared');
end


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pca_button1.
function pca_button1_Callback(hObject, eventdata, handles)
% hObject    handle to pca_button1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PC_cube = getappdata(handles.axes21, 'cube');
[xpnt, ypnt] = getpts(handles.axes3,1);
signal = reshape(PC_cube(floor(xpnt), floor(ypnt), :), [15 1]);
set(handles.axes21, 'visible', 'on');
plot(handles.axes21, signal);
axis(handles.axes21,'off');
axis(handles.axes1,'on');
