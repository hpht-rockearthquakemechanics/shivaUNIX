function new_handles = load_mat_data(handles, FileName)

new_handles = handles;

data=load(FileName);

dataName=fieldnames(data);
% if length(dataName); data=getfield(data,dataName{1}); end

h_=findobj('Tag','dt_value');
stato=get(h_,'Value');
if isempty(stato)
    new_handles.dt=0.04;
else
    new_handles.dt=stato;
end

%set(h_,'Value',handles.dt);

new_handles.filename=FileName;

new_handles.sm=0;
new_handles.triggered=0;
new_handles.cutted=[0 0];
new_handles.loadT=0;
new_handles.shearT=0;
ll=1;
nn=length(data.Time);

new_handles.column=fieldnames(data);

for i=1:length(new_handles.column)
    new_handles.(new_handles.column{i})=data.(new_handles.column{i}); %debuggato
    %     eval(['handles.' handles.column{i} '=data.' handles.column{i} ';'])
end

h_=findobj('Tag','edit1LB'); set(h_,'Value',new_handles.column);
h_=findobj('Tag','edit2LB'); set(h_,'Value',new_handles.column);
h_=findobj('Tag','edit3LB'); set(h_,'Value',new_handles.column);

% Assess if time is milliseconds or not (this fixes a bug when calculating velocity)

timess = new_handles.Stamp;
if max(timess)>60 || min(timess)>0.7
    disp('Time is in Milliseconds')
    new_handles.tconv = 1;
elseif max(timess)<60 || min(timess)<0.7
    disp('Time is in seconds')
    new_handles.tconv = 1000;
else
    disp('Unable to ascertain time units')
end

new_handles.load=1;
new_handles.Done=1;
new_handles.zoom=0;

end