function [final_file_path, handles] = save_mat_data (handles, params_struct)

% Logga il percorso completo che si intende salvare
handles.log = append_action_to_log(handles.log, 'save_mat_data', params_struct);

file_suffix='.mat';

full_save_path = params_struct.Name;
statoF = params_struct.statoF;
statoGH = params_struct.statoGH;
statoCAL = params_struct.statoCAL;

if statoF==1
    handles.save={'Time' 'shear1' 'EffPressure' 'Mu1' 'Pf' 'LVDT_low' 'LVDT_high' 'vel' 'slip' 'TempE' 'TempM'};
elseif statoGH==1
    handles.save={'Time' 'shear1' 'Normal' 'Mu1' 'dspring' 'LVDT_low' 'vel' 'slip'}; %'TempE' 'TempM'};
elseif statoCAL==1
    handles.save={'Time' 'shear1' 'Normal' 'Mu1' 'LVDT_low' 'vel' 'slip' 'TempE'};
else
    handles.save=handles.column;
    file_suffix='RED.mat';
end

[path, name, ~] = fileparts(full_save_path);
final_file_name = [name, file_suffix];
final_file_path = fullfile(path, final_file_name);

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
eval(['save(final_file_path,''-struct'',''handles'',' M1 ');'])
%eval(['save(nome3,''-struct'',''handles'',' O1 ');'])
%save('parametri','-struct','handles','loadT','shearT','triggered','cutted','dt','sm')

end