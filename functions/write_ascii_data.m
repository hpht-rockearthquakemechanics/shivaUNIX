function handles = write_ascii_data(handles,full_file_path,statoF,statoGH,statoCAL)

params = struct('FileName',full_file_path,'statoF',statoF,'statoGH',statoGH,'statoCAL',statoCAL);
handles.log = append_action_to_log(handles.log, 'write_ascii_data', params);

if statoF==1
    I={'Time' 'shear1' 'EffPressure' 'Mu1' 'Pf' 'LVDT_low' 'LVDT_high' 'vel' 'slip' 'TempE' 'TempM'};
elseif statoGH==1
    I={'Time' 'shear1' 'Normal' 'Mu1' 'dspring' 'LVDT_low' 'vel' 'slip' 'TempE' 'TempM'};
elseif statoCAL==1 %calibration check
    I={'Time' 'shear1' 'Normal' 'Mu1' 'LVDT_low' 'vel' 'slip' 'TempE'};
else
    I=handles.column;
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
[path, name, ~] = fileparts(full_file_path);
final_path = fullfile(path, [name, 'RED.txt']);
fid = fopen(final_path,'wt');
eval(['fprintf(fid,''' S1 ''',' M1 ');'])

eval(['len=length(handles.' handles.column{1} ');'])

for l=1:len
    eval(['fprintf(fid,''' C1 ''',' N1 ');'])
end
fclose(fid);
if ~ strcmp(fieldnames(handles),'dt'); msgbox(['ATTENTION: handles.dt=none']); end

end