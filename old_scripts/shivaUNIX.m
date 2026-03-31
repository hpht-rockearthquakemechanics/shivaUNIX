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
    'Write as',['~/',handles.filename]);
cd (pat)


h_=findobj('Tag','fluid');
statoF=get(h_,'Value');
h_=findobj('Tag','GH');
statoGH=get(h_,'Value');

if statoF==1
    I={'Time' 'shear1' 'EffPressure' 'Mu1' 'Pf' 'LVDT_low' 'LVDT_high' 'vel' 'slip' 'TempE' 'TempM'};
elseif statoGH==1
    I={'Time' 'shear1' 'Normal' 'Mu1' 'dspring' 'LVDT_low' 'vel' 'slip' 'TempE' 'TempM'};
else
    I={'Time' 'shear1' 'Normal' 'Mu1' 'LVDT_low' 'vel' 'slip' 'TempE'};
end

for j=1:length(I); %1:length(handles.column)
    C(j,1)={'%10.6f '};
    if j==length(I)
        C(j,1)={'%10.6f\n'};
    end
end
C1=cell2mat(C');

for j=1:length(I); %1:length(handles.column)
    N(j,1)={['handles.' I{j} '(l,1),']};
    if j==length(I)
        N(j,1)={['handles.' I{j} '(l,1)']};
    end
end
N1=cell2mat(N');


for j=1:length(I); %1:length(handles.column)
    M(j,1)={['''' I{j} '''' ',']};
    if j==length(I)
        M(j,1)={['''' I{j} '''']};
    end
end
M1=cell2mat(M');

%for j=1:length(handles.column)
%    O(j,1)={['''v' num2str(j) '''' ',']};
%    if j==length(handles.column)
%         O(j,1)={['''v' num2str(j) '''']};
%    end
%end
%O1=cell2mat(O');


for j=1:length(I); %1:length(handles.column)
    S(j,1)={'%s '};
    if j==length(I)
        S(j,1)={'%s\n'};
    end
end
S1=cell2mat(S');

%write in a file
nome2=[nome, 'RED.txt'];
fid = fopen(nome2,'wt');
eval(['fprintf(fid,''' S1 ''',' M1 ');'])

eval(['len=length(handles.' handles.column{1} ');'])

for l=1:len
    eval(['fprintf(fid,''' C1 ''',' N1 ');'])
end
fclose(fid);
if ~ strcmp(fieldnames(handles),'dt'); msgbox(['ATTENTION: handles.dt=none']); end
end

%% OPEN --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%ripulisci precedente

ah_=get(handles.axes1,'children'); set(ah_,'XData',[],'YData',[]);
ah_=get(handles.axes2,'children'); set(ah_,'XData',[],'YData',[]);
ah_=get(handles.axes3,'children'); set(ah_,'XData',[],'YData',[]);

I=strcmp(fieldnames(handles),'column');

if any(I)
    for i=1:length(handles.column)
        eval(['handles=rmfield(handles,''', handles.column{i}, ''');'])
    end
    handles=rmfield(handles,'column');
    
end

fname=fieldnames(handles);
I=strfind(fname,'GEF');
if any(cell2mat(I))
    for i=1:length(fname)
        if ~isempty(strfind(fname{i},'GEF'));
            eval(['handles=rmfield(handles,''', fname{i}, ''');'])
        end
    end
end


handles.load=0; % flag su load o open
clear file1
I=strcmp(fieldnames(handles),'new'); if any(I); handles=rmfield(handles,'new'); end
I=strcmp(fieldnames(handles),'X'); if any(I); handles=rmfield(handles,'X'); end
I=strcmp(fieldnames(handles),'TimeZero'); if any(I); handles=rmfield(handles,'TimeZero'); end



%definisce i grafici da plottare:
%qui ci sono i default
handles.g1=2;
handles.g2=3;
handles.g3=5;

ax_=findobj('Tag','edit1'); set(ax_,'String',handles.g1);
ax_=findobj('Tag','edit2'); set(ax_,'String',handles.g2);
ax_=findobj('Tag','edit3'); set(ax_,'String',handles.g3);

[FileName,PathName] = uigetfile('*.*','All Files (*.*)', ...
    'C:\Users\stear\Dropbox\Ricerca\SHIVA');


cd (PathName)

%definisce i parametri da matrice
%handles.column=importdata(FileName,'\t',1);

fid=fopen(FileName,'r');
for i=1:3
    file1=fgets(fid);
end
fclose(fid);


%file0=importdata(FileName,'\t',3);file1=char(file0(3,:));
[I]=find(file1==char(44)); change=logical(0);
if ~isempty(I); file1(I)=char(46); change=logical(1); end
A=sscanf(file1,'%f');
b=length(A); clear A
fid=fopen(FileName,'r');

for i=1:b
    A=fscanf(fid,'%s',1);
    %controlla che non interpreti uno spazio come nuova variabile
    if any(strcmp(fieldnames(handles),'column')) && ...
            strcmp(A,2); handles.column{i-1}={[char(handles.column(i-1)), '2']};
    else handles.column(i)={A};
    end
    %controlla che non ce ne siano due uguali
    S=sum(strcmp(handles.column(i), handles.column));
    if S > 1; handles.column{i}=([char(handles.column(i)), '2']); end
    
end

fgets(fid);    fgets(fid); i=0;
if change
    while 1
        i=i+1;
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        [I]=find(tline==char(44));
        if ~isempty(I); tline(I)=char(46); end
        file1.data(i,:)=sscanf(tline,'%f');
    end
else
    file1=importdata(FileName,'\t',3);
end
fclose(fid);

h_=findobj('Tag','dt_value');

handles.filename=FileName;

handles.sm=0;
handles.triggered=0;
handles.cutted=[0 0];
handles.loadT=0;
handles.shearT=0;
ll=1;
nn=length(file1.data(:,1));

%primo step:togliere tutto quello che ha un campionamento diverso da dt
%handles.xlab=0:handles.dt:(length(file1.data)-1)*handles.dt;
%memorizza anche gli originali
%eval(['handles.' handles.column{1} ' = cumsum(file1.data(ll:nn,1)); '])
%eval(['handles.v' num2str(1) ' = cumsum(file1.data(ll:nn,1)); '])
handles.column{1}='Time';
num=length(handles.column);

for n=2:num
    test=double(handles.column{n});
    if any(test==32); handles.column{n}=char(test(test~=32)); end
    eval(['handles.' handles.column{n} ' = file1.data(ll:nn,' num2str(n) ');'])
end


handles.column{num+1}='Stamp';
eval(['handles.' handles.column{num+1} '= file1.data(ll:nn,1); '])

num=length(handles.column);
handles.column{num+1}='Rate';
eval(['handles.' handles.column{num+1} '= [1:1:length(file1.data(ll:nn,1))]''; '])


num=length(handles.column);
handles.column{num+1}='RateZero';
eval(['handles.' handles.column{num+1} '= [1:1:length(file1.data(ll:nn,1))]''; '])

% --> ele

hv=get(handles.XLab(1),'Value');
handles.TimeZero=cumsum(handles.Stamp);
handles.Time=zeros(size(handles.Stamp));
handles.Time(1)=hv*handles.Stamp(1);
handles.Time(2:end)=hv*handles.Stamp(1) +cumsum(handles.Stamp(2:end)); %plotto il numero di riga

handles.Done=[];

handles.tconv = 1000; %<--- Corrections for time conversion in velocity calculation!

guidata(hObject, handles);
handles.zoom=0;

plotta_ora(handles);
end

function OpenMenuItem2_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%ripulisci precedente

ah_=get(handles.axes1,'children'); set(ah_,'XData',[],'YData',[]);
ah_=get(handles.axes2,'children'); set(ah_,'XData',[],'YData',[]);
ah_=get(handles.axes3,'children'); set(ah_,'XData',[],'YData',[]);

I=strcmp(fieldnames(handles),'column');

if any(I)
    for i=1:length(handles.column)
        eval(['handles=rmfield(handles,''', handles.column{i}, ''');'])
    end
    handles=rmfield(handles,'column');
    
end

fname=fieldnames(handles);
I=strfind(fname,'GEF');
if any(cell2mat(I))
    for i=1:length(fname)
        if ~isempty(strfind(fname{i},'GEF'));
            eval(['handles=rmfield(handles,''', fname{i}, ''');'])
        end
    end
end


handles.load=0; % flag su load o open
clear file1
I=strcmp(fieldnames(handles),'new'); if any(I); handles=rmfield(handles,'new'); end
I=strcmp(fieldnames(handles),'X'); if any(I); handles=rmfield(handles,'X'); end
I=strcmp(fieldnames(handles),'TimeZero'); if any(I); handles=rmfield(handles,'TimeZero'); end



%definisce i grafici da plottare:
%qui ci sono i default
handles.g1=2;
handles.g2=3;
handles.g3=5;

ax_=findobj('Tag','edit1'); set(ax_,'String',handles.g1);
ax_=findobj('Tag','edit2'); set(ax_,'String',handles.g2);
ax_=findobj('Tag','edit3'); set(ax_,'String',handles.g3);

[FileName,PathName] = uigetfile('*.*','All Files (*.*)', ...
    '~/Documents/Roma/Raw lab data');


cd (PathName)

%definisce i parametri da matrice
%handles.column=importdata(FileName,'\t',1);

fid=fopen(FileName,'r');
for i=1:3
    file1=fgets(fid);
end
fclose(fid);


%file0=importdata(FileName,'\t',3);file1=char(file0(3,:));
[I]=find(file1==char(44)); change=false;
if ~isempty(I); file1(I)=char(46); change=true; end
A=sscanf(file1,'%f');
b=length(A); clear A
fid=fopen(FileName,'r');

for i=1:b
    A=fscanf(fid,'%s',1);
    %controlla che non interpreti uno spazio come nuova variabile
    if any(strcmp(fieldnames(handles),'column')) && ...
            strcmp(A,2); handles.column{i-1}={[char(handles.column(i-1)), '2']};
    else
        handles.column(i)={A};
    end
    %controlla che non ce ne siano due uguali
    S=sum(strcmp(handles.column(i), handles.column));
    if S > 1; handles.column{i}=([char(handles.column(i)), '2']); end
    
end

fgets(fid);    fgets(fid); i=0;
if change
    while 1
        i=i+1;
        tline = fgetl(fid);
        if ~ischar(tline); break; end
        [I]=find(tline==char(44));
        if ~isempty(I); tline(I)=char(46); end
        file1.data(i,:)=sscanf(tline,'%f');
    end
else
    file1=importdata(FileName,'\t',3);
end
fclose(fid);

h_=findobj('Tag','dt_value');

%[ndt,vdt]=grp2idx(file1.data(:,1));
%if numel(vdt) > 1; handles.dt=str2double(vdt(2));
%else
%    handles.dt=str2double(vdt(1))
%end


%set(h_,'String',handles.dt);

handles.filename=FileName;

handles.sm=0;
handles.triggered=0;
handles.cutted=[0 0];
handles.loadT=0;
handles.shearT=0;
ll=1;
nn=length(file1.data(:,1));
timess = file1.data(:,1);
if max(timess)>60 || min(timess)>0.7
    disp('Time is in Milliseconds')
    tconv = 1;
elseif max(timess)<60 || min(timess)<0.7
    disp('Time is in seconds')
    tconv = 1000;
else
    disp('Unable to ascertain time units')
end
%primo step:togliere tutto quello che ha un campionamento diverso da dt
%handles.xlab=0:handles.dt:(length(file1.data)-1)*handles.dt;
%memorizza anche gli originali
%eval(['handles.' handles.column{1} ' = cumsum(file1.data(ll:nn,1)); '])
%eval(['handles.v' num2str(1) ' = cumsum(file1.data(ll:nn,1)); '])


handles.column{1}='Time';
num=length(handles.column);

for n=2:num
    test=double(handles.column{n});
    if any(test==32)
        handles.column{n}=char(test(test~=32));
    end
    eval(strcat('handles.',handles.column{n}, '= file1.data(ll:nn,', num2str(n), ');'))
end



handles.column{num+1}='Stamp';
eval(['handles.' handles.column{num+1} '= file1.data(ll:nn,1);'])

num=length(handles.column);
handles.column{num+1}='Rate';
eval(['handles.' handles.column{num+1} '= [1:1:length(file1.data(ll:nn,1))]''; '])

num=length(handles.column);
handles.column{num+1}='RateZero';
eval(['handles.' handles.column{num+1} '= [1:1:length(file1.data(ll:nn,1))]''; '])

% --> ele
hv=get(handles.XLab(1),'Value');
handles.TimeZero=cumsum(handles.Stamp);
handles.Time=zeros(size(handles.Stamp));
handles.Time(1)=hv*handles.Stamp(1);
handles.Time(2:end)=hv*handles.Stamp(1) +cumsum(handles.Stamp(2:end)); %plotto il numero di riga

handles.Done=[];
handles.Time=handles.Time*tconv;
handles.tconv=tconv;

guidata(hObject, handles);
handles.zoom=0;

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

h_ele=get(hObject,'Value')
handles.X=trovadataX(handles.axes1)

guidata(hObject, handles);

plotta_ora(handles)
end


% --- Executes on button press in offset.
function offset_Callback(hObject, eventdata, handles)
% hObject    handle to offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to offset_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[sel,v] = listdlg('PromptString','Select a file:',...
    'SelectionMode','multiple',...
    'ListString',handles.column);

h_=handles.column(sel);
hOb=findobj('Tag','XLab');
h_ele=get(hOb,'Value');
htype=get(hOb,'String');
[xi,yi]=ginput(1) ;
ll=trovaasse(handles.axes1,xi)

ax_=get(gcf,'CurrentAxes');
for n=1:3
    eval(['s=find(ax_==handles.axes' num2str(n) ');'])
    if s==1; break; end
end
posy=get(ax_,'Ylim');
posx=get(ax_,'Xlim');

eval(['h_=findobj(''Tag'',''edit' num2str(n) ''');']); %n=numero asse
colonna=str2double(get(h_,'String'));                        %numero della colonna

for n=sel
    eval(['handles.' handles.column{n} ' =handles.' handles.column{n} '-handles.' handles.column{n} '(ll(:,1),:);'])
    %eval(['handles.' handles.column{n} '(1:ll(:,1),:)=0;'])
end

nsel=find(strcmp(handles.column(sel),'Axial'));
if isempty(nsel)
    handles.shearT=handles.RateZero(ll);
else
    handles.loadT=handles.RateZero(ll);
end

h_=findobj('Tag','edit1');
s1=str2double(get(h_,'String'));
h_=findobj('Tag','edit2');
s2=str2double(get(h_,'String'));
h_=findobj('Tag','edit3');
s3=str2double(get(h_,'String'));

guidata(hObject, handles);
plotta_ora(handles)
end




% --- Executes on button press in trigger.
function trigger_Callback(hObject, eventdata, handles)
% hObject    handle to trigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hOb=findobj('Tag','XLab');
h_ele=get(hOb,'Value');
t_cut=trovadataX(handles.axes1);

A=find(strcmp(fieldnames(handles),'shearT'));
if isempty(A)
    [xi,yi]=ginput(1) ;
    mat(1,:)=abs(t_cut-ones(size(t_cut))*xi(1));
    ll(:,1)=find(mat(1,:)==min(mat(1,:)));
else
    prev_trig=find(handles.RateZero==handles.shearT);
    k=menu(['trigger is' num2str(handles.shearT) '. Is that ok?'],'si','no','man');
    
    if (k==1)
        ll(:,1)=prev_trig;
    elseif (k==2)
        [xi,yi]=ginput(1) ;
        mat(1,:)=abs(t_cut-ones(size(t_cut))*xi(1));
        ll(:,1)=find(mat(1,:)==min(mat(1,:)));
    elseif (k==3)
        t_cut=handles.XLab;
        [xi]=input('digit a triggering number here = ') ;
        mat(1,:)=abs(t_cut-ones(size(t_cut))*xi(1));
        ll(:,1)=find(mat(1,:)==min(mat(1,:)));
        
    end
end
handles.triggered=handles.RateZero(ll);

%cycle if running in t=0
%for n=1:length(handles.column)
I(1)=find(strcmp(handles.column,'Rate'));

%for n=I
%eval(['handles.' handles.column{n} ' =handles.' handles.column{n} '-handles.' handles.column{n} '(ll(:,1),:);'])
%endhandle
handles.Time=handles.Time-handles.Time(ll(:,1),:);

set(hOb,'Value',2)


ax_=get(handles.axes1,'Children'); dataY=get(ax_,'YData'); dataX=get(ax_,'XData');
set(ax_,'XData',handles.Time,'YData',dataY); set(handles.axes1,'XLim',[handles.Time(1) handles.Time(end)]);
ax_=get(handles.axes2,'Children'); dataY=get(ax_,'YData'); dataX=get(ax_,'XData');
set(ax_,'XData',handles.Time,'YData',dataY); set(handles.axes1,'XLim',[handles.Time(1) handles.Time(end)]);
ax_=get(handles.axes3,'Children'); dataY=get(ax_,'YData'); dataX=get(ax_,'XData');
set(ax_,'XData',handles.Time,'YData',dataY); set(handles.axes1,'XLim',[handles.Time(1) handles.Time(end)]);

guidata(hObject, handles);
plotta_ora(handles)
end




%% --- Executes on button press in decimate.
function decimate_Callback(hObject, eventdata, handles)
% hObject    handle to decimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~any(strcmp(fieldnames(handles),'column')); err=msgbox('no data stored!'); waitfor(err); return; end

set(hObject,'Enable','on','BackGroundColor','white')
handles.Ndec=str2num(get(hObject,'String'))
%if any(strcmp(fieldnames(handles),'dec')); k=menu('decimate again?','yes','no');end
%if k==1
for n=1:length(handles.column)
    eval(['handles.' handles.column{n} ' = downsample(handles.' handles.column{n} ',' num2str(handles.Ndec) ');'])
end

%elseif k==2
%    return
%end

handles.dec='ok';

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

set(hObject,'Enable','on','BackGroundColor','white')
handles.sm=str2num(get(hObject,'String'));

if isempty(handles.sm); handles.sm=500; end
ginput(1)
ax_=get(gcf,'CurrentAxes');

for n=1:3
    eval(['s=find(ax_==handles.axes' num2str(n) ');'])
    if s==1; break; end
end
finestra=n;

posy=get(ax_,'Ylim');
posx=get(ax_,'Xlim');

eval(['h_=findobj(''Tag'',''edit' num2str(n) ''');']); %n=numero asse
s=str2double(get(h_,'String'));  %numero della colonna

%if any(strcmp(handles.column,{[handles.column{s} 'o']}));
%s=find(strcmp(handles.column,{[handles.column{s} 'o']}));
%end

%running mean
eval(['pippo=(handles.' handles.column{s} ');']);
if (handles.sm)/2==floor(handles.sm/2); handles.sm=handles.sm+1; end %check sul numero dispari
l=(handles.sm-1)/2; %es:(101-1)/2=50;

pm=pippo(l+1:length(pippo)-l);
for i=l+1:length(pippo)-l;
    pm(i-l)=sum(pippo(i-l:i+l));
end
pippo(l+1:length(pippo)-l)=pm/(handles.sm);

%windowSize = handles.sm;
%pm2=filter(ones(1,windowSize)/windowSize,1,pippo);
%smooths data Y using a handles.sm -point moving average.
%eval(['handles.' handles.column{s} '=smooth(handles.' handles.column{s} ',handles.sm);'])

eval(['handles.' handles.column{s} 'o=handles.' handles.column{s} ';'])
eval(['handles.' handles.column{s} '=pippo;'])
if ~strcmp(handles.column,{[handles.column{s} 'o']});
    handles.column(end+1)={[handles.column{s} 'o']};
end


%handles.g1=find(strcmp(handles.column,{[handles.column{s} 'smooth']}));

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
set(hObject,'Enable','on')


handles.dt=str2double(get(hObject,'String'));
%set(hObject,'String',handles.dt,'BackgroundColor',[0.75 0.75 0.75])
ll=find(handles.Stamp(:,1)==handles.dt); %,1,'first');
if length(ll) <= 100; h=msgbox('attention: number of residuals less than 100'); waitfor(h); return; end
%nn=find(handles.Stamp(:,1)==handles.dt,1,'last');

for n=1:length(handles.column)
    eval(['handles.' handles.column{n} ' = handles.' handles.column{n} '(ll,1);'])
end

set(hObject,'String','cut_dt')
guidata(hObject, handles);
plotta_ora(handles)
end
% --- Executes during object creation, after setting all properties.



%% --- Executes on button press in cut.
function cut_Callback(hObject, eventdata, handles)
% hObject    handle to cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hOb=findobj('Tag','XLab');
h_ele=get(hOb,'Value');
t_cut=trovadataX(handles.axes1);

%left to right clicking sequence on plot
[xi,yi]=ginput(2) ;

mat(1,:)=abs(t_cut-ones(size(t_cut))*xi(1));
mat(2,:)=abs(t_cut-ones(size(t_cut))*xi(2));
ll(:,1)=find(mat(1,:)==min(mat(1,:)));
ll(:,2)=find(mat(2,:)==min(mat(2,:)));

handles.cutted(1,1)=handles.RateZero(ll(1,1));
handles.cutted(1,2)=handles.RateZero(ll(1,2));

for n=1:length(handles.column)
    eval(['handles.' handles.column{n} ' =handles.' handles.column{n} '(ll(:,1):ll(:,2),:);' ])
end


guidata(hObject, handles);
plotta_ora(handles)
end

%% --- Executes on button press in fft.
function fft_Callback(hObject, eventdata, handles)
% hObject    handle to fft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hOb=findobj('Tag','XLab');
h_ele=get(hOb,'Value');
t_cut=trovadataX(handles.axes1);

ax_=get(gcf,'CurrentAxes');

ginput(1)
for n=1:3
    eval(['s=find(ax_==handles.axes' num2str(n) ');'])
    if s==1; break; end
end
finestra=n;

ax_=get(gcf,'CurrentAxes');
posy=get(ax_,'Ylim');
posx=get(ax_,'Xlim');
I1=find(abs(t_cut-posx(1))==min(abs(t_cut-posx(1))));
I2=find(abs(t_cut-posx(2))==min(abs(t_cut-posx(2))));

eval(['h_=findobj(''Tag'',''edit' num2str(n) ''');']); %n=numero asse
s=str2double(get(h_,'String'));  %numero della colonna

eval(['mmed_torq=mean(smooth(handles.' handles.column{s} '(1:100,:)));']);
eval(['handles.' handles.column{s} '=handles.' handles.column{s} '- mmed_torq;']);

%tapering

eval(['handles.' handles.column{s} '=handles.' handles.column{s} '(I1:I2).*hamming(length(handles.Stamp(I1:I2)));'])
dt=mode(handles.Stamp(I1:I2)); %str2double(get(h_,'String'));

nfft=4096;
eval(['Y =fft(handles.' handles.column{s} ',' num2str(nfft) ');'])
f = 1000/dt*(0:nfft/2)/nfft;
Pyy = Y.* conj(Y) / nfft;

plot(f,Pyy(1:nfft/2+1),'Parent',handles.axes4);
set(handles.axes4,'XLim',[0 250])

plot(1./f*1000/dt,Pyy(1:nfft/2+1),'Parent',handles.axes5);
set(handles.axes5,'XLim',[0 500])

set(hObject,'Value',0)
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
stato=get(hObject,'Value');

if stato==1
    ButtonName = questdlg('GEFRAN preliminary operations: (1) identify the main sampling rate with cut_dt (2) decimate the data to 1s', ...
        'Do you want to proceed now?', 'No', 'Yes','No');
    
    switch ButtonName,
        case 'No',
            disp('no');
            set(hObject,'Value',0);
        case 'Yes',
            
            I=find(~strcmp(handles.column,'SpeedGEF')); handles.column=handles.column(I);
            I=find(~strcmp(handles.column,'timeGEF')); handles.column=handles.column(I);
            I=find(~strcmp(handles.column,'TorqueGEF')); handles.column=handles.column(I);
            
            Path2='/media/disk1/shivadir/Shiva Experiments';
            name=handles.filename(1:4);
            
            list=dir([Path2 '/' name '*']);
            if ~isempty(list); Path2=[Path2 '/' list.name '/'];
                name2=dir([Path2 '*.txt']);
                FileGEF=name2.name;
            else
                [FileGEF,Path2] = uigetfile( '/media/disk1/shivadir/*.txt', ...
                    'Multiple File Detected: Select the file GEFRAN to load');
                name2='';
            end
            
            
            gefran1=1; k=0 ;
            while ~isstruct(gefran1)
                k=k+1;
                gefran1=importdata([Path2 '/' FileGEF],'\t',k);
            end
            
            I=find(strncmp(gefran1.textdata,'Time	Speed',6)); if ~isempty(I); new.timeGEF=gefran1.data(:,1); new.VGEF(:,1)=gefran1.data(:,2); end
            I=find(strncmp(gefran1.textdata,'Act Torque',6)); if ~isempty(I); new.TqGEF(:,1)=gefran1.data(:,I(1)-1); end
            I=find(strncmp(gefran1.textdata,'Speed',5)); if ~isempty(I); new.VGEF(:,1)=gefran1.data(:,I(1)-1); end
            I=find(strncmp(gefran1.textdata,'time',4)); if ~isempty(I); new.timeGEF(:,1)=gefran1.data(:,I(1)-1); end
            
            dt=diff(new.timeGEF); dt(end+1)=dt(1);
            
            %for j=1:length(handles.column);
            %    eval(['new.' handles.column{j} '= downsample(handles.' handles.column{j} ',' num2str(25) ');'])
            %end
            %dati di calibrazione
            
            nomi=[];
            [a,b]=size(handles.column); [aa,bb]=size(fieldnames(new));
            inp1=handles.column;
            if aa==1 & aa==b | bb==1 & a==1; inp1=handles.column'; end
            nomi=[inp1 ; fieldnames(new)];
            
            handles.column=[];
            handles.column=nomi';
            nomi2=fieldnames(new);
            
            for k=1:length(nomi2)
                eval(['handles.' char(nomi2(k)) '=new.' char(nomi2(k)) ';'])
            end
            
            guidata(hObject, handles);
            
    end
end % switch
end

%%%%%%%%%%% fine GEF

%% --- Executes on button press in running.
function running_Callback(hObject, eventdata, handles)
% hObject    handle to running (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hOb=findobj('Tag','XLab');
h_ele=get(hOb,'Value');
t_cut=trovadataX(handles.axes1)
[xi,yi]=ginput(2) ;
mat(1,:)=abs(t_cut-ones(size(t_cut))*xi(1));
mat(2,:)=abs(t_cut-ones(size(t_cut))*xi(2));
ll(:,1)=find(mat(1,:)==min(mat(1,:)));
ll(:,2)=find(mat(2,:)==min(mat(2,:)));

ax_=get(gcf,'CurrentAxes');
for n=1:3
    eval(['s=find(ax_==handles.axes' num2str(n) ');'])
    if s==1; break; end
end
finestra=n;
posy=get(ax_,'Ylim');
posx=get(ax_,'Xlim');

eval(['h_=findobj(''Tag'',''edit' num2str(n) ''');']); %n=numero asse
s=str2double(get(h_,'String'));                        %numero della colonna

%cla

eval(['mmed_torq=mean(smooth(handles.' handles.column{s} '(ll(:,1):ll(:,2),:)));']);
eval(['handles.' handles.column{s} '=handles. ' handles.column{s} '- mmed_torq;']);
eval(['plot(handles.XLab,handles.' handles.column{s} ',''ob'',''parent'',handles.axes' num2str(finestra) ''');']);
set(ax_,'Xlim',posx)

guidata(hObject, handles);
plotta_ora(handles)
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

hf=figure;
hn_=copyobj(handles.axes1,hf); h1=get(hn_,'Position'); h1(1)=h1(1)+0.1; set(hn_,'Position',h1);
ah_=get(handles.axes1,'children'); nom=get(ah_,'DisplayName');
hnl_=get(hn_,'YLabel'); set(hnl_,'string',nom)

hn_=copyobj(handles.axes2,hf); h1=get(hn_,'Position'); h1(1)=h1(1)+0.1; set(hn_,'Position',h1);
ah_=get(handles.axes2,'children'); nom=get(ah_,'DisplayName');
hnl_=get(hn_,'YLabel'); set(hnl_,'string',nom)

hn_=copyobj(handles.axes3,hf); h1=get(hn_,'Position'); h1(1)=h1(1)+0.1; set(hn_,'Position',h1);
ah_=get(handles.axes3,'children'); nom=get(ah_,'DisplayName');
hnl_=get(hn_,'YLabel'); set(hnl_,'string',nom)
end


% --- Executes on button press in outlayers.
function outlayers_Callback(hObject, eventdata, handles)
% hObject    handle to outlayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%zoom xon;
hOb=findobj('Tag','XLab');
h_ele=get(hOb,'Value');
t_cut=trovadataX(handles.axes1);

button=1; i=0;
while button==1
    i=i+1
    [xi(i),yi,button]=ginput(1) ;
    button
end

ax_=get(gcf,'CurrentAxes');
for n=1:3
    eval(['s=find(ax_==handles.axes' num2str(n) ');'])
    if s==1; break; end
end
finestra=n;
posy=get(ax_,'Ylim');
posx=get(ax_,'Xlim');

eval(['h_=findobj(''Tag'',''edit' num2str(n) ''');']); %n=numero asse
s=str2double(get(h_,'String'));  %numero della colonna


for i=1:length(xi);
    mat(1,:)=abs(t_cut-ones(size(t_cut))*xi(i));
    ll(i)=find(mat(1,:)==min(mat(1,:)),1,'first');
end

if button==3
    
    for i=1:length(xi);
    %running mean    
        if ll==1; eval(['handles.' handles.column{s} '(ll(i))=handles.' handles.column{s} '(ll(i)+1);']);
        else
            eval(['handles.' handles.column{s} '(ll(i))=handles.' handles.column{s} '(ll(i)-1);']);
        end
        
    end
    
    
elseif button==2
    eval(['handles.' handles.column{s} '(ll(1):ll(end))=handles.' handles.column{s} '(ll(1)-1);']);
    
end %if button

guidata(hObject, handles);

plotta_ora(handles)
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

plotta_ora(handles)
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

plotta_ora(handles)
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

plotta_ora(handles)
end

%% LOAD --------------------------------------------------------------------
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ah_=get(handles.axes1,'children'); set(ah_,'XData',[],'YData',[]);
ah_=get(handles.axes2,'children'); set(ah_,'XData',[],'YData',[]);
ah_=get(handles.axes3,'children'); set(ah_,'XData',[],'YData',[]);

I=strcmp(fieldnames(handles),'column');

if any(I)
    for i=1:length(handles.column)
        eval(['handles=rmfield(handles,''', handles.column{i}, ''');'])
    end
    handles=rmfield(handles,'column');
    
end
clear file1
I=strcmp(fieldnames(handles),'new'); if any(I); handles=rmfield(handles,'new'); end
I=strcmp(fieldnames(handles),'X'); if any(I); handles=rmfield(handles,'X'); end
I=strcmp(fieldnames(handles),'TimeZero'); if any(I); handles=rmfield(handles,'TimeZero'); end

%definisce i grafici da plottare:
%qui ci sono i default
handles.g1=2;
handles.g2=3;
handles.g3=5;

ax_=findobj('Tag','edit1'); set(ax_,'String',handles.g1);
ax_=findobj('Tag','edit2'); set(ax_,'String',handles.g2);
ax_=findobj('Tag','edit3'); set(ax_,'String',handles.g3);

h_=findobj('Tag','edit1LB'); set(h_,'String',1);
h_=findobj('Tag','edit2LB'); set(h_,'String',1);
h_=findobj('Tag','edit3LB'); set(h_,'String',1);


[FileName,PathName] = uigetfile('*.*','All Files (*.*)', ...
    'C:\Users\Stefano\Dropbox\Ricerca\SHIVA');

cd (PathName)

data=load(FileName);

dataName=fieldnames(data);
% if length(dataName); data=getfield(data,dataName{1}); end

h_=findobj('Tag','dt_value');
stato=get(h_,'Value');
if isempty(stato)
    handles.dt=0.04;
else
    handles.dt=stato;
end

%set(h_,'String',handles.dt);

handles.filename=FileName;

handles.sm=0;
handles.triggered=0;
handles.cutted=[0 0];
handles.loadT=0;
handles.shearT=0;
ll=1;
nn=length(data.Time);

handles.column=fieldnames(data)

for i=1:length(handles.column)
    handles.(handles.column{i})=data.(handles.column{i}); %debuggato
    %     eval(['handles.' handles.column{i} '=data.' handles.column{i} ';'])
end

h_=findobj('Tag','edit1LB'); set(h_,'String',handles.column);
h_=findobj('Tag','edit2LB'); set(h_,'String',handles.column);
h_=findobj('Tag','edit3LB'); set(h_,'String',handles.column);

% Assess if time is milliseconds or not (this fixes a bug when calculating velocity)

timess = handles.Stamp;
if max(timess)>60 || min(timess)>0.7
    disp('Time is in Milliseconds')
    handles.tconv = 1;
elseif max(timess)<60 || min(timess)<0.7
    disp('Time is in seconds')
    handles.tconv = 1000;
else
    disp('Unable to ascertain time units')
end

handles.load=1;
handles.Done=1;
new=handles;
guidata(hObject, handles);
guidata(hObject, new);

handles.zoom=0;

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
    'Write as',['~/',handles.filename]);
cd (pat)


for j=1:length(handles.column)
    C(j,1)={'%10.6f '};
    if j==length(handles.column)
        C(j,1)={'%10.6f\n'};
    end
end
C1=cell2mat(C');

for j=1:length(handles.column)
    N(j,1)={['handles.' handles.column{j} '(l,1),']};
    if j==length(handles.column)
        N(j,1)={['handles.' handles.column{j} '(l,1)']};
    end
end
N1=cell2mat(N');


for j=1:length(handles.column)
    M(j,1)={['''' handles.column{j} '''' ',']};
    if j==length(handles.column)
        M(j,1)={['''' handles.column{j} '''']};
    end
end
M1=cell2mat(M');

%for j=1:length(handles.column)
%    O(j,1)={['''v' num2str(j) '''' ',']};
%    if j==length(handles.column)
%         O(j,1)={['''v' num2str(j) '''']};
%    end
%end
%O1=cell2mat(O');


for j=1:length(handles.column)
    S(j,1)={'%s '};
    if j==length(handles.column)
        S(j,1)={'%s\n'};
    end
end
S1=cell2mat(S');

%write in a file
nome2=[nome, 'RED.txt'];
fid = fopen(nome2,'wt');
eval(['fprintf(fid,''' S1 ''',' M1 ');'])

eval(['len=length(handles.' handles.column{1} ');'])

for l=1:len
    eval(['fprintf(fid,''' C1 ''',' N1 ');'])
end
fclose(fid);
if ~ strcmp(fieldnames(handles),'dt'); msgbox(['ATTENTION: handles.dt=none']); end
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
    'Save as',[pat0 '/' handles.filename]);
cd (pat)


h_=findobj('Tag','fluid');
statoF=get(h_,'Value');
h_=findobj('Tag','GH');
statoGH=get(h_,'Value');

if statoF==1
    handles.save={'Time' 'shear1' 'EffPressure' 'Mu1' 'Pf' 'LVDT_low' 'LVDT_high' 'vel' 'slip' 'TempE' 'TempM'};
elseif statoGH==1
    handles.save={'Time' 'shear1' 'Normal' 'Mu1' 'dspring' 'LVDT_low' 'vel' 'slip'}; %'TempE' 'TempM'};
else
    handles.save={'Time' 'shear1' 'Normal' 'Mu1' 'LVDT_low' 'vel' 'slip' 'TempE'};
end


for j=1:length(handles.save)
    if j==length(handles.save)
        M(j,1)={['''' handles.save{j} '''']};
    else
        M(j,1)={['''' handles.save{j} '''' ',']};
    end
end
M1=cell2mat(M');

%for j=1:length(handles.column)
%    if j==length(handles.column)
%        O(j,1)={['''v' num2str(j) '''']};
%    else
%        O(j,1)={['''v' num2str(j) '''' ',']};
%    end

%    O1=cell2mat(O');
%end

%file header
name4=['header', nome];
nome2=[nome, '.mat'];
%nome3=['originali', nome];

eval(['save(nome2,''-struct'',''handles'',' M1 ');'])
%eval(['save(nome3,''-struct'',''handles'',' O1 ');'])
%save('parametri','-struct','handles','loadT','shearT','triggered','cutted'
%,'dt','sm')
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
    'Save as',[pat0 '/' handles.filename]);
cd (pat)

handles.save=handles.column;


for j=1:length(handles.save)
    if j==length(handles.save)
        M(j,1)={['''' handles.save{j} '''']};
    else
        M(j,1)={['''' handles.save{j} '''' ',']};
    end
end
M1=cell2mat(M');

%for j=1:length(handles.column)
%    if j==length(handles.column)
%        O(j,1)={['''v' num2str(j) '''']};
%    else
%        O(j,1)={['''v' num2str(j) '''' ',']};
%    end

%    O1=cell2mat(O');
%end

%file header
name4=['header', nome];

nome2=[nome, 'RED.mat'];

eval(['save(nome2,''-struct'',''handles'',' M1 ');'])
end
%eval(['save(nome3,''-struct'',''handles'',' O1 ');'])
%save('parametri','-struct','handles','loadT','shearT','triggered','cutted'
%,'dt','sm')

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

I=handles.triggered;
handles.Encoder2(1:I)=0;
handles.Encoder(1:I)=0;
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
AIstate=zeros(1,18);
for L=1:18
    obj=num2str(L); obj=strcat('popupAI',obj);
    if isempty(findobj('Tag',obj))
    else
        h=findobj('Tag',obj);
        AIstate(1,L)=get(h,'Value');
    end
end

for L=1:18
    b=strfind(handles.column,strcat('AI',num2str(L))); j=0; n=[];
    for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
    for j=1:length(n)
        switch AIstate(L)
            
            case 3
                disp('thermocouple')
                new.InternalTemperature=calibrate_temperature_fx(120,handles.(handles.column{n(j)}),[],[]);
                %output=calibrate_temperature_fx(gain,input_hj,input_cj,compensation)
                new.InternalTemperature(isnan(new.InternalTemperature))=0;
        end
    end
end

% update the columns


K=find(~strcmp('InternalTemperature',handles.column));
handles.column=handles.column(K);
handles.column{end+1}='InternalTemperature';

%update struct
handles.InternalTemperature=new.InternalTemperature;

% h_=findobj('Tag','edit1LB'); set(h_,'String',handles.column)
% h_=findobj('Tag','edit2LB'); set(h_,'String',handles.column)
% h_=findobj('Tag','edit3LB'); set(h_,'String',handles.column)
%
%
% handles.Done=1;
% handles.new=fieldnames(new)';
guidata(hObject, handles);
% plotta_ora(handles)

end

%% refresh_tau callback
% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% preamble
%definisce la calibrazion

if any(strcmp(fieldnames(handles),'smooth'));
    %msgbox('I will work only on not smoothed data')
    nomi=handles.column;
    for i=1:length(nomi)
        if strfind(nomi{i},'smooth'); handles=rmfield(handles,nomi{i});
            K=find(~strcmp(nomi{i},handles.column));
            handles.column=handles.column(K);
        end
    end
end


if any(strcmp(fieldnames(handles),'new'))
    
    nomi=handles.new;
    for i=1:length(nomi)
        handles = rmfield(handles, nomi(i));
        K=find(~strcmp(nomi(i),handles.column));
        handles.column=handles.column(K);
    end
    if any(strcmp(fieldnames(handles),'new')); handles=rmfield(handles,'new');end
end



dint=findobj('Tag','Rint'); rint=str2double(get(dint,'String'))/2000;
dext=findobj('Tag','Rext'); rext=str2double(get(dext,'String'))/2000;

h_=findobj('Tag','calibration'); contents=get(h_,'Value');

if contents==2; cal.tHG=73.86; cal.tLG=cal.tHG; fref=250; end
if contents==3; cal.tHG=1117.17; cal.tLG=cal.tHG; fref=250; end
if contents==4; cal.tHG=730.94; cal.tLG=cal.tHG; fref=250; end
if contents==5; cal.tLG=1118; cal.tHG=cal.tLG*100; fref=250; end
if contents==6; cal.tHG=1179.2; cal.tLG=0.736e6; fref=250; end
if contents==7; cal.tHG=0; cal.tLG=0.736e6; fref=125;
    if isempty(handles.Done); handles.Stamp=handles.Stamp*1.2; handles.Time=handles.Time*1.2; end
end
if contents==8; cal.tHG=0; cal.tLG=0.736e6; fref=125;
    if isempty(handles.Done); handles.Stamp=handles.Stamp*1.24; handles.Time=handles.Time*1.25; end
end
if contents==9; cal.tHG=0; cal.tLG=0.736e6; fref=125;
    if isempty(handles.Done); handles.Stamp=handles.Stamp*2; handles.Time=handles.Time*2; end
end
if contents==10; cal.tHG=0; cal.tLG=0.736e6; fref=125; end
if contents==11; cal.tHG=0; cal.tLG=0.736e6; fref=125; end
if contents==11; cal.tHG=0; cal.tLG=0.736e6; fref=125; end
if contents==12; cal.tHG=0; cal.tLG=0.736e6; fref=100; cal.enc(1)=4/3*pi*(rext^2+rint*rext+rint^2)/(rext+rint)*10;
end

cal.tSG=17.19E6;

cal.torqueHG(1:12)=cal.tHG*3/2/pi/(rext^3-rint^3)*1E-6;
cal.torqueLG(1:12)=cal.tLG*3/2/pi/(rext^3-rint^3)*1E-6;
cal.torqueSG(1:12)=cal.tSG*3/2/pi/(rext^3-rint^3)*1E-6;
rint_o=rint;
%rint=0;

if contents>=11; cal.ax=-7.93457/pi/(rext^2-rint^2)/1000; %MPa
else cal.ax=2.5/pi/(rext^2-rint^2)/1000; %MPa
end

%% calibrate only Normal, shear1, mu1

%% calculate normal stress

b=(strfind(handles.column,'Axial')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n);
    eval(['new.Normal=handles.' handles.column{n(j)} '*cal.ax(j);'])
end

%% correct the normal stress with springs elasticity
h_=findobj('Tag','GH');
statoGH=get(h_,'Value');
if statoGH==1
    % calibrazione Normal load gouge holder
    x=handles.LVDT-handles.LVDT(1);
    a=abs(x- 5.37);
    Ia=find(a==min(a),1,'first');
    new.dspring=(x - x(Ia))*cal.lv(1);
    new.dspring(1:Ia)=0;
    
    if contents>=11; new.NormalGH=(-7.93457*handles.Axial-(0.2666+0.0501*new.dspring))/pi/(rext^2-rint^2)/1000; %MPa
    else new.NormalGH=(2.5*handles.Axial-(0.2666+0.0501*new.dspring))/pi/(rext^2-rint^2)/1000;
    end
    
end

%% calibrate Torque, calculate shear and apparent mu

b=(strfind(handles.column,'Torque')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end

for j=1:length(n)
    if or(~isempty(strfind(handles.column{n(j)},'HG')),strcmp(handles.column{n(j)},'Torque'))
        cali=cal.torqueHG(j);
    elseif ~isempty(strfind(handles.column{n(j)},'LG'))
        cali=cal.torqueLG(j);
    end
    
    eval(['new.shear' num2str(j) '=handles.' handles.column{n(j)} '*cali;']);
    eval(['new.Mu' num2str(j) '=new.shear' num2str(j) './new.Normal;']);
    
    if statoGH==1;eval(['new.Mu' num2str(j) '=new.shear' num2str(j) './new.NormalGH;']); end
end

%% final routine to update the fields
nomi=[];

[a,b]=size(handles.column); [aa,bb]=size(fieldnames(new));
fname=fieldnames(new);
for i=1:length(fname)
    K=find(~strcmp(fname{i},handles.column));
    handles.column=handles.column(K);
end
inp1=handles.column;

if aa==1 & aa==b | bb==1 & a==1; inp1=handles.column'; end
nomi=[inp1 ; fieldnames(new)];

handles.column=[];
handles.column=nomi';

nomi2=fieldnames(new);
for i=1:length(nomi2)
    eval(['handles.' char(nomi2(i)) '=new.' char(nomi2(i)) ';'])
end

h_=findobj('Tag','edit1LB'); set(h_,'String',handles.column)
h_=findobj('Tag','edit2LB'); set(h_,'String',handles.column)
h_=findobj('Tag','edit3LB'); set(h_,'String',handles.column)


handles.Done=1;
handles.new=fieldnames(new)';
guidata(hObject, handles);
plotta_ora(handles)
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

%definisce la calibrazion

if any(strcmp(fieldnames(handles),'smooth'));
    %msgbox('I will work only on not smoothed data')
    nomi=handles.column;
    for i=1:length(nomi)
        if strfind(nomi{i},'smooth'); handles=rmfield(handles,nomi{i});
            K=find(~strcmp(nomi{i},handles.column));
            handles.column=handles.column(K);
        end
    end
end


if any(strcmp(fieldnames(handles),'new'))
    
    nomi=handles.new;
    for i=1:length(nomi)
        handles = rmfield(handles, nomi(i));
        K=find(~strcmp(nomi(i),handles.column));
        handles.column=handles.column(K);
    end
    if any(strcmp(fieldnames(handles),'new')); handles=rmfield(handles,'new');end
end



dint=findobj('Tag','Rint'); rint=str2double(get(dint,'String'))/2000;
dext=findobj('Tag','Rext'); rext=str2double(get(dext,'String'))/2000;

h_=findobj('Tag','calibration'); contents=get(h_,'Value');

cal.enc(1:2)=4/3*pi*(rext^2+rint*rext+rint^2)/(rext+rint);

if contents==2; cal.tHG=73.86; cal.tLG=cal.tHG; fref=250; end
if contents==3; cal.tHG=1117.17; cal.tLG=cal.tHG; fref=250; end
if contents==4; cal.tHG=730.94; cal.tLG=cal.tHG; fref=250; end
if contents==5; cal.tLG=1118; cal.tHG=cal.tLG*100; fref=250; end
if contents==6; cal.tHG=1179.2; cal.tLG=0.736e6; fref=250; end
if contents==7; cal.tHG=0; cal.tLG=0.736e6; fref=125;
    if isempty(handles.Done); handles.Stamp=handles.Stamp*1.2; handles.Time=handles.Time*1.2; end
end
if contents==8; cal.tHG=0; cal.tLG=0.736e6; fref=125;
    if isempty(handles.Done); handles.Stamp=handles.Stamp*1.24; handles.Time=handles.Time*1.25; end
end
if contents==9; cal.tHG=0; cal.tLG=0.736e6; fref=125;
    if isempty(handles.Done); handles.Stamp=handles.Stamp*2; handles.Time=handles.Time*2; end
end
if contents==10; cal.tHG=0; cal.tLG=0.736e6; fref=125; end
if contents==11; cal.tHG=0; cal.tLG=0.736e6; fref=125; end
if contents==11; cal.tHG=0; cal.tLG=0.736e6; fref=125; end
if contents==12; cal.tHG=0; cal.tLG=0.736e6; fref=100; cal.enc(1)=4/3*pi*(rext^2+rint*rext+rint^2)/(rext+rint)*10;
end

cal.tSG=17.19E6;
cal.GEM=3.1;
cal.gems=[3.15911 -2.557];
%after s1949
cal.gems=[3.1022 -2.5052];

cal.torqueHG(1:12)=cal.tHG*3/2/pi/(rext^3-rint^3)*1E-6;
cal.torqueLG(1:12)=cal.tLG*3/2/pi/(rext^3-rint^3)*1E-6;
cal.torqueSG(1:12)=cal.tSG*3/2/pi/(rext^3-rint^3)*1E-6;
rint_o=rint;
%rint=0;

if contents>=11; cal.ax=-7.93457/pi/(rext^2-rint^2)/1000; %MPa
else cal.ax=2.5/pi/(rext^2-rint^2)/1000; %MPa
end


%rint=rint_o;

cal.lv(1)=5.0634;
cal.lv(2)=0.3; %0.12*cal.lv(1); %% cambiato!!!!
cal.lv(3)=1;
cal.fluids(1:12)=4; %MPa/mV

%optional sensors in AI8-AI18

AIstate=zeros(1,18);
for L=1:18;
    obj=num2str(L); obj=strcat('popupAI',obj);
    if isempty(findobj('Tag',obj))
    else
        h=findobj('Tag',obj);
        AIstate(1,L)=get(h,'Value');
    end
end

% cal.cosino=[8.737 0.857];
% after s1949
cal.cosino=[9.0067 0.79664];
%TC
cal.ceriani=[1.667 9.333];
cal.iscoP=[6.879 -0.328];
cal.iscoV=[-50.885694343591595 508.7206208742802];
cal.iscoF=[1 0];
cal.ftutaRH=[1/0.05 0];
cal.ftutaT=[1/0.05 -20];
cal.other=[1 0];
cal.BigMotorTorque=[58.018 0];

%% ELABORAZIONE DATI

%% calculate normal stress

b=(strfind(handles.column,'Axial')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n);
    eval(['new.Normal=handles.' handles.column{n(j)} '*cal.ax(j);'])
end

%% correct the normal stress with springs elasticity
h_=findobj('Tag','GH');
statoGH=get(h_,'Value');
if statoGH==1
    % calibrazione Normal load gouge holder
    x=handles.LVDT-handles.LVDT(1);
    a=abs(x- 5.37);
    Ia=find(a==min(a),1,'first');
    new.dspring=(x - x(Ia))*cal.lv(1);
    new.dspring(1:Ia)=0;
    
    if contents>=11; new.NormalGH=(-7.93457*handles.Axial-(0.2666+0.0501*new.dspring))/pi/(rext^2-rint^2)/1000; %MPa
    else new.NormalGH=(2.5*handles.Axial-(0.2666+0.0501*new.dspring))/pi/(rext^2-rint^2)/1000;
    end
    
end

%% calibrate optional sensors

for L=1:18;
    b=strfind(handles.column,strcat('AI',num2str(L))); j=0; n=[];
    for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
    for j=1:length(n);
        switch AIstate(L)
            case 0
                disp('no channel')
            case 1
                disp('no sensor')
            case 2
                disp('cosino')
                eval(['new.InternalPressure=handles.' handles.column{n(j)} '*cal.cosino(1)+cal.cosino(2);'])
            case 3
                disp('thermocouple')
                eval(['new.InternalTemperature=calibrate_temperature_fx(120,handles.' handles.column{n(j)} ',[],[]);'])
                %output=calibrate_temperature_fx(gain,input_hj,input_cj,compensation)
            case 4
                disp('ceriani')
                eval(['new.ChamberPressure=10.^(handles.' handles.column{n(j)} '*cal.ceriani(1)+cal.ceriani(2));'])
            case 5
                disp('iscoP')
                eval(['new.PumpPressure=handles.' handles.column{n(j)} '*cal.iscoP(1)+cal.iscoP(2);'])
            case 6
                disp('iscoV')
                eval(['new.PumpVolume=handles.' handles.column{n(j)} '*cal.iscoV(1)+cal.iscoV(2);'])
            case 7
                disp('iscoF')
                eval(['new.PumpFlow=handles.' handles.column{n(j)} '*cal.iscoF(1)+cal.iscoF(2);'])
            case 8
                disp('FtutaRH')
                eval(['new.ProbeH=handles.' handles.column{n(j)} '*cal.FtutaRH(1)+cal.FtutaRH(2);'])
            case 9
                disp('FtutaT')
                eval(['new.ProbeT=handles.' handles.column{n(j)} '*cal.FtutaT(1)+cal.FtutaT(2);'])
            case 10
                disp('even more sensors??')
                eval(['new.Other=handles.' handles.column{n(j)} '*cal.other(1)+cal.other(2);'])
            case 11
                disp('Motor torque, analog output of Gefran inverter')
                eval(['new.BigMotorTorque=handles.' handles.column{n(j)} '*cal.BigMotorTorque(1)+cal.BigMotorTorque(2);'])
                new.BigMotorShearStress=abs(new.BigMotorTorque)*3/2/pi/(rext^3-rint^3)*1E-6;
        end
    end
end

%% pore fluids (old)

% h_=findobj('Tag','fluid');
% statoF=get(h_,'Value');
%
% if statoF==1
% b=(strfind(handles.column,'IO')); j=0; n=[];
% for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
% for j=1:length(n);
%         eval(['new.Pf=handles.' handles.column{n(j)} '*cal.fluids(1);']);
%         eval(['new.EffPressure=new.Normal-new.Pf;']);
% end

% if contents>=12; b=(strfind(handles.column,'GefranPressure')); j=0; n=[];
% else b=(strfind(handles.column,'FluidPressure')); j=0; n=[];
% end
%
% for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
% for j=1:length(n);
%         eval(['new.Pf=handles.' handles.column{n(j)} '*cal.fluids(1);']);
%         eval(['new.EffPressure=new.Normal-new.Pf;']);
% end
% end

%% calibrate gems pressure transducer
if any(strcmp(fieldnames(handles),'Gems'))
    new.GEM=handles.Gems*cal.GEM;
elseif any(strcmp(fieldnames(handles),'GEMSPressure'))
    new.GEM=handles.GEMSPressure*cal.GEM;
end

%% pore fluid pressure

h_=findobj('Tag','popupPF');
popupPF=get(h_,'Value');

switch popupPF
    case    1
        disp('No pore pressure')
    case    2
        disp('Gefran is measuring pore pressure')
        if contents>=12; b=(strfind(handles.column,'GefranPressure')); j=0; n=[];
        elseif contents<=11; b=(strfind(handles.column,'FluidPressure')); j=0; n=[];
        else b=strfind(handles.column,'IO'); j=0; n=[];
        end
        
        for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
        for j=1:length(n);
            eval(['new.Pf=handles.' handles.column{n(j)} '*cal.fluids(1);']);
            eval(['new.EffPressure=new.Normal-new.Pf;']);
        end
    case    3
        disp('Gems is measuring pore pressure')
        b=strfind(handles.column,'GEMS'); j=0; n=[];
        for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
        for j=1:length(n);
            eval(['new.Pf=handles.' handles.column{n(j)} '*cal.gems(1) + cal.gems(2);']);
            eval(['new.EffPressure=new.Normal-new.Pf;']);
        end
    case    4
        disp('IscoPump is measuring pore pressure')
        gigione=input('What is the exact name of Isco Pump vector? ','s');
        
        b=strfind(handles.column,gigione); j=0; n=[];
        for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
        for j=1:length(n);
            eval(['new.Pf=handles.' handles.column{n(j)} '*cal.iscoP(1) + cal.iscoP(2);']);
            eval(['new.EffPressure=new.Normal-new.Pf;']);
        end
end

%% confining pressure

h_=findobj('Tag','popupPC');
popupPC=get(h_,'Value');

switch popupPC
    case    1
        disp('No confining pressure')
    case    2
        disp('Gefran is measuring confining pressure')
        if contents>=12; b=(strfind(handles.column,'GefranPressure')); j=0; n=[];
        elseif contents<=11; b=(strfind(handles.column,'FluidPressure')); j=0; n=[];
        else b=strfind(handles.column,'IO'); j=0; n=[];
        end
        
        for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
        for j=1:length(n);
            eval(['new.Pc=handles.' handles.column{n(j)} '*cal.fluids(1);']);
        end
    case    3
        disp('Gems is measuring confining pressure')
        b=strfind(handles.column,'GEMS'); j=0; n=[];
        for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
        for j=1:length(n);
            eval(['new.Pc=handles.' handles.column{n(j)} '*3.15911 - 2.557;']);
        end
    case    4
        disp('IscoPump is measuring confining pressure')
        gigione=input('What is the exact name of Isco Pump vector? ','s');
        
        b=strfind(handles.column,gigione); j=0; n=[];
        for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
        for j=1:length(n);
            eval(['new.Pc=handles.' handles.column{n(j)} '*cal.iscoP(1) + cal.iscoP(2);']);
        end
end

%% calculation of velocity and slip
% encoders

h=findobj('Tag','nodeEnc1');
node=str2num(get(h,'String'));
node1=node(:,1);
f1crat=node(:,2);

h=findobj('Tag','nodeEnc2');
node=str2num(get(h,'String'));
node2=node(:,1);
f2crat=node(:,2);

h=findobj('Tag','MaxEnc');
maxE=str2double(get(h,'String')) ;

b=(strfind(handles.column,'Encoder')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n);
    clear d0 d1 d2 v vel
    eval(['d0=handles.' handles.column{n(j)} ';']) %d0 is the initial, raw encoder data
    Dd0 = diff(d0);
    Dd0(Dd0 == 0) = [];
    min(Dd0)
    if abs(min(Dd0)) < 1/4000
        disp('Fine encoder')
    else
        disp('Coarse encoder')
    end
    h_ele=handles.Stamp/1000;
    % qui provo a ridurre il problema del cambiamento in corsa di acq xlab.
    % per rirpistinare la versione di shivaUNIX precedente imposta I_ele=[] e commenta la riga di seguito.
    
    hOb=findobj('Tag','AdjRate'); f_ele=get(hOb,'Value');
    I_ele=find(diff(h_ele)<mode(diff(h_ele)));
    testE=2;
    
    %=== se necessario aggiustare il rate
    if ~isempty(I_ele) && f_ele==1
        testE=1; Fs=[];
        sl_ele=d0;
        I_range=[I_ele: I_ele+1];
        I_fit=[I_ele-10:I_ele];
        I_inter=[I_ele:I_ele+10];
        cv=fit(handles.Time(I_fit)/1000, sl_ele(I_fit),'linear');
        deltaslip=sl_ele(I_ele+1) - cv(handles.Time(I_ele+1)/1000);
        sl_ele(I_ele+1:end)=sl_ele(I_ele+1:end)/1000 - deltaslip(1);
        d0=sl_ele;
    end
    
    
    %che i massimi siano fuori dal rumore
    J=local_max(d0); I=[];
    if length(J) > 10
        [c,d]=hist(diff(d0(J))); Jc=find(c==max(c));
        r=abs(diff(d0(J))-d(Jc(1))); In=find(r > mode(diff(d))); I=J(In);
    end
    
    I=J; %cambiato 15/03
    %figure; plot(d0); hold on; plot(I,d0(I),'*r')
    
    fO=findobj('Tag','incremental'); fOV=get(fO,'value')
    if fOV==1
        if ~isempty(I)
            for ii=1:length(I)
                if ii==length(I) & I(ii) + 2 < length(d0)
                    d0(I(ii)+1:end)=d0(I(ii)+1:end)-d0(I(ii)+2)+d0(I(ii));
                elseif ii==length(I) & I(ii) +2 >= length(d0)
                    break
                else
                    d0(I(ii)+1:I(ii+1))=d0(I(ii)+1:I(ii+1))-d0(I(ii)+2)+d0(I(ii));
                end
            end
        end
    end %if fOV
    
    d0(d0<0)=0;
    
    ITorq=findobj('Tag','Torque');
    ITorqO=get(ITorq,'Value');
    
    h=handles.Stamp/1000;
    d1=d0*cal.enc(1);
    % figure(22)
    plot(d1)
    if ITorqO==0
        fcamp=(1./max(1/fref,h));
        Fs=max(fcamp);
        alphas=ceil(log10(Fs));
        fc=max(fref/100,Fs/10^(alphas));
        disp(['fc= ',num2str(fc)])
        nodes=node2; fcrat=f2crat;
        if i==1; nodes=node1; fcrat=f1crat;
        end
        if Fs > fref/100
            disp('red')
            %riduci l'effetto window
            d=fdesign.lowpass('N,Fc',nodes,fcrat,Fs);
            
            Hd=design(d,'window','Window',tukeywin(nodes+1,0));
            d_sm=filtfilt(Hd.Numerator,1,d1);
        else
            d_sm=d1;
        end
    else
        d_sm=d1;
    end
    
    
    
    % na=1;
    % dtn=mode(h)./na;
    %
    % if na > 1
    %     % serve a ricampionare e calcolare la V con maggiore dettaglio.
    %     % Cambiare na all'occorrenza
    % xx=handles.Time(1)/1000:dtn:handles.Time(end)/1000;
    % cs=spline(handles.Time/1000, d_sm);
    % d_sm1=ppval(cs,xx);
    % bb=zeros(size(d_sm1));
    % bb(2:end)=diff(d_sm1); bb(1)=bb(2);
    % h_1=diff(xx); h1=h_1; h1(2:end+1)=h_1;
    % v1=bb./h1;
    % v=resample(v1,1,na)';
    % d_sm=resample(d_sm1, 1, na)';
    % a=length(v) - length(h);
    % for ia=1:a
    % v(end+1)=v(end);
    % d_sm(end+1)=d_sm(end);
    % end
    % else
    bb=zeros(size(d_sm));
    bb=diff(d_sm); bb(end+1)=bb(end);
    v=(bb./h)./handles.tconv;
    % end
    
    eval(['new.SlipVel_Enc_' num2str(j) '=v;']);
    eval(['new.Slip_Enc_' num2str(j) '=(d_sm);']);
    
    
    %if j==2; v=smooth(v,300); end
    if j==1; del0=d_sm; v0=v; end
    if j==2;
        del10=max(d_sm,del0);
        Iv=find(v < 0.01 ); %% cambiare
        d_sm(Iv)=del0(Iv);
        v=max(v0,v);
        del=max(del0,d_sm);
        %if j==2; adel=abs(d_sm-del0)./del0.*100; Iadel=find(adel < 1);
        %del(Iadel)=del0(Iadel);
        %end
        %bb=zeros(size(del));
        %bb(2:end)=diff(del); bb(1)=bb(2);
        
        %if j==1; Ivmax=find(v<=0.05); new.vel=zeros(size(v)); new.vel(Ivmax)=v(Ivmax); end
        %if j==2; Ivmax=find(v>0.05);  new.vel(Ivmax)=new.SlipVel_Enc_2(Ivmax); end
        new.slip=del10;
        if max(v) <= 20E-3
            new.vel=v0;
        else
            new.vel=v; %bb./h;
        end
        
        %find outlayers in vel
        IOL=find(new.vel >=10);
        for i=1:length(IOL)
            new.vel(IOL(i))=new.vel(IOL(i)-1);
        end
        IOL=find(new.vel < -1);
        for i=1:length(IOL)
            new.vel(IOL(i))=new.vel(IOL(i)-1);
        end
        
    end
end

%% calibrate LVDT

b=(strfind(handles.column,'LVDT')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n); ...
        if any(strfind(handles.column{n(j)},'LVDT_')); continue;
        else
            if j==1; eval(['new.LVDT_low= handles.' handles.column{n(j)} '*cal.lv(j);']); end
            if j==2; eval(['new.LVDT_high= handles.' handles.column{n(j)} '*cal.lv(j);']); end
            
        end
end

%% calibrate Torque, calculate shear and mu/effective mu
b=(strfind(handles.column,'Torque')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end

for j=1:length(n)
    if or(~isempty(strfind(handles.column{n(j)},'HG')),strcmp(handles.column{n(j)},'Torque'))
        cali=cal.torqueHG(j);
    elseif ~isempty(strfind(handles.column{n(j)},'LG'))
        cali=cal.torqueLG(j);
    end
    
    %   if ITorqO==1 & testE==2 & Fs > fref/100
    %    eval(['new.shear' num2str(j) '=filtfilt(Hd.Numerator,1,handles.' handles.column{n(j)} '*cali);']);
    %   else
    eval(['new.shear' num2str(j) '=handles.' handles.column{n(j)} '*cali;']);
    %   end
    eval(['new.Mu' num2str(j) '=new.shear' num2str(j) './new.Normal;']);
    
    h_=findobj('Tag','fluid');
    statoF=get(h_,'Value');
    
    % non sono sicura    if statoGH==1;eval(['new.Mu' num2str(j) '=new.shear' num2str(j) './new.NormalGH;']); end
    if (statoF==1) OR (popupPF>=2); eval(['new.Mu' num2str(j) '=new.shear' num2str(j) './new.EffPressure;']); end
end

%% import the thermocouple recording

h_=findobj('Tag','TC');
statoTC=get(h_,'Value');

if statoTC==1 && isempty(dir('*TC'))==0;
    %thermocouple
    filname=dir('*TC');
    
    if isempty(filname) | length(filname) > 1
        %    nn=handles.filename(1:4)
        %    xx=dir(['~/shivadir/Shiva Experiments/' nn '*']);
        %    if ~isempty(xx)
        %    yy=dir(['~/shivadir/Shiva Experiments/' xx.name '/*TC*']);
        %    if ~isempty(yy) & length(yy)==1
        [filename,PathName] = uigetfile('*.*','All Files (*.*)', ...
            pwd);
        
        clear filname
        filname.name=filename;
        
        %    filname=struct('name',{['~/shivadir/Shiva Experiments/' xx.name '/' yy.name]});
        %    end
        %    end
    end
    
    TC=importdata(filname.name,'\t',2);
    time2=cumsum(handles.Stamp);
    
    [a,b]=size(TC.data);
    
    if b==5;
        time=(1:length(TC.data)).*400;
        new.T1=interp1(time,TC.data(:,1),time2);
        new.T2=interp1(time,TC.data(:,2),time2);
        new.T3=interp1(time,TC.data(:,3),time2);
        new.T4=interp1(time,TC.data(:,4),time2);
    elseif b==2
        
        %time=(1:length(TC.data)).*mode(TC.data(:,2));
        time=cumsum(TC.data(:,2));
        %time=time./time(end).*time2(end);
        new.T1=interp1(time,TC.data(:,1),time2);
    else
        T1=Tmeas(TC.data(:,1).*1000);
        h_=findobj('Tag','T0'); T1=str2num(get(h_,'String'));
        T2=Tmeas_3(TC.data(:,1),T1);
        T=T2;
        time=(1:length(TC.data)).*80;
        new.T1=interp1(time,T,time2);
    end
end

%% Estimate temperature
dn=50;
time2=cumsum(handles.Stamp);

if any(strcmp(fieldnames(new),'vel'))
    [Temp]=temp(handles.Time/1000,new.vel,new.shear1,new.slip, dn); %change for vel
    
elseif max(new.vel) <= 20e-3
    [Temp]=temp(handles.Time/1000,new.SlipVel_Enc_1,new.shear1,new.Slip_Enc_1,dn);
else
    [Temp]=temp(handles.Time/1000,new.SlipVel_Enc_2,new.shear1,new.Slip_Enc_2,dn); %change for vel
end
new.TempE=interp1(time2(1:dn:end),Temp,time2);

b=(strfind(handles.column,'StrainGauge')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n); ...
        eval(['new.StrainGauge' num2str(j) '=handles.' handles.column{n(j)} '*cal.torqueSG(j);']);
    eval(['new.MuSG' num2str(j) '=new.StrainGauge' num2str(j) './new.Normal;']);
end

%% import the Isco pump recording

if isempty(dir('*IP'))==0 || isempty(dir('*ISCO'))==0;
    %thermocouple
    filname=[dir('*IP') dir('*ISCO')];
    
    if isempty(filname) | length(filname) > 1
        %    nn=handles.filename(1:4)
        %    xx=dir(['~/shivadir/Shiva Experiments/' nn '*']);
        %    if ~isempty(xx)
        %    yy=dir(['~/shivadir/Shiva Experiments/' xx.name '/*TC*']);
        %    if ~isempty(yy) & length(yy)==1
        [filename,PathName] = uigetfile('*.*','All Files (*.*)', ...
            pwd);
        
        clear filname
        filname.name=filename;
        
        %    filname=struct('name',{['~/shivadir/Shiva Experiments/' xx.name '/' yy.name]});
        %    end
        %    end
    end
    
    IP=importdata(filname.name,'\t',1);
    
    for i=1:size(IP.data,2)
        header=strrep(IP.colheaders{1,i},'_','');
        header=strrep(header,'(s)','');
        header=strrep(header,'(ms)','');
        header=strrep(header,'(kPa)','');
        header=strrep(header,'(MPa)','');
        header=strrep(header,'(mL/min)','');
        header=strrep(header,'(mL)','');
        
        new.(header)=IP.data(:,i);
        
        %         eval(['new.'  IP.colheaders{1,i} '=IP.data(1,' i ');']);
    end
end

%% calibrate the room humidity sensor
%HR and TA


b=(strfind(handles.column,'RH')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n);
    eval(['new.HRc=handles.' handles.column{n(j)} './0.05;'])
end

b=(strfind(handles.column,'TA')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n);
    eval(['new.TAc=(handles.' handles.column{n(j)} './0.05)-20;'])
end
%% calibrate the vacuum gauge

h_=findobj('Tag','vac');
statoVAC=get(h_,'Value');

if statoVAC==1;
    
    new.VAC=10.^(handles.TA*1.667-9.333);
else %keyboard
end
% clear statoVAC
% Vac=10.^(TA*1.667-9.333); %Pa

%% calculate gouge layer thickness

h_=findobj('Tag','get_thickness');
statoTHICKNESS=get(h_,'Value');

h_=findobj('Tag','zero_thickness_long'); % volts
ztl=get(h_,'String');
ztl=str2double(ztl);

h_=findobj('Tag','zero_thickness_short'); % mm
zts=get(h_,'String');
zts=str2double(zts);

if statoTHICKNESS==1
    
    b=(strfind(handles.column,'LVDT')); j=0; n=[];
    for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
    for j=1
        new.thickness_low=(handles.(handles.column{n(j)})-ztl)*cal.lv(1);
    end
    
    b=(strfind(handles.column,'short')); j=0; n=[];
    for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
    for j=1
        new.thickness_high=zts-cal.lv(2)*(handles.(handles.column{n(j)}));
    end
    
else %keyboard
end

%% import the GEF data (recording of the gefranexpress)

ax_=findobj('Tag','Gefran'); statoGEF=get(ax_,'Value');

if statoGEF==1;
    
    I=find(abs(handles.timeGEF)==min(abs(handles.timeGEF))); if isempty(I); I=1; end
    J=find(abs(handles.Time)==min(abs(handles.Time))); if isempty(J); J=1; end
    
    if length(new.Normal)>=length(handles.VGEF)
        I2=length(handles.VGEF);
        if I2+J > length(new.Normal); I2=I2-J; end
        J2=J-1+I2;
        
        new.SpeedGEF=zeros(size(new.Normal)); new.SpeedGEF(J:J2)=(-1)*handles.VGEF(I:I2).*cal.enc(1)/60;
        new.SlipGEF=zeros(size(new.Normal)); new.SlipGEF(J:J2)=cumsum((-1)*handles.VGEF(I:I2))*cal.enc(1)/60/1000;
        if any(find(strcmp(fieldnames(handles),'TqGEF')));
            new.TorqueGEF=zeros(size(new.Normal)); new.TorqueGEF(J:J2)=(-1)*handles.TqGEF(I:I2);
        end
        
    else
        
        l=J+length(handles.VGEF)-1; resl=l-length(handles.Time);
        new.SpeedGEF(J:length(handles.Time))=(-1)*handles.VGEF(1:length(handles.VGEF)-resl).*cal.enc(1)/60;
        new.SlipGEF(J:length(handles.Time))=cumsum((-1)*handles.VGEF(1:length(handles.VGEF)-resl))*cal.enc(1)/60/1000;
        if any(find(strcmp(fieldnames(handles),'TqGEF')));
            new.TorqueGEF(J:J+length(handles.VGEF)-1)=(-1)*handles.TqGEF;
        end
        
    end
    
    ax_=findobj('Tag','Gefran'); set(ax_,'Value',0)
    handles=rmfield(handles,'VGEF');
    handles=rmfield(handles,'timeGEF');
    
    if strcmp(handles.column,'TqGEF'); handles=rmfield(handles,'TqGEF'); end
    I=find(~strcmp(handles.column,'TqGEF')); if ~isempty(I); handles.column=handles.column(I); end
    I=find(~strcmp(handles.column,'VGEF')); if ~isempty(I); handles.column=handles.column(I); end
    I=find(~strcmp(handles.column,'timeGEF')); if  ~isempty(I);  handles.column=handles.column(I); end
    
end

%% final routine to update the fields
nomi=[];

[a,b]=size(handles.column); [aa,bb]=size(fieldnames(new));
fname=fieldnames(new);
for i=1:length(fname)
    K=find(~strcmp(fname{i},handles.column));
    handles.column=handles.column(K);
end
inp1=handles.column;

if aa==1 & aa==b | bb==1 & a==1; inp1=handles.column'; end
nomi=[inp1 ; fieldnames(new)];

handles.column=[];
handles.column=nomi';

nomi2=fieldnames(new);
for i=1:length(nomi2)
    eval(['handles.' char(nomi2(i)) '=new.' char(nomi2(i)) ';'])
end

h_=findobj('Tag','edit1LB'); set(h_,'String',handles.column)
h_=findobj('Tag','edit2LB'); set(h_,'String',handles.column)
h_=findobj('Tag','edit3LB'); set(h_,'String',handles.column)


handles.Done=1;
handles.new=fieldnames(new)';
guidata(hObject, handles);
plotta_ora(handles)
end

%% FIT
function brutalfilt_Callback(hObject, eventdata, handles)
% hObject    handle to brutalfilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of brutalfilt as text
%        str2double(get(hObject,'String')) returns contents of brutalfilt as a double


set(hObject,'Enable','on','BackGroundColor','white')
handles.brut=str2num(get(hObject,'String'));

if isempty(handles.brut); handles.brut=500; end
ginput(1)
ax_=get(gcf,'CurrentAxes');

for n=1:3
    %     s=find(ax_==handles.figure1.Children);
    s=find(ax_==handles.(['axes' num2str(n)]));
    
    if s==1; break; end
end


% finestra=n;

% posy=get(ax_,'Ylim');
% posx=get(ax_,'Xlim');

h_=findobj('Tag',['edit' num2str(n)]); %n=numero asse
s=str2double(get(h_,'String'));  %numero della colonna

% brutal filter & store in handles

handles.([handles.column{s} 'o'])=handles.(handles.column{s});
handles.([handles.column{s}])=brutal_filter_fx(1024,0.9,handles.brut,handles.(handles.column{s}),handles.Stamp);

% store in column vector
if ~strcmp(handles.column,{[handles.column{s} 'o']})
    handles.column(end+1)={[handles.column{s} 'o']};
end

h_=findobj('Tag','edit1LB'); set(h_,'String',handles.column);
h_=findobj('Tag','edit2LB'); set(h_,'String',handles.column);
h_=findobj('Tag','edit3LB'); set(h_,'String',handles.column);

guidata(hObject, handles);

plotta_ora(handles);

end
% --- Executes on button press in filtvel.
function filtvel_Callback(hObject, eventdata, handles)
% hObject    handle to filtvel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filtvel
%[handles.velF, handles.slipF]=finfilt(handles.Time, handles.slip);
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

%handles.velF=filtravel_shiva(handles.vel,handles.Time, 25);
%handles.slipF=filtravel_shiva(handles.slip,handles.Time, 25);

if any(strcmp(handles.column,'velF'));
else
handles.column{end+1}='velF';
handles.column{end+1}='slipF';
end
guidata(hObject, handles);
end

%% calculate gouge layer thickness
% --- Executes on button press in refresh_thickness.
function refresh_thickness_Callback(hObject, eventdata, handles)
% hObject    handle to refresh_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cal.lv(1)=5.0634;
cal.lv(2)=0.3;

h_=findobj('Tag','zero_thickness_long'); % volts
ztl=get(h_,'String');
ztl=str2double(ztl);

h_=findobj('Tag','zero_thickness_short'); % mm
zts=get(h_,'String');
zts=str2double(zts);

b=(strfind(handles.column,'LVDT')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1
    new.thickness_low=(handles.(handles.column{n(j)})-ztl)*cal.lv(1);
end

b=(strfind(handles.column,'short')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1
    new.thickness_high=zts-cal.lv(2)*(handles.(handles.column{n(j)}));
end


%% final routine to update the fields
nomi=[];

[a,b]=size(handles.column); [aa,bb]=size(fieldnames(new));
fname=fieldnames(new);
for i=1:length(fname)
    K=find(~strcmp(fname{i},handles.column));
    handles.column=handles.column(K);
end
inp1=handles.column;

if aa==1 & aa==b | bb==1 & a==1; inp1=handles.column'; end
nomi=[inp1 ; fieldnames(new)];

handles.column=[];
handles.column=nomi';

nomi2=fieldnames(new);
for i=1:length(nomi2)
    eval(['handles.' char(nomi2(i)) '=new.' char(nomi2(i)) ';'])
end

h_=findobj('Tag','edit1LB'); set(h_,'String',handles.column)
h_=findobj('Tag','edit2LB'); set(h_,'String',handles.column)
h_=findobj('Tag','edit3LB'); set(h_,'String',handles.column)


handles.Done=1;
handles.new=fieldnames(new)';
guidata(hObject, handles);
plotta_ora(handles)
end
%% generate unwrap
% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

b=(strfind(handles.column,'Encoder2')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1
    new.Encoder2=unwrap(handles.(handles.column{n(j)}));
end

handles.Encoder2=new.Encoder2;

% handles.column
clear handles.new

h_=findobj('Tag','edit1LB'); set(h_,'String',handles.column)
h_=findobj('Tag','edit2LB'); set(h_,'String',handles.column)
h_=findobj('Tag','edit3LB'); set(h_,'String',handles.column)


handles.Done=1;
guidata(hObject, handles);
plotta_ora(handles)
end
%% funzioni di utilità

function ll=trovaasse(asse,xi)

Xax1=findobj(asse,'Type','line')
t_cut=Xax1(1).XData;
mat(1,:)=abs(t_cut-ones(size(t_cut))*xi(1));
ll(:,1)=find(mat(1,:)==min(mat(1,:)));

end

function X=trovadataX(asse)

h_ele1=findobj(asse,'Type','line'); 
X=h_ele1(1).XData;
end
