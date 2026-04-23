% Created by:
% ----------------------------------------------------------------------- %
%   Author:  Elena Spagnuolo                              %
%   Date:    2012                                                         %
%   E-mail:                                                               %
% ----------------------------------------------------------------------- %
% With contributions from Christopher W. Harbord, Stefano Aretusini

function varargout = shivaUNIX(varargin)
% SHIVAUNIX M-file for shivaUNIX.fig
%      SHIVAUNIX, by itself, creates a new SHIVAUNIX or raises the existing
%      singleton*.
%
%      H = SHIVAUNIX returns the handle to a new SHIVAUNIX or the handle to
%      the existing singleton*.
%
%      SHIVAUNIX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHIVAUNIX.M with the given input arguments.

%      SHIVAUNIX('Property','Value',...) creates a new SHIVAUNIX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before shivaWIN_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to shivaUNIX_OpeningFcn via varargin.3

%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help shivaUNIX

% Last Modified by GUIDE v2.5 23-Mar-2023 14:23:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @shivaUNIX_OpeningFcn, ...
    'gui_OutputFcn',  @shivaUNIX_OutputFcn, ...
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

format('long')
% End initialization code - DO NOT EDIT
end

% --- Executes just before shivaUNIX is made visible.
function shivaUNIX_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to shivaUNIX (see VARARGIN)
% Function to maximize the window via undocumented Java call.
% Reference: http://undocumentedmatlab.com/blog/minimize-maximize-figure-window

% Preparation of paths
% go to root
thisFilePath = mfilename('fullpath');
cd(fileparts(thisFilePath))
cd ..
% add all subfolders to path
addpath(genpath(pwd))

% initialize log
handles.log={};

set(handles.figure1, 'units', 'normalized', 'position', [0.01 0.01 0.9 0.9])

axes(handles.axes6)
matlabImage = imread('shiva.jpg');
image(matlabImage)
axis off
axis image

% Choose default command line output for shivaUNIX
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using shivaUNIX.

% UIWAIT makes shivaUNIX wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = shivaUNIX_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        plot(rand(5));
    case 2
        plot(sin(1:0.01:25.99));
    case 3
        bar(1:.5:10);
    case 4
        plot(membrane);
    case 5
        surf(peaks);
end
end

%% WRITE --------------------------------------------------------------------
function write_Callback(hObject, eventdata, handles)
% hObject    handle to write (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[nome,pat]=uiputfile( ...
    {'*.txt', 'All MATLAB Files (*txt)'; ...
    '*.*',                   'All Files (*.*)'}, ...
    'Write as',fullfile(pwd, handles.filename));
if isequal(nome,0) || isequal(pat,0), return; end

% Recupera lo stato degli elementi della GUI
h_fluid = findobj('Tag', 'fluid');
statoF = get(h_fluid, 'Value');

h_GH = findobj('Tag', 'GH');
statoGH = get(h_GH, 'Value');
statoCAL = handles.Done;

params_struct = struct('FileName', fullfile(pat, nome), 'statoF', statoF, 'statoGH', statoGH, 'statoCAL', statoCAL);
[final_txt_path, handles] = write_ascii_data(handles, params_struct);

% Salva il log in formato JSON chiamando la funzione dedicata
save_log_to_json(handles, final_txt_path);

end

%% OPEN --------------------------------------------------------------------
function OpenMenuItem2_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1. Pulisci la sessione precedente chiamando la funzione esterna
handles = reset_session(handles);
handles.load=0; % flag su load o open

%definisce i grafici da plottare:
%qui ci sono i default
handles.g1=2;
handles.g2=3;
handles.g3=5;

ax_=findobj('Tag','edit1'); set(ax_,'String',handles.g1);
ax_=findobj('Tag','edit2'); set(ax_,'String',handles.g2);
ax_=findobj('Tag','edit3'); set(ax_,'String',handles.g3);

cfg=get_config();
% 2. Seleziona il file e carica i dati
[FileName,PathName] = uigetfile('*.*','All Files (*.*)', ...
    cfg.ascii_data_root_path);
if isequal(FileName,0) || isequal(PathName,0), return; end

% Passa il valore richiesto dalla UI alla funzione
h_xlab = findobj('Tag', 'XLab');
params_struct = struct('FileName', fullfile(PathName, FileName), 'hv', get(h_xlab, 'Value'));
handles = open_ascii_data(handles, params_struct);

guidata(hObject, handles);
plotta_ora(handles);
end

%% PLOT
function plotta_ora(handles)

hOb=findobj('Tag','XLab');
h_ele=get(hOb,'Value');
if h_ele==2; handles.X=handles.Time./handles.tconv;
elseif h_ele==1; handles.X=handles.Rate;
elseif h_ele==3 & any(strcmp(fieldnames(handles),'slip')); handles.X=handles.slip;
elseif h_ele==3 & any(strcmp(fieldnames(handles),'slipF')); handles.X=handles.slipF;
else handles.X=handles.Rate;
end



stato=handles.zoom;
posx=get(handles.axes1,'XLim');

eval(['plot(handles.X,handles.' handles.column{(handles.g1)} ',''ob'',''parent'',handles.axes1);']);
legend(handles.axes1,[handles.column{handles.g1}])
lim1=get(handles.axes1,'Ylim'); a=findobj('Tag','lim1S'); set(a,'String',lim1(:,2)); b=findobj('Tag','lim1I'); set(b,'String',lim1(:,1));
if (stato==1); set(handles.axes1,'XLim',[posx]); end

eval(['plot(handles.X,handles.' handles.column{(handles.g2)} ',''ob'',''parent'',handles.axes2);']);
legend(handles.axes2,[handles.column{handles.g2}])
lim2=get(handles.axes2,'Ylim'); a=findobj('Tag','lim2S'); set(a,'String',lim2(:,2)); b=findobj('Tag','lim2I'); set(b,'String',lim2(:,1));
if (stato==1); set(handles.axes2,'XLim',[posx]); end

eval(['plot(handles.X,handles.' handles.column{(handles.g3)} ',''ob'',''parent'',handles.axes3);']);
legend(handles.axes3,[handles.column{handles.g3}])
lim3=get(handles.axes3,'Ylim'); a=findobj('Tag','lim3S'); set(a,'String',lim3(:,2)); b=findobj('Tag','lim3I'); set(b,'String',lim3(:,1));
if (stato ==1) ; set(handles.axes3,'XLim',[posx]); end
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)
end

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)
end


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});
end


%% --- Executes on button press in zoom.
function zoom_Callback(hObject, eventdata, handles)
% hObject    handle to zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_ele=get(hObject,'Value');
pippo=[handles.axes1, handles.axes2,handles.axes3];
linkaxes(pippo,'x');

if h_ele==1
    zoom on;
else
    zoom off
end
end


% --- Executes on button press in pan.
function pan_Callback(hObject, eventdata, handles)
% hObject    handle to pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_ele=get(hObject,'Value');
pippo=[handles.axes1, handles.axes2,handles.axes3];
linkaxes(pippo,'x');

if h_ele==1
    pan on;
else
    pan off
end
end


%% EDIT1
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.g1=str2double(get(hObject,'String'));

if handles.g1 ~= handles.g1
    [s,v] = listdlg('PromptString','Select a file:',...
        'SelectionMode','single',...
        'ListString',handles.column);

    handles.g1=s; %str2double(get(hObject,'String'));
end

guidata(hObject, handles);
set(hObject,'String',handles.g1)

hOb=findobj('Tag','XLab');
h_ele=get(hOb,'Value');
handles.X=trovadataX(handles.axes1);
eval(['plot(handles.X,handles.' handles.column{(handles.g1)} ',''ob'',''parent'',handles.axes1);']);
legend(handles.axes1,[handles.column{handles.g1}])
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
end


%% EDIT2
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles.g2=str2double(get(hObject,'String'));

if handles.g2 ~= handles.g2
    [s,v] = listdlg('PromptString','Select a file:',...
        'SelectionMode','single',...
        'ListString',handles.column);

    handles.g2=s; %str2double(get(hObject,'String'));
end
guidata(hObject, handles);
set(hObject,'String',handles.g2)

hOb=findobj('Tag','XLab');
h_ele=get(hOb,'Value');
handles.X=trovadataX(handles.axes1);

eval(['plot(handles.X,handles.' handles.column{(handles.g2)} ',''ob'',''parent'',handles.axes2);']);
legend(handles.axes2,[handles.column{handles.g2}])
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


%% EDIT3
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
%handles.g3=str2double(get(hObject,'String'));
handles.g3=str2double(get(hObject,'String'));

if handles.g3 ~= handles.g3
    [s,v] = listdlg('PromptString','Select a file:',...
        'SelectionMode','single',...
        'ListString',handles.column);

    handles.g3=s; %str2double(get(hObject,'String'));
end
guidata(hObject, handles);
set(hObject,'String',handles.g3)

hOb=findobj('Tag','XLab');
h_ele=get(hOb,'Value');
handles.X=trovadataX(handles.axes1)

eval(['plot(handles.X,handles.' handles.column{(handles.g3)} ',''ob'',''parent'',handles.axes3);']);
legend(handles.axes3,[handles.column{handles.g3}])
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end




% --- Executes on button press in XLab.
function XLab_Callback(hObject, eventdata, handles)
% hObject    handle to XLab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% hObject    handle to XLab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of XLab

h_ele=get(hObject,'Value');
handles.X=trovadataX(handles.axes1);

guidata(hObject, handles);

plotta_ora(handles);
end


% --- Executes on button press in offset.
function offset_Callback(hObject, eventdata, handles)
% hObject    handle to offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to offset_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1. Interazione con l'utente
[sel, ~] = listdlg('PromptString', 'Select columns to offset:', ...
    'SelectionMode', 'multiple', ...
    'ListString', handles.column);
if isempty(sel)
    return; % L'utente ha annullato
end

disp('Select a point on the plot to use as zero-offset...');
[xi, ~] = ginput(1);
offset_index = trovaasse(handles.axes1, xi);

% 2. Chiama la funzione esterna
params_struct = struct('selected_columns_indices', sel, 'offset_index', offset_index);
handles = apply_offset(handles, params_struct);

guidata(hObject, handles);
plotta_ora(handles);
end




% --- Executes on button press in trigger.
function trigger_Callback(hObject, eventdata, handles)
% hObject    handle to trigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1. Interazione con l'utente
t_cut = trovadataX(handles.axes1);
trigger_index = [];

if isfield(handles, 'shearT') && handles.shearT > 0
    prev_trig = find(handles.RateZero == handles.shearT, 1);
    k = menu(['Trigger is at ' num2str(handles.shearT) '. Is that ok?'], 'Yes', 'No, select new', 'Manual input');
    if k == 1
        trigger_index = prev_trig;
    elseif k == 2
        disp('Select a new trigger point on the plot...');
        [xi, ~] = ginput(1);
        trigger_index = find(abs(t_cut - xi) == min(abs(t_cut - xi)), 1);
    elseif k == 3
        xi = input('Enter a trigger value for the X-axis: ');
        trigger_index = find(abs(t_cut - xi) == min(abs(t_cut - xi)), 1);
    end
else
    disp('Select a trigger point on the plot...');
    [xi, ~] = ginput(1);
    trigger_index = find(abs(t_cut - xi) == min(abs(t_cut - xi)), 1);
end

% 2. Chiama la funzione esterna
if ~isempty(trigger_index)
    params_struct = struct('trigger_index', trigger_index);
    handles = apply_trigger(handles, params_struct);
    set(findobj('Tag', 'XLab'), 'Value', 2); % Imposta l'asse X su 'Time'
end

guidata(hObject, handles);
plotta_ora(handles);
end




%% --- Executes on button press in decimate.
function decimate_Callback(hObject, eventdata, handles)
% hObject    handle to decimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'column') || isempty(handles.column); err=msgbox('no data stored!'); waitfor(err); return; end

Ndec = str2num(get(hObject,'String'));
if isempty(Ndec) || Ndec < 1
    disp('Invalid decimation factor.');
    return;
end
params_struct = struct('decimation_factor', Ndec);
handles = decimate_data(handles, params_struct);

guidata(hObject, handles);
plotta_ora(handles);
end
%set(hObject,'String','decimate','BackgroundColor',[0.75 0.75 0.75]);

function decimate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to decimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[0.75 0.75 0.75]);
    waitfor(hObject,'String')
end
end

%% --- Executes on button press in smooth

function smooth_Callback(hObject, eventdata, handles)
% hObject    handle to smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smooth as text
%        str2double(get(hObject,'String')) returns contents of smooth as a double

window_size = str2num(get(hObject,'String'));
if isempty(window_size); window_size = 500; end

disp('Select an axis to apply smoothing...');
ginput(1)
ax_=get(gcf,'CurrentAxes');
[~, axis_idx] = ismember(ax_, [handles.axes1, handles.axes2, handles.axes3]);

if axis_idx > 0
    h_ = findobj('Tag', ['edit' num2str(axis_idx)]);
    col_idx = str2double(get(h_, 'String'));

    params_struct = struct('column_index', col_idx, 'window_size', window_size);
    handles = apply_smoothing(handles, params_struct);

    % Update the list boxes
    h_ = findobj('Tag','edit1LB'); set(h_,'String',handles.column);
    h_ = findobj('Tag','edit2LB'); set(h_,'String',handles.column);
    h_ = findobj('Tag','edit3LB'); set(h_,'String',handles.column);
end

h_=findobj('Tag','edit1LB'); set(h_,'String',handles.column);
h_=findobj('Tag','edit2LB'); set(h_,'String',handles.column);
h_=findobj('Tag','edit3LB'); set(h_,'String',handles.column);



guidata(hObject, handles);

plotta_ora(handles);
end

% --- Executes during object creation, after setting all properties.
function smooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%% --- Executes on button press in cut_dt
function cut_dt_Callback(hObject, eventdata, handles)
% hObject    handle to cut_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cut_dt as text
%        str2double(get(hObject,'String')) returns contents of cut_dt as a double
dt_val = str2double(get(hObject,'String'));
if isempty(dt_val)
    disp('Invalid dt value for cutting.');
    return;
end

params_struct = struct('dt_value', dt_val);
handles = cut_data_by_timestep(handles, params_struct);

guidata(hObject, handles);
plotta_ora(handles);
end
% --- Executes during object creation, after setting all properties.



%% --- Executes on button press in cut.
function cut_Callback(hObject, eventdata, handles)
% hObject    handle to cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1. Interazione con l'utente
disp('Select start and end points for cutting data...');
t_cut = trovadataX(handles.axes1);
[xi, ~] = ginput(2);

mat(1,:) = abs(t_cut - xi(1));
mat(2,:) = abs(t_cut - xi(2));
range_indices(1) = find(mat(1,:) == min(mat(1,:)), 1);
range_indices(2) = find(mat(2,:) == min(mat(2,:)), 1);

% 2. Chiama la funzione esterna
params_struct = struct('range_indices', sort(range_indices));
handles = cut_data_range(handles, params_struct);

guidata(hObject, handles);
plotta_ora(handles);
end

%% --- Executes on button press in fft.
function fft_Callback(hObject, eventdata, handles)
% hObject    handle to fft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1. Interazione con l'utente
disp('Click on the plot to select the data segment for FFT...');
ginput(1);
ax_ = get(gcf, 'CurrentAxes');
[~, n] = ismember(ax_, [handles.axes1, handles.axes2, handles.axes3]);
if n == 0, return; end

t_cut = trovadataX(ax_);
posx = get(ax_, 'XLim');
I1 = find(abs(t_cut - posx(1)) == min(abs(t_cut - posx(1))), 1);
I2 = find(abs(t_cut - posx(2)) == min(abs(t_cut - posx(2))), 1);

h_ = findobj('Tag', ['edit' num2str(n)]);
s = str2double(get(h_, 'String'));

% 2. Chiama la funzione esterna
target_axes.axes4 = handles.axes4;
target_axes.axes5 = handles.axes5;
apply_fft(handles, s, [I1, I2], target_axes);

set(hObject, 'Value', 0);
end
% --------------------------------------------------------------------
%% --------------------------------------------------------------------
function Interactive_Callback(hObject, eventdata, handles)
% hObject    handle to Interactive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
keyboard
return
end

%% --- Executes on button press in calibration.
function calibration_Callback(hObject, eventdata, handles)
% hObject    handle to calibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% I made another button to do this
end


%% --- Executes on button press in Gefran.
function Gefran_Callback(hObject, eventdata, handles)
% hObject    handle to Gefran (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Gefran
if get(hObject,'Value') == 1
    ButtonName = questdlg('GEFRAN operations require preliminary steps (e.g., cut_dt, decimate). Do you want to load GEFRAN data now?', ...
        'Load GEFRAN Data', 'Yes', 'No', 'No');

    if strcmp(ButtonName, 'Yes')
        cfg = get_config();
        
        % Call the dedicated function to find the GEFRAN file path
        gefran_file_path = find_gefran_file(handles.filename, cfg.gefran_data_root_path);
        
        if ~isempty(gefran_file_path)
            params_struct = struct('gefran_file_path', gefran_file_path);
            handles = load_gefran_data(handles, params_struct);
            guidata(hObject, handles);
            plotta_ora(handles);
        end
    else
        disp('GEFRAN loading cancelled by user.');
        set(hObject, 'Value', 0); % Resetta il checkbox
    end
end
end

%%%%%%%%%%% fine GEF

%% --- Executes on button press in running.
function running_Callback(hObject, eventdata, handles)
% hObject    handle to running (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1. Interazione con l'utente
disp('Select start and end points for running mean calculation...');
t_cut = trovadataX(handles.axes1);
[xi, ~] = ginput(2);

mat(1,:) = abs(t_cut - xi(1));
mat(2,:) = abs(t_cut - xi(2));
range_indices(1) = find(mat(1,:) == min(mat(1,:)), 1);
range_indices(2) = find(mat(2,:) == min(mat(2,:)), 1);

ax_ = get(gcf, 'CurrentAxes');
[~, n] = ismember(ax_, [handles.axes1, handles.axes2, handles.axes3]);
h_ = findobj('Tag', ['edit' num2str(n)]);
s = str2double(get(h_, 'String'));

% 2. Chiama la funzione esterna
params_struct = struct('column_index', s, 'range_indices', range_indices);
handles = apply_running_mean(handles, params_struct);

guidata(hObject, handles);
plotta_ora(handles);
end
% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% PRINT---------------------------------------------------------
function print_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles, 'filename')
    % Chiama la funzione esterna per creare la figura per la stampa
    create_printable_figure(handles);
else
    errordlg('No data loaded to print.', 'Print Error');
end
end


% --- Executes on button press in outlayers.
function outlayers_Callback(hObject, eventdata, handles)
% hObject    handle to outlayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1. Interazione con l'utente
disp('Click on outliers. Right-click to replace individual points, middle-click for a range. Press Enter to finish.');
t_cut = trovadataX(handles.axes1);

button = 1;
xi = [];
while button == 1
    [x, ~, b] = ginput(1);
    if isempty(b) || b > 1, break; end % Termina con Enter o altri tasti
    button = b;
    xi(end+1) = x;
end
final_button = b; % L'ultimo tasto premuto

if isempty(xi), return; end

ax_ = get(gcf, 'CurrentAxes');
[~, n] = ismember(ax_, [handles.axes1, handles.axes2, handles.axes3]);
h_ = findobj('Tag', ['edit' num2str(n)]);
s = str2double(get(h_, 'String'));

% Trova l'indice per ogni punto cliccato
ll = zeros(1, length(xi));
for k = 1:length(xi)
    [~, ll(k)] = min(abs(t_cut - xi(k)));
end

% 2. Chiama la funzione esterna
params_struct = struct('column_index', s, 'outlier_indices', ll, 'button_type', final_button);
handles = remove_outliers(handles, params_struct);

guidata(hObject, handles);
plotta_ora(handles);
end

% --- Executes on selection change in edit1LB.
function edit1LB_Callback(hObject, eventdata, handles)
% hObject    handle to edit1LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns edit1LB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit1LB


s=get(hObject,'Value');
h=findobj('Tag','edit1');
handles.g1=s;
set(h,'String',s);

guidata(hObject, handles);

plotta_ora(handles);
end

% --- Executes on selection change in edit2LB.
function edit2LB_Callback(hObject, eventdata, handles)
% hObject    handle to edit2LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns edit2LB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit2LB

s=get(hObject,'Value');
h=findobj('Tag','edit2');
handles.g2=s;
set(h,'String',s);

guidata(hObject, handles);

plotta_ora(handles);
end

% --- Executes on selection change in edit3LB.
function edit3LB_Callback(hObject, eventdata, handles)
% hObject    handle to edit3LB (see GCBO)
%
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns edit3LB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit3LB

s=get(hObject,'Value');
h=findobj('Tag','edit3');
handles.g3=s;
set(h,'String',s);

guidata(hObject, handles);

plotta_ora(handles);
end

%% LOAD --------------------------------------------------------------------
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1. Pulisci la sessione precedente chiamando la funzione esterna
handles = reset_session(handles);
handles.g1=2;
handles.g2=3;
handles.g3=5;

ax_=findobj('Tag','edit1'); set(ax_,'String',handles.g1);
ax_=findobj('Tag','edit2'); set(ax_,'String',handles.g2);
ax_=findobj('Tag','edit3'); set(ax_,'String',handles.g3);

h_=findobj('Tag','edit1LB'); set(h_,'String',1);
h_=findobj('Tag','edit2LB'); set(h_,'String',1);
h_=findobj('Tag','edit3LB'); set(h_,'String',1);

cfg = get_config();
% 2. Seleziona il file e carica i dati
[FileName,PathName] = uigetfile('*.*','All Files (*.*)', ...
    cfg.mat_data_root_path);
if isequal(FileName,0) || isequal(PathName,0), return; end

params_struct = struct('FileName', fullfile(PathName, FileName));
handles=load_mat_data(handles, params_struct);

% Dopo aver caricato i dati, chiama la funzione dedicata per caricare il log
handles.log = load_log_from_json(fullfile(PathName, FileName)); % This now correctly finds .mat.json

guidata(hObject, handles);
plotta_ora(handles);
end

%% write BINARY --------------------------------------------------------------
function binary_Callback(hObject, eventdata, handles)
% hObject    handle to binary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[nome,pat]=uiputfile( ...
    {'*.txt', 'All MATLAB Files (*txt)'; ...
    '*.*',                   'All Files (*.*)'}, ...
    'Write as',fullfile(pwd, handles.filename));
if isequal(nome,0) || isequal(pat,0), return; end

params_struct = struct('FileName', fullfile(pat, nome), 'statoF', 0, 'statoGH', 0, 'statoCAL', 0);
[final_txt_path, handles] = write_ascii_data(handles, params_struct);

% Salva il log in formato JSON chiamando la funzione dedicata
save_log_to_json(handles, final_txt_path);

end

%% SAVERED--------------------------------------------------------------------
function saveRED_Callback(hObject, eventdata, handles)
% hObject    handle to saveRED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pat0=pwd;
[nome,pat]=uiputfile( ...
    {'*.m;*.fig;*.mat;*.mdl', 'All MATLAB Files (*.m, *.fig, *.mat, *.mdl)'; ...
    '*.*',                   'All Files (*.*)'}, ...
    'Save as',fullfile(pat0, handles.filename));
if isequal(nome,0) || isequal(pat,0), return; end

% Recupera lo stato degli elementi della GUI
h_fluid = findobj('Tag', 'fluid');
statoF = get(h_fluid, 'Value');

h_GH = findobj('Tag', 'GH');
statoGH = get(h_GH, 'Value');
statoCAL = handles.Done;
 
params_struct = struct('Name', fullfile(pat, nome), 'statoF', statoF, 'statoGH', statoGH, 'statoCAL', statoCAL);
[mat_file_path, handles] = save_mat_data(handles, params_struct);

% Salva il log in formato JSON chiamando la funzione dedicata
save_log_to_json(handles, mat_file_path);

end
%% SAVE--------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pat0=pwd;
[nome,pat]=uiputfile( ...
    {'*.m;*.fig;*.mat;*.mdl', 'All MATLAB Files (*.m, *.fig, *.mat, *.mdl)'; ...
    '*.*',                   'All Files (*.*)'}, ...
    'Save as',fullfile(pat0, handles.filename));
if isequal(nome,0) || isequal(pat,0), return; end

params_struct = struct('Name', fullfile(pat, nome), 'statoF', 0, 'statoGH', 0, 'statoCAL', 0);
[mat_file_path, handles] = save_mat_data(handles, params_struct);

% Salva il log in formato JSON chiamando la funzione dedicata
save_log_to_json(handles, mat_file_path);

end
%% obj Callback
function cut_dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cut_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
% definisce il diametro interno ed esterno
function Rint_Callback(hObject, eventdata, handles)
% hObject    handle to Rint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
% --- Executes during object creation, after setting all properties.
function Rint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function Rext_Callback(hObject, eventdata, handles)
% hObject    handle to Rext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rext as text
%        str2double(get(hObject,'String')) returns contents of Rext as a double
end

% --- Executes during object creation, after setting all properties.
function Rext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in fluid.
function fluid_Callback(hObject, eventdata, handles)
% hObject    handle to fluid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fluid
end
% --- Executes during object creation, after setting all properties.
function edit1LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes during object creation, after setting all properties.
function edit2LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes during object creation, after setting all properties.
function edit3LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --------------------------------------------------------------------
function Figure_Callback(hObject, eventdata, handles)
% hObject    handle to Figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
% --- Executes on button press in slipON.
function slipON_Callback(hObject, eventdata, handles)
% hObject    handle to slipON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of slipON
end
% --- Executes on button press in GH.
function GH_Callback(hObject, eventdata, handles)
% hObject    handle to GH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GH

end
% --- Executes on button press in TC.
function TC_Callback(hObject, eventdata, handles)
% hObject    handle to TC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TC
end
function nodeEnc1_Callback(hObject, eventdata, handles)
% hObject    handle to nodeEnc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nodeEnc1 as text
%        str2double(get(hObject,'String')) returns contents of nodeEnc1 as a double
end
% --- Executes during object creation, after setting all properties.
function nodeEnc1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nodeEnc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function MaxEnc_Callback(hObject, eventdata, handles)
% hObject    handle to MaxEnc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxEnc as text
%        str2double(get(hObject,'String')) returns contents of MaxEnc as a double
end
% --- Executes during object creation, after setting all properties.
function MaxEnc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxEnc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function nodeEnc2_Callback(hObject, eventdata, handles)
% hObject    handle to nodeEnc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nodeEnc2 as text
%        str2double(get(hObject,'String')) returns contents of nodeEnc2 as a double
end
% --- Executes during object creation, after setting all properties.
function nodeEnc2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nodeEnc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function T0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function T0_Callback(hObject, eventdata, handles)
% hObject    handle to TT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TT as text
%        str2double(get(hObject,'String')) returns contents of TT as a double
end
% --- Executes during object creation, after setting all properties.
function TT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on button press in AdjRate.
function AdjRate_Callback(hObject, eventdata, handles)
% hObject    handle to AdjRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AdjRate
end
% --- Executes on button press in Torque.
function Torque_Callback(hObject, eventdata, handles)
% hObject    handle to Torque (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Torque
end
% --- Executes on button press in off_enc_0.
function off_enc_0_Callback(hObject, eventdata, handles)
% hObject    handle to off_enc_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = offset_encoder_zero(handles);
guidata(hObject, handles);
end
% --- Executes on button press in incremental.
function incremental_Callback(hObject, eventdata, handles)
% hObject    handle to incremental (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
% --- Executes on button press in vac.
function vac_Callback(hObject, eventdata, handles)
% hObject    handle to vac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vac
end
% --- Executes on button press in get_thickness.
function get_thickness_Callback(hObject, eventdata, handles)
% hObject    handle to get_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of get_thickness
end
function zero_thickness_long_Callback(hObject, eventdata, handles)
% hObject    handle to zero_thickness_long (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zero_thickness_long as text
%        str2double(get(hObject,'String')) returns contents of zero_thickness_long as a double
end
% --- Executes during object creation, after setting all properties.
function zero_thickness_long_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zero_thickness_long (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on selection change in popupAI6.
function popupAI6_Callback(hObject, eventdata, handles)
% hObject    handle to popupAI6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupAI6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupAI6
end
% --- Executes during object creation, after setting all properties.
function popupAI6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupAI6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on selection change in popupAI7.
function popupAI7_Callback(hObject, eventdata, handles)
% hObject    handle to popupAI7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupAI7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupAI7
end
% --- Executes during object creation, after setting all properties.
function popupAI7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupAI7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on selection change in popupAI8.
function popupAI8_Callback(hObject, eventdata, handles)
% hObject    handle to popupAI8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupAI8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupAI8
end
% --- Executes during object creation, after setting all properties.
function popupAI8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupAI8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on selection change in popupAI9.
function popupAI9_Callback(hObject, eventdata, handles)
% hObject    handle to popupAI9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupAI9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupAI9
end
% --- Executes during object creation, after setting all properties.
function popupAI9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupAI9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on selection change in popupAI10.
function popupAI10_Callback(hObject, eventdata, handles)
% hObject    handle to popupAI10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupAI10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupAI10
end
% --- Executes during object creation, after setting all properties.
function popupAI10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupAI10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on selection change in popupAI16.
function popupAI16_Callback(hObject, eventdata, handles)
% hObject    handle to popupAI16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupAI16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupAI16
end
% --- Executes during object creation, after setting all properties.
function popupAI16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupAI16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on selection change in popupAI17.
function popupAI17_Callback(hObject, eventdata, handles)
% hObject    handle to popupAI17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupAI17 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupAI17
end
% --- Executes during object creation, after setting all properties.
function popupAI17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupAI17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on selection change in popupPF.
function popupPF_Callback(hObject, eventdata, handles)
% hObject    handle to popupPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupPF contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupPF
end
% --- Executes during object creation, after setting all properties.
function popupPF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on selection change in popupAI18.
function popupAI18_Callback(hObject, eventdata, handles)
% hObject    handle to popupAI18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupAI18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupAI18
end
% --- Executes during object creation, after setting all properties.
function popupAI18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupAI18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on selection change in popupPC.
function popupPC_Callback(hObject, eventdata, handles)
% hObject    handle to popupPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupPC contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupPC
end
% --- Executes during object creation, after setting all properties.
function popupPC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes when uipanel1 is resized.
function uipanel1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
% --- Executes during object creation, after setting all properties.
function brutalfilt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brutalfilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on button press in get_thickness_short.
function get_thickness_short_Callback(hObject, eventdata, handles)
% hObject    handle to get_thickness_short (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of get_thickness_short
end
function zero_thickness_short_Callback(hObject, eventdata, handles)
% hObject    handle to zero_thickness_short (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zero_thickness_short as text
%        str2double(get(hObject,'String')) returns contents of zero_thickness_short as a double
end
% --- Executes during object creation, after setting all properties.
function zero_thickness_short_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zero_thickness_short (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'));
    set(hObject,'BackgroundColor','white');
end
end

%% refresh temperature callback
% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
disp('Refresh temperature!')

% 1. Raccogli i parametri dalla UI
AIstate=zeros(1,18);
for L=1:18
    h_ai = findobj('Tag',['popupAI',num2str(L)]);
    if ~isempty(h_ai)
        AIstate(L) = get(h_ai,'Value');
    end
end

% 2. Chiama la funzione esterna
params_struct = struct('AI_states', AIstate);
handles = recalculate_temperature(handles, params_struct);

guidata(hObject, handles);
plotta_ora(handles);
end

%% refresh_tau callback
% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1. Raccogli i parametri dalla UI
rint = str2double(get(findobj('Tag','Rint'),'String'))/2000;
rext = str2double(get(findobj('Tag','Rext'),'String'))/2000;
calibration_index = get(findobj('Tag','calibration'),'Value');
is_GH = get(findobj('Tag','GH'),'Value');
pf_index = get(findobj('Tag','popupPF'),'Value');

% 2. Chiama la funzione esterna
params_struct = struct('rint', rint, 'rext', rext, 'calibration_index', calibration_index, 'is_GH', is_GH, 'pf_index', pf_index);
handles = recalculate_stress(handles, params_struct);

% 3. Aggiorna la UI
set(findobj('Tag','edit1LB'),'String',handles.column);
set(findobj('Tag','edit2LB'),'String',handles.column);
set(findobj('Tag','edit3LB'),'String',handles.column);

guidata(hObject, handles);
plotta_ora(handles);
end

%% calibrate callback
% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to calibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1. Raccogli i parametri dalla UI di GUIDE
cal_params = struct();
cal_params.rint = str2double(get(findobj('Tag','Rint'),'String'))/2000;
cal_params.rext = str2double(get(findobj('Tag','Rext'),'String'))/2000;
cal_params.calibration_index = get(findobj('Tag','calibration'),'Value');
cal_params.node1_str = get(findobj('Tag','nodeEnc1'),'String');
cal_params.node2_str = get(findobj('Tag','nodeEnc2'),'String');
cal_params.is_GH = get(findobj('Tag','GH'),'Value');
cal_params.is_TC = get(findobj('Tag','TC'),'Value');
cal_params.is_vac = get(findobj('Tag','vac'),'Value');
cal_params.is_thickness = get(findobj('Tag','get_thickness'),'Value');
cal_params.ztl = str2double(get(findobj('Tag','zero_thickness_long'),'String'));
cal_params.zts = str2double(get(findobj('Tag','zero_thickness_short'),'String'));
cal_params.is_gefran = get(findobj('Tag','Gefran'),'Value');
cal_params.is_adjrate = get(findobj('Tag','AdjRate'),'Value');
cal_params.is_torque_ctrl = get(findobj('Tag','Torque'),'Value');
cal_params.popup_PF_index = get(findobj('Tag','popupPF'),'Value');
cal_params.popup_PC_index = get(findobj('Tag','popupPC'),'Value');
cal_params.is_incremental = get(findobj('Tag','incremental'),'Value');

cal_params.AI_states = zeros(1,18);
for L=1:18
    h_ai = findobj('Tag',['popupAI',num2str(L)]);
    if ~isempty(h_ai)
        cal_params.AI_states(L) = get(h_ai,'Value');
    end
end

% 2. Chiama la funzione di calibrazione esterna
% Chiede all'utente i nomi dei vettori Isco se necessario (separatamente per PF e PC)
if cal_params.popup_PF_index == 4 % IscoPump per Pressione dei Pori
    isco_pump_pf_vector_name = inputdlg('Enter the exact name of the Isco Pump vector for Pore Fluid:', 'Isco Pump PF Vector', [1 50]);
    if ~isempty(isco_pump_pf_vector_name)
        cal_params.isco_pump_pf_vector_name = isco_pump_pf_vector_name{1};
    else
        cal_params.isco_pump_pf_vector_name = ''; % L'utente ha annullato o lasciato vuoto
    end
end

if cal_params.popup_PC_index == 4 % IscoPump per Pressione di Confinamento
    isco_pump_pc_vector_name = inputdlg('Enter the exact name of the Isco Pump vector for Confining Pressure:', 'Isco Pump PC Vector', [1 50]);
    if ~isempty(isco_pump_pc_vector_name)
        cal_params.isco_pump_pc_vector_name = isco_pump_pc_vector_name{1};
    else
        cal_params.isco_pump_pc_vector_name = ''; % L'utente ha annullato o lasciato vuoto
    end
end
handles = calibrate_data(handles, cal_params);

% 3. Aggiorna la UI
h_ = findobj('Tag','edit1LB'); set(h_,'String',handles.column);
h_ = findobj('Tag','edit2LB'); set(h_,'String',handles.column);
h_ = findobj('Tag','edit3LB'); set(h_,'String',handles.column);

guidata(hObject, handles);
plotta_ora(handles);
end

%% FIT
function brutalfilt_Callback(hObject, eventdata, handles)
% hObject    handle to brutalfilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of brutalfilt as text
%        str2double(get(hObject,'String')) returns contents of brutalfilt as a double

filter_param = str2num(get(hObject,'String'));
if isempty(filter_param); filter_param = 500; end

disp('Select an axis to apply brutal filter...');
ginput(1)
ax_=get(gcf,'CurrentAxes');
[~, axis_idx] = ismember(ax_, [handles.axes1, handles.axes2, handles.axes3]);

if axis_idx > 0
    h_ = findobj('Tag', ['edit' num2str(axis_idx)]);
    col_idx = str2double(get(h_, 'String'));

    params_struct = struct('column_index', col_idx, 'filter_param', filter_param);
    handles = apply_brutal_filter(handles, params_struct);

    % Update the list boxes
    h_ = findobj('Tag','edit1LB'); set(h_,'String',handles.column);
    h_ = findobj('Tag','edit2LB'); set(h_,'String',handles.column);
    h_ = findobj('Tag','edit3LB'); set(h_,'String',handles.column);
end

guidata(hObject, handles);
plotta_ora(handles);
end
% --- Executes on button press in filtvel.
function filtvel_Callback(hObject, eventdata, handles)
% hObject    handle to filtvel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1. User interaction to get the transition index
transition_index = [];
if isfield(handles, 'XIin')
    response = questdlg('A transition index already exists. Change it?', 'Filter Velocity', 'Yes', 'No', 'No');
    if strcmp(response, 'No')
        transition_index = handles.XIin;
    end
end

if isempty(transition_index)
    hf = figure;
    plot(handles.Slip_Enc_1); hold on; plot(handles.Slip_Enc_2);
    title('Select the transition point between Encoder 1 and 2');
    zoom on;
    waitfor(hf, 'CurrentCharacter', char(13)); % Wait for Enter key
    [xi, ~] = ginput(1);
    transition_index = round(xi);
    handles.XIin = transition_index;
    close(hf);
end

% 2. Call the external function
params_struct = struct('transition_index', transition_index);
handles = filter_velocity(handles, params_struct);

% 3. Update UI
if ~any(strcmp(handles.column, 'velF'))
    handles.column{end+1} = 'velF';
    handles.column{end+1} = 'slipF';
    h_ = findobj('Tag','edit1LB'); set(h_,'String',handles.column);
    h_ = findobj('Tag','edit2LB'); set(h_,'String',handles.column);
    h_ = findobj('Tag','edit3LB'); set(h_,'String',handles.column);
end

guidata(hObject, handles);
plotta_ora(handles);
end
%{
esi=0;
sin='n';
if any(strcmp(fieldnames(handles),'XIin'));
    esi=1;
    sin=input('vuoi cambiarlo? ','s');
end
    if sin=='y' | esi==0
hf=figure; plot(handles.Slip_Enc_1); hold on; plot(handles.Slip_Enc_2);
a=zoom; a.Enable='on'
waitfor(a, 'Enable','off') 
[XIin,YIin]=ginput(1);
handles.XIin=XIin;
close(hf)
    end
ya=handles.Slip_Enc_1(:,1);
yb=handles.Slip_Enc_2(:,1);
xt=handles.Time/1000;
slip1=filtravel_shiva(ya, xt, 50,2); 
slip2=filtravel_shiva(yb, xt, 5,2); 

slip=slip1; slip(handles.XIin:end)=slip2(handles.XIin:end);
figure; 
plot(handles.SlipVel_Enc_1,'y'); hold on; plot(handles.SlipVel_Enc_2,'r');

vel=diff(slip)./diff(xt); vel(end+1)=vel(end); 
handles.velF=vel;
handles.slipF=slip;
plot(vel,'k');
%}

%% calculate gouge layer thickness
% --- Executes on button press in refresh_thickness.
function refresh_thickness_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 1. Raccogli i parametri dalla UI
is_thickness_checked = get(findobj('Tag','get_thickness'),'Value');
if ~is_thickness_checked
    disp('Thickness calculation skipped because the checkbox is not selected.');
    return;
end

ztl = str2double(get(findobj('Tag','zero_thickness_long'),'String'));
zts = str2double(get(findobj('Tag','zero_thickness_short'),'String'));

% 2. Chiama la funzione esterna
params_struct = struct('ztl', ztl, 'zts', zts);
handles = recalculate_thickness(handles, params_struct);

% 3. Aggiorna la UI
set(findobj('Tag','edit1LB'),'String',handles.column);
set(findobj('Tag','edit2LB'),'String',handles.column);
set(findobj('Tag','edit3LB'),'String',handles.column);

guidata(hObject, handles);
plotta_ora(handles);
end
%% generate unwrap
% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Chiama la funzione esterna
handles = unwrap_encoder(handles);

guidata(hObject, handles);
plotta_ora(handles)
end
%% funzioni di utilità

function ll=trovaasse(asse,xi)

Xax1=findobj(asse,'Type','line');
t_cut=Xax1(1).XData;
mat(1,:)=abs(t_cut-ones(size(t_cut))*xi(1));
ll(:,1)=find(mat(1,:)==min(mat(1,:)));

end

function X=trovadataX(asse)

h_ele1=findobj(asse,'Type','line');
X=h_ele1(1).XData;
end
