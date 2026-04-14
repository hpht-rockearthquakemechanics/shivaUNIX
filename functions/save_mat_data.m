function save_mat_data(handles,FileName)

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
name4=['header', FileName];

nome2=[FileName, 'RED.mat'];

eval(['save(nome2,''-struct'',''handles'',' M1 ');'])
%eval(['save(nome3,''-struct'',''handles'',' O1 ');'])
%save('parametri','-struct','handles','loadT','shearT','triggered','cutted','dt','sm')

end