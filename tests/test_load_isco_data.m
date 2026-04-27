clearvars

% isco script
isconame='IP2';

switch isconame
    case 'IP'
        list=find_isco_file('s1661','\\10.164.3.225\spagnuolo\SHIVA-ACQ');
    case 'IP2'
        list=find_isco_file('s1690','\\10.164.3.225\spagnuolo\SHIVA-ACQ');    
    case 'ISCO'
        list=find_isco_file('s1739','\\10.164.3.225\spagnuolo\SHIVA-ACQ');

    case 'isco'
        list=find_isco_file('s2020','\\10.164.3.225\spagnuolo\SHIVA-ACQ');
end

params_struct.isco_file_paths=list;
handles.log={};
handles.tconv=1; %handles.Time in milliseconds

load_isco_data(handles,params_struct)