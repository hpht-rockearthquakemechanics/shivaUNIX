function [final_file_path, handles] = save_mat_data (handles, Name, statoF, statoGH, statoCAL)

params = struct('Name',Name,'statoF',statoF,'statoGH',statoGH,'statoCAL',statoCAL);
handles.log = append_action_to_log(handles.log, 'save_mat_data', params);

file_suffix='.mat';

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
name4=['header', Name];
nome2=[Name, file_suffix];
%nome3=['originali', nome];

eval(['save(nome2,''-struct'',''handles'',' M1 ');'])
%eval(['save(nome3,''-struct'',''handles'',' O1 ');'])
%save('parametri','-struct','handles','loadT','shearT','triggered','cutted','dt','sm')

% Restituisci il percorso completo del file salvato
final_file_path = fullfile(pwd, nome2);

end