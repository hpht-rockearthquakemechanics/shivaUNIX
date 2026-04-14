function write_ascii_data_red(handles, Name)
%C
for j=1:length(handles.column)
    C(j,1)={'%10.6f '};
    if j==length(handles.column)
        C(j,1)={'%10.6f\n'};
    end
end
C1=cell2mat(C');

%N
for j=1:length(handles.column)
    N(j,1)={['handles.' handles.column{j} '(l,1),']};
    if j==length(handles.column)
        N(j,1)={['handles.' handles.column{j} '(l,1)']};
    end
end
N1=cell2mat(N');

%M
for j=1:length(handles.column)
    M(j,1)={['''' handles.column{j} '''' ',']};
    if j==length(handles.column)
        M(j,1)={['''' handles.column{j} '''']};
    end
end
M1=cell2mat(M');

%%O
%for j=1:length(handles.column)
%    O(j,1)={['''v' num2str(j) '''' ',']};
%    if j==length(handles.column)
%         O(j,1)={['''v' num2str(j) '''']};
%    end
%end
%O1=cell2mat(O');

%S
for j=1:length(handles.column)
    S(j,1)={'%s '};
    if j==length(handles.column)
        S(j,1)={'%s\n'};
    end
end
S1=cell2mat(S');

%write in a file
nome2=[Name, 'RED.txt'];
fid = fopen(nome2,'wt');
eval(['fprintf(fid,''' S1 ''',' M1 ');'])

eval(['len=length(handles.' handles.column{1} ');'])

for l=1:len
    eval(['fprintf(fid,''' C1 ''',' N1 ');'])
end
fclose(fid);
if ~ strcmp(fieldnames(handles),'dt'); msgbox('ATTENTION: handles.dt=none'); end
end