function new_handles = load_mat_data(handles, params_struct)

new_handles = handles;

full_file_path = params_struct.FileName;
data=load(full_file_path);

dataName=fieldnames(data);
% if length(dataName); data=getfield(data,dataName{1}); end

[~, name, ext] = fileparts(full_file_path);
new_handles.filename=[name, ext];

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