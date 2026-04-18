function new_handles = open_ascii_data(handles, FileName)

new_handles = handles;

new_handles.log=append_action_to_log(new_handles.log, 'open_ascii_data', struct('FileName', FileName));

%definisce i parametri da matrice
%new_handles.column=importdata(FileName,'\t',1);

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
    if and(any(strcmp(fieldnames(new_handles),'column')), strcmp(A,2))
        new_handles.column{i-1}={[char(new_handles.column(i-1)), '2']};
    else
        new_handles.column(i)={A};
    end
    %controlla che non ce ne siano due uguali
    S=sum(strcmp(new_handles.column(i), new_handles.column));
    if S > 1; new_handles.column{i}=([char(new_handles.column(i)), '2']); end

end

fgets(fid);    fgets(fid); i=0;
file1=struct;
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

new_handles.filename=FileName;

new_handles.sm=0;
new_handles.triggered=0;
new_handles.cutted=[0 0];
new_handles.loadT=0;
new_handles.shearT=0;
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
%new_handles.xlab=0:new_handles.dt:(length(file1.data)-1)*new_handles.dt;
%memorizza anche gli originali
%eval(['new_handles.' new_handles.column{1} ' = cumsum(file1.data(ll:nn,1)); '])
%eval(['new_handles.v' num2str(1) ' = cumsum(file1.data(ll:nn,1)); '])


new_handles.column{1}='Time';
num=length(new_handles.column);

for n=2:num
    test=double(new_handles.column{n});
    if any(test==32)
        new_handles.column{n}=char(test(test~=32));
    end
    eval(strcat('new_handles.',new_handles.column{n}, '= file1.data(ll:nn,', num2str(n), ');'))
end



new_handles.column{num+1}='Stamp';
eval(['new_handles.' new_handles.column{num+1} '= file1.data(ll:nn,1);'])

num=length(new_handles.column);
new_handles.column{num+1}='Rate';
eval(['new_handles.' new_handles.column{num+1} '= [1:1:length(file1.data(ll:nn,1))]''; '])

num=length(new_handles.column);
new_handles.column{num+1}='RateZero';
eval(['new_handles.' new_handles.column{num+1} '= [1:1:length(file1.data(ll:nn,1))]''; '])

% --> ele
hv=get(new_handles.XLab(1),'Value');
new_handles.TimeZero=cumsum(new_handles.Stamp);
new_handles.Time=zeros(size(new_handles.Stamp));
new_handles.Time(1)=hv*new_handles.Stamp(1);
new_handles.Time(2:end)=hv*new_handles.Stamp(1) +cumsum(new_handles.Stamp(2:end)); %plotto il numero di riga

new_handles.Done=[];
new_handles.Time=new_handles.Time*tconv;
new_handles.tconv=tconv;
new_handles.zoom=0;

end