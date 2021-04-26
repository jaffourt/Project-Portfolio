function varargout = part2(varargin) 
% PART2 MATLAB code for part2.fig
%      PART2, by itself, creates a new PART2 or raises the existing
%      singleton*.
%
%      H = PART2 returns the handle to a new PART2 or the handle to
%      the existing singleton*.
%
%      PART2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PART2.M with the given input arguments.
%
%      PART2('Property','Value',...) creates a new PART2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before part2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to part2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help part2

% Last Modified by GUIDE v2.5 14-Aug-2018 13:56:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @part2_OpeningFcn, ...
                   'gui_OutputFcn',  @part2_OutputFcn, ...
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


% --- Executes just before part2 is made visible.
function part2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to part2 (see VARARGIN)

% Choose default command line output for part2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
data = getappdata(0,'Struct');
Run_Algorithm_2(data, handles);
set(handles.pushbutton4,'enable','on');
set(handles.pushbutton5,'enable','on');

%part3


% UIWAIT makes part2 wait for user response (see UIRESUME)
%uiwait(handles.part2);



 
 

% --- Outputs from this function are returned to the command line.
function varargout = part2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop_val = 1;
setappdata(handles.pushbutton1, 'paused', stop_val);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume();
stop_val = 0;
setappdata(handles.pushbutton1, 'paused', stop_val);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume();


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Spec_sig1 = getappdata(handles.axes2, 'signal1');
Spec_sig2 = getappdata(handles.axes2, 'signal2');

Reward_abundance1 = getappdata(handles.axes2, 'reward1');
Reward_abundance2 = getappdata(handles.axes2, 'reward2');

data = getappdata(0, 'Struct');
x=data.x;
x_new = x(1:1376,1:256,6:256);


switch get(get(handles.uibuttongroup2,'SelectedObject'),'Tag')
    case 'atgp'
        for i = 26: 38
            eval(['axes(handles.axes' num2str(i) ');']);
            eval(['plot(Spec_sig1(:,' num2str(i-25) '))']);
            axis off
        end
        
        cla(handles.axes1, 'reset');
         
        imagesc(handles.axes1, x_new(:,:,106));  
        hold(handles.axes1, 'on');
        ffounter = 0;
        ccount = 0;

        for QQ = 1 : 8
    
            ffounter = ffounter + 1;
    
            tatt1 = (((ffounter-1) * 32) + 1);  
    
            tatt2 = ffounter * 32;
    
            scounter = 0;

    
                for Q = 1 : 43

                ccount = ccount + 1;

                scounter = scounter + 1;

                tat1 = (((scounter-1) * 32) + 1);   
                tat2 = scounter * 32; 
                
                plot(handles.axes1,[tatt1 tatt2 tatt2 tatt1 tatt1], [tat1 tat1 tat2 tat2 tat1],'k-')
                text(handles.axes1, ((tatt1+tatt2)/2)-12, (tat1+tat2)/2 ,num2str(Reward_abundance1(Q,QQ)) , 'Color','green','FontSize',12.0,'FontWeight', 'bold');
                drawnow; 
                end
        end
    case 'kmeans'
         cla(handles.axes1, 'reset');
         
         imagesc(handles.axes1, x_new(:,:,106));  
         hold(handles.axes1, 'on');
        
         for i = 26: 38
            eval(['axes(handles.axes' num2str(i) ');']);
            eval(['plot(Spec_sig2(:,' num2str(i-25) '))']);
            axis off
         end
         
        ffounter = 0;
        ccount = 0;

        for QQ = 1 : 8
    
            ffounter = ffounter + 1;
    
            tatt1 = (((ffounter-1) * 32) + 1);  
    
            tatt2 = ffounter * 32;
    
            scounter = 0;

    
                for Q = 1 : 43

                ccount = ccount + 1;

                scounter = scounter + 1;

                tat1 = (((scounter-1) * 32) + 1);   
                tat2 = scounter * 32; 
                
                plot(handles.axes1,[tatt1 tatt2 tatt2 tatt1 tatt1], [tat1 tat1 tat2 tat2 tat1],'k-')
                text(handles.axes1, ((tatt1+tatt2)/2)-12, (tat1+tat2)/2 ,num2str(Reward_abundance2(Q,QQ)) , 'Color','green','FontSize',12.0,'FontWeight', 'bold');
                drawnow; 
                end
        end
   
end

    


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
part3;
