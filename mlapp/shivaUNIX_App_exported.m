classdef shivaUNIX_App_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        figure1                      matlab.ui.Figure
        File                         matlab.ui.container.Menu
        open                         matlab.ui.container.Menu
        close                        matlab.ui.container.Menu
        save                         matlab.ui.container.Menu
        write                        matlab.ui.container.Menu
        load                         matlab.ui.container.Menu
        saveBinary                   matlab.ui.container.Menu
        saveRED                      matlab.ui.container.Menu
        Figure                       matlab.ui.container.Menu
        print                        matlab.ui.container.Menu
        GridLayout                   matlab.ui.container.GridLayout
        XLab                         matlab.ui.control.ListBox
        fft                          matlab.ui.control.Button
        edit3                        matlab.ui.control.EditField
        get_thickness                matlab.ui.control.CheckBox
        zeroThicknessLVDTShort       matlab.ui.control.EditField
        zeroThicknessLVDTShortLabel  matlab.ui.control.Label
        popupAI18                    matlab.ui.control.DropDown
        popupAI10                    matlab.ui.control.DropDown
        vac                          matlab.ui.control.CheckBox
        zeroThicknessLVDT            matlab.ui.control.EditField
        zeroThicknessLVDTLabel       matlab.ui.control.Label
        popupAI17                    matlab.ui.control.DropDown
        popupAI9                     matlab.ui.control.DropDown
        Torque                       matlab.ui.control.CheckBox
        popupAI16                    matlab.ui.control.DropDown
        popupAI8                     matlab.ui.control.DropDown
        TC                           matlab.ui.control.CheckBox
        popupAI7                     matlab.ui.control.DropDown
        GH                           matlab.ui.control.CheckBox
        T0                           matlab.ui.control.EditField
        popupAI6                     matlab.ui.control.DropDown
        fluid                        matlab.ui.control.CheckBox
        popupPC                      matlab.ui.control.DropDown
        edit2                        matlab.ui.control.EditField
        Gefran                       matlab.ui.control.CheckBox
        popupPF                      matlab.ui.control.DropDown
        Rext                         matlab.ui.control.EditField
        Rint                         matlab.ui.control.EditField
        refreshTemperature           matlab.ui.control.Button
        refreshTau                   matlab.ui.control.Button
        unwrap                       matlab.ui.control.Button
        text5                        matlab.ui.control.Label
        text6                        matlab.ui.control.Label
        refreshThickness             matlab.ui.control.Button
        nodeEnc2                     matlab.ui.control.EditField
        nodeEnc1                     matlab.ui.control.EditField
        calibrate                    matlab.ui.control.Button
        calibration                  matlab.ui.control.DropDown
        nodeEnc2label                matlab.ui.control.Label
        nodeEnc1label                matlab.ui.control.Label
        incremental                  matlab.ui.control.Button
        filtvel                      matlab.ui.control.StateButton
        brutalfilt                   matlab.ui.control.EditField
        offsetEncoder0               matlab.ui.control.Button
        cut                          matlab.ui.control.Button
        outlayers                    matlab.ui.control.Button
        smooth                       matlab.ui.control.EditField
        decimate                     matlab.ui.control.EditField
        trigger                      matlab.ui.control.Button
        runningMean                  matlab.ui.control.Button
        offset                       matlab.ui.control.Button
        cutDt                        matlab.ui.control.EditField
        AdjRate                      matlab.ui.control.CheckBox
        zoom                         matlab.ui.control.Button
        edit1                        matlab.ui.control.EditField
        text13                       matlab.ui.control.Label
        axes1                        matlab.ui.control.UIAxes
        axes2                        matlab.ui.control.UIAxes
        axes3                        matlab.ui.control.UIAxes
        axes4                        matlab.ui.control.UIAxes
        axes5                        matlab.ui.control.UIAxes
        axes6                        matlab.ui.control.UIAxes
    end


    properties (Access = private)
    end

    methods (Access = private)

        function plotta_ora(app, handles)
            %% PLOT

            hOb=app.XLab;
            h_ele=find(strcmp(hOb.Items, hOb.Value));
            if h_ele==2
                handles.X=handles.Time./handles.tconv;
            elseif h_ele==1 
                handles.X=handles.Rate;
            elseif and(h_ele==3, any(strcmp(fieldnames(handles),'slip')))
                handles.X=handles.slip;
            elseif and(h_ele==3, any(strcmp(fieldnames(handles),'slipF')))
                handles.X=handles.slipF;
            else 
                handles.X=handles.Rate;
            end
            
            if isfield(handles,'zoom')
            else
                handles.zoom=0;
            end

            stato=handles.zoom;
            
            posx=get(handles.axes1,'XLim');

            eval(['plot(handles.X,handles.' handles.column{(handles.g1)} ',''ob'',''parent'',handles.axes1);']);
            legend(handles.axes1,[handles.column{handles.g1}])
            lim1=get(handles.axes1,'Ylim'); a=findobj('Tag','lim1S'); set(a,'Value',lim1(:,2)); b=findobj('Tag','lim1I'); set(b,'Value',lim1(:,1));
            if (stato==1); set(handles.axes1,'XLim',posx); end

            eval(['plot(handles.X,handles.' handles.column{(handles.g2)} ',''ob'',''parent'',handles.axes2);']);
            legend(handles.axes2,[handles.column{handles.g2}])
            lim2=get(handles.axes2,'Ylim'); a=findobj('Tag','lim2S'); set(a,'Value',lim2(:,2)); b=findobj('Tag','lim2I'); set(b,'Value',lim2(:,1));
            if (stato==1); set(handles.axes2,'XLim',posx); end

            eval(['plot(handles.X,handles.' handles.column{(handles.g3)} ',''ob'',''parent'',handles.axes3);']);
            legend(handles.axes3,[handles.column{handles.g3}])
            lim3=get(handles.axes3,'Ylim'); a=findobj('Tag','lim3S'); set(a,'Value',lim3(:,2)); b=findobj('Tag','lim3I'); set(b,'Value',lim3(:,1));
            if (stato ==1) ; set(handles.axes3,'XLim',[posx]); end

        end

        function ll = trovaasse(app, asse, xi)

            Xax1=findobj(asse,'Type','line');
            t_cut=Xax1(1).XData;
            mat(1,:)=abs(t_cut-ones(size(t_cut))*xi(1));
            ll(:,1)=find(mat(1,:)==min(mat(1,:)));
        end

        function X = trovadataX(app, asse)

            h_ele1=findobj(asse,'Type','line');
            X=h_ele1(1).XData;
        end
        
    end
    
    methods (Access = public)
        
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function shivaUNIX_OpeningFcn(app, varargin)
            % --- Executes just before shivaUNIX is made visible.

            % Ensure that the app appears on screen when run
            movegui(app.figure1, 'onscreen');

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app); %#ok<ASGLU>

            % This function has no output args, see OutputFcn.
            % hObject    handle to figure
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            % varargin   command line arguments to shivaUNIX (see VARARGIN)
            % Function to maximize the window via undocumented Java call.
            % Reference: http://undocumentedmatlab.com/blog/minimize-maximize-figure-window

            % Preparation of paths
            % go to root
            thisFilePath = mfilename('fullpath');
            cd(fileparts(thisFilePath))
            cd ..
            % add all subfolders to path
            addpath(genpath(pwd))

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

        % Menu selected function: close
        function close_Callback(app, event)
            % --------------------------------------------------------------------

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to CloseMenuItem (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            app.figure1.WindowStyle = 'normal';
     
            selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                ['Close ' get(handles.figure1,'Name') '...'],...
                'Yes','No','Yes');

            app.figure1.WindowStyle = 'alwaysontop';
            
            if strcmp(selection,'No')
                return;
            end

            delete(handles.figure1)
        end

        % Value changed function: Gefran
        function Gefran_Callback(app, event)
            %% --- Executes on button press in Gefran.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to Gefran (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            % Hint: get(hObject,'Value') returns toggle state of Gefran
            stato=get(hObject,'Value');

            if stato==1
                ButtonName = questdlg('GEFRAN preliminary operations: (1) identify the main sampling rate with cut_dt (2) decimate the data to 1s', ...
                    'Do you want to proceed now?', 'No', 'Yes','No');

                switch ButtonName
                    case 'No'
                        disp('no');
                        set(hObject,'Value',0);
                    case 'Yes'

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

        % Menu selected function: load
        function load_Callback(app, event)
            %% LOAD --------------------------------------------------------------------

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

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

            ax_=findobj('Tag','edit1'); set(ax_,'Value',string(handles.g1));
            ax_=findobj('Tag','edit2'); set(ax_,'Value',string(handles.g2));
            ax_=findobj('Tag','edit3'); set(ax_,'Value',string(handles.g3));

            h_=findobj('Tag','edit1LB'); set(h_,'Value',1);
            h_=findobj('Tag','edit2LB'); set(h_,'Value',1);
            h_=findobj('Tag','edit3LB'); set(h_,'Value',1);

            app.figure1.WindowStyle = 'normal';
            [FileName,PathName] = uigetfile('*.*','All Files (*.*)', ...
                '\\10.164.3.225\spagnuolo\SHIVA-ACQ');
            app.figure1.WindowStyle = 'alwaysontop';

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

            %set(h_,'Value',handles.dt);

            handles.filename=FileName;

            handles.sm=0;
            handles.triggered=0;
            handles.cutted=[0 0];
            handles.loadT=0;
            handles.shearT=0;
            ll=1;
            nn=length(data.Time);

            handles.column=fieldnames(data);

            for i=1:length(handles.column)
                handles.(handles.column{i})=data.(handles.column{i}); %debuggato
                %     eval(['handles.' handles.column{i} '=data.' handles.column{i} ';'])
            end

            h_=findobj('Tag','edit1LB'); set(h_,'Value',handles.column);
            h_=findobj('Tag','edit2LB'); set(h_,'Value',handles.column);
            h_=findobj('Tag','edit3LB'); set(h_,'Value',handles.column);

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
            handles.zoom=0;

            guidata(hObject, handles);
            guidata(hObject, new);


            plotta_ora(app, handles);
        end

        % Menu selected function: open
        function open_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

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
                    if ~isempty(strfind(fname{i},'GEF'))
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

            ax_=app.edit1; set(ax_,'Value',string(handles.g1));
            ax_=app.edit2; set(ax_,'Value',string(handles.g2));
            ax_=app.edit3; set(ax_,'Value',string(handles.g3));

            app.figure1.WindowStyle = 'normal';
            [FileName,PathName] = uigetfile('*.*','All Files (*.*)', ...
                '\\10.164.3.225\spagnuolo\SHIVA-ACQ');
            app.figure1.WindowStyle = 'alwaysontop';


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
                if and(any(strcmp(fieldnames(handles),'column')), strcmp(A,2)) 
                    handles.column{i-1}={[char(handles.column(i-1)), '2']};
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


            %set(h_,'Value',handles.dt);

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
            handles.zoom=0;

            guidata(hObject, handles);

            plotta_ora(app, handles);
        end

        % Value changed function: XLab
        function XLab_Callback(app, event)
            % --- Executes on button press in XLab.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to XLab (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            % hObject    handle to XLab (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            % Hint: get(hObject,'Value') returns toggle state of XLab

            h_ele=get(hObject,'Value');
            handles.X=trovadataX(app, handles.axes1);

            guidata(hObject, handles);

            plotta_ora(app, handles);
        end

        % Menu selected function: saveBinary
        function saveBinary_Callback(app, event)
            %% write BINARY --------------------------------------------------------------

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to binary (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            app.figure1.WindowStyle='normal';
            [nome,pat]=uiputfile( ...
                {'*.txt', 'All MATLAB Files (*txt)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Write as',['~/',handles.filename]);
            app.figure1.WindowStyle='alwaysontop';
            cd (pat)

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
            nome2=[nome, 'RED.txt'];
            fid = fopen(nome2,'wt');
            eval(['fprintf(fid,''' S1 ''',' M1 ');'])

            eval(['len=length(handles.' handles.column{1} ');'])

            for l=1:len
                eval(['fprintf(fid,''' C1 ''',' N1 ');'])
            end
            fclose(fid);
            if ~ strcmp(fieldnames(handles),'dt'); msgbox('ATTENTION: handles.dt=none'); end
        end

        % Value changed function: brutalfilt
        function brutalfilt_Callback(app, event)
            %% FIT

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to brutalfilt (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            % Hints: get(hObject,'Value') returns contents of brutalfilt as text
            %        str2double(get(hObject,'Value')) returns contents of brutalfilt as a double


            set(hObject,'Enable','on','BackGroundColor','white')
            handles.brut=str2num(app.brutalfilt.Value);

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
            s=str2double(get(h_,'Value'));  %numero della colonna

            % brutal filter & store in handles

            handles.([handles.column{s} 'o'])=handles.(handles.column{s});
            handles.([handles.column{s}])=brutal_filter_fx(1024,0.9,handles.brut,handles.(handles.column{s}),handles.Stamp);

            % store in column vector
            if ~strcmp(handles.column,{[handles.column{s} 'o']})
                handles.column(end+1)={[handles.column{s} 'o']};
            end

            h_=findobj('Tag','edit1LB'); set(h_,'Value',handles.column);
            h_=findobj('Tag','edit2LB'); set(h_,'Value',handles.column);
            h_=findobj('Tag','edit3LB'); set(h_,'Value',handles.column);

            guidata(hObject, handles);

            plotta_ora(app, handles);
        end

        % Button pushed function: cut
        function cut_Callback(app, event)
            %% --- Executes on button press in cut.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to cut (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            hOb=findobj('Tag','XLab');
            h_ele=get(hOb,'Value');
            t_cut=trovadataX(app, handles.axes1);

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
            plotta_ora(app, handles);
        end

        % Value changed function: cutDt
        function cutDt_Callback(app, event)
            %% --- Executes on button press in cut_dt

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to cut_dt (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            % Hints: get(hObject,'Value') returns contents of cut_dt as text
            %        str2double(get(hObject,'Value')) returns contents of cut_dt as a double
            set(hObject,'Enable','on')


            handles.dt=str2double(get(hObject,'Value'));
            %set(hObject,'Value',handles.dt,'BackgroundColor',[0.75 0.75 0.75])
            ll=find(handles.Stamp(:,1)==handles.dt); %,1,'first');
            if length(ll) <= 100; h=msgbox('attention: number of residuals less than 100'); waitfor(h); return; end
            %nn=find(handles.Stamp(:,1)==handles.dt,1,'last');

            for n=1:length(handles.column)
                eval(['handles.' handles.column{n} ' = handles.' handles.column{n} '(ll,1);'])
            end

            set(hObject,'Value','cut_dt')
            guidata(hObject, handles);
            plotta_ora(app, handles);
        end

        % Value changed function: decimate
        function decimate_Callback(app, event)
            %% --- Executes on button press in decimate.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to decimate (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            if ~any(strcmp(fieldnames(handles),'column')); err=msgbox('no data stored!'); waitfor(err); return; end

            set(hObject,'Enable','on','BackGroundColor','white')
            handles.Ndec=str2num(get(hObject,'Value'));
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
            plotta_ora(app, handles);
        end

        % Value changed function: edit1
        function edit1_Callback(app, event)
            %% EDIT1

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to edit1 (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
                set(hObject,'BackgroundColor','white');
            end

            handles.g1=str2double(get(hObject,'Value'));

            if handles.g1 ~= handles.g1

                app.figure1.WindowStyle = 'normal';
                [s,v] = listdlg('PromptString','Select a file:',...
                    'SelectionMode','single',...
                    'ListString',handles.column);
                app.figure1.WindowStyle = 'alwaysontop';

                handles.g1=s; %str2double(get(hObject,'Value'));
            end

            guidata(hObject, handles);
            app.edit1.Value = num2str(handles.g1);

            hOb=app.XLab;
            h_ele=hOb.Value;
            handles.X=trovadataX(app, handles.axes1);

            eval(['plot(handles.X,handles.' handles.column{(handles.g1)} ',''ob'',''parent'',handles.axes1);']);
            legend(handles.axes1,[handles.column{handles.g1}],'Interpreter','None')
        end

        % Value changed function: edit2
        function edit2_Callback(app, event)
            %% EDIT2

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to edit2 (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            handles.g2=str2double(get(hObject,'Value'));

            if handles.g2 ~= handles.g2

                app.figure1.WindowStyle = 'normal';
                [s,v] = listdlg('PromptString','Select a file:',...
                    'SelectionMode','single',...
                    'ListString',handles.column);
                app.figure1.WindowStyle = 'alwaysontop';

                handles.g2=s; %str2double(get(hObject,'Value'));
            end
            guidata(hObject, handles);
            app.edit2.Value = num2str(handles.g2);

            hOb=app.XLab;
            h_ele=hOb.Value;
            handles.X=trovadataX(app, handles.axes1);

            eval(['plot(handles.X,handles.' handles.column{(handles.g2)} ',''ob'',''parent'',handles.axes2);']);
            legend(handles.axes2,[handles.column{handles.g2}],'Interpreter','None')
        end

        % Value changed function: edit3
        function edit3_Callback(app, event)
            %% EDIT3

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to edit3 (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            handles.g3=str2double(get(hObject,'Value'));

            if handles.g3 ~= handles.g3

                app.figure1.WindowStyle = 'normal';
                [s,v] = listdlg('PromptString','Select a file:',...
                    'SelectionMode','single',...
                    'ListString',handles.column);
                app.figure1.WindowStyle = 'alwaysontop';

                handles.g3=s; %str2double(get(hObject,'Value'));
            end
            guidata(hObject, handles);
            app.edit3.Value = num2str(handles.g3);

            hOb=app.XLab;
            h_ele=hOb.Value;
            handles.X=trovadataX(app, handles.axes1);

            eval(['plot(handles.X,handles.' handles.column{(handles.g3)} ',''ob'',''parent'',handles.axes3);']);
            legend(handles.axes3,[handles.column{handles.g3}],'Interpreter','None')
        end

        % Button pushed function: fft
        function fft_Callback(app, event)
            %% --- Executes on button press in fft.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to fft (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            hOb=findobj('Tag','XLab');
            h_ele=get(hOb,'Value');
            t_cut=trovadataX(app, handles.axes1);

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
            s=str2double(get(h_,'Value'));  %numero della colonna

            eval(['mmed_torq=mean(smooth(handles.' handles.column{s} '(1:100,:)));']);
            eval(['handles.' handles.column{s} '=handles.' handles.column{s} '- mmed_torq;']);

            %tapering

            eval(['handles.' handles.column{s} '=handles.' handles.column{s} '(I1:I2).*hamming(length(handles.Stamp(I1:I2)));'])
            dt=mode(handles.Stamp(I1:I2)); %str2double(get(h_,'Value'));

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

        % Value changed function: filtvel
        function filtvel_Callback(app, event)
            % --- Executes on button press in filtvel.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

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

        % Button pushed function: offsetEncoder0
        function offsetEncoder0_Callback(app, event)
            % --- Executes on button press in off_enc_0.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to off_enc_0 (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            I=handles.triggered;
            handles.Encoder2(1:I)=0;
            handles.Encoder(1:I)=0;
            guidata(hObject, handles);
        end

        % Button pushed function: offset
        function offset_Callback(app, event)
            % --- Executes on button press in offset.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to offset (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            % hObject    handle to offset_1 (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            app.figure1.WindowStyle = 'normal';
            [sel,v] = listdlg('PromptString','Select a file:',...
                'SelectionMode','multiple',...
                'ListString',handles.column);
            app.figure1.WindowStyle = 'alwaysontop';

            h_=handles.column(sel);
            hOb=app.XLab;
            h_ele=get(hOb,'Value');
            % htype=get(hOb,'Value');
            [xi,yi]=ginput(1);
            ll=trovaasse(app, handles.axes1,xi);

            ax_=get(gcf,'CurrentAxes');
            for n=1:3
                eval(['s=find(ax_==handles.axes' num2str(n) ');']);
                if s==1; break; end
            end
            posy=get(ax_,'Ylim');
            posx=get(ax_,'Xlim');


            eval(['h_=findobj(''Tag'',''edit' num2str(n) ''');']); %n=numero asse
            colonna=str2double(get(h_,'Value'));                        %numero della colonna

            for n=sel
                eval(['handles.' handles.column{n} ' =handles.' handles.column{n} '-handles.' handles.column{n} '(ll(:,1),:);']);
                %eval(['handles.' handles.column{n} '(1:ll(:,1),:)=0;'])
            end

            nsel=find(strcmp(handles.column(sel),'Axial'));
            if isempty(nsel)
                handles.shearT=handles.RateZero(ll);
            else
                handles.loadT=handles.RateZero(ll);
            end

            h_=findobj('Tag','edit1');
            s1=str2double(get(h_,'Value'));
            h_=findobj('Tag','edit2');
            s2=str2double(get(h_,'Value'));
            h_=findobj('Tag','edit3');
            s3=str2double(get(h_,'Value'));

            guidata(hObject, handles);
            plotta_ora(app, handles);
        end

        % Button pushed function: outlayers
        function outlayers_Callback(app, event)
            % --- Executes on button press in outlayers.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to outlayers (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            %zoom xon;
            hOb=findobj('Tag','XLab');
            h_ele=get(hOb,'Value');
            t_cut=trovadataX(app, handles.axes1);

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
            s=str2double(get(h_,'Value'));  %numero della colonna


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

            plotta_ora(app, handles);
        end

        % Menu selected function: print
        function print_Callback(app, event)
            % PRINT---------------------------------------------------------

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to file (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            hf=figure;
            hn_=copyobj(handles.axes1,hf); h1=get(hn_,'Position'); h1(1)=h1(1)+0.1; set(hn_,'Position',h1);
            ah_=get(handles.axes1,'children'); nom=get(ah_,'DisplayName');
            hnl_=get(hn_,'YLabel'); set(hnl_,'String',nom)

            hn_=copyobj(handles.axes2,hf); h1=get(hn_,'Position'); h1(1)=h1(1)+0.1; set(hn_,'Position',h1);
            ah_=get(handles.axes2,'children'); nom=get(ah_,'DisplayName');
            hnl_=get(hn_,'YLabel'); set(hnl_,'String',nom)

            hn_=copyobj(handles.axes3,hf); h1=get(hn_,'Position'); h1(1)=h1(1)+0.1; set(hn_,'Position',h1);
            ah_=get(handles.axes3,'children'); nom=get(ah_,'DisplayName');
            hnl_=get(hn_,'YLabel'); set(hnl_,'String',nom)
        end

        % Button pushed function: refreshTemperature
        function refreshTemperature_Callback(app, event)
            %% refresh temperature callback
            % --- Executes on button press in pushbutton18.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

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

            % h_=findobj('Tag','edit1LB'); set(h_,'Value',handles.column)
            % h_=findobj('Tag','edit2LB'); set(h_,'Value',handles.column)
            % h_=findobj('Tag','edit3LB'); set(h_,'Value',handles.column)
            %
            %
            % handles.Done=1;
            % handles.new=fieldnames(new)';
            guidata(hObject, handles);
            % plotta_ora(handles)
        end

        % Button pushed function: refreshTau
        function refreshTau_Callback(app, event)
            %% refresh_tau callback
            % --- Executes on button press in pushbutton19.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to pushbutton19 (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            %% preamble
            %definisce la calibrazion

            if any(strcmp(fieldnames(handles),'smooth'))
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



            dint=findobj('Tag','Rint'); rint=str2double(get(dint,'Value'))/2000;
            dext=findobj('Tag','Rext'); rext=str2double(get(dext,'Value'))/2000;

            h_=app.calibration; contents=find(strcmp(h_.Items, h_.Value));

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

            h_=findobj('Tag','edit1LB'); set(h_,'Value',handles.column)
            h_=findobj('Tag','edit2LB'); set(h_,'Value',handles.column)
            h_=findobj('Tag','edit3LB'); set(h_,'Value',handles.column)


            handles.Done=1;
            handles.new=fieldnames(new)';
            guidata(hObject, handles);
            plotta_ora(app, handles);
        end

        % Button pushed function: calibrate
        function calibrate_Callback(app, event)
            %% calibrate callback
            % --- Executes on button press in pushbutton20.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to pushbutton20 (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            % hObject    handle to calibration (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            % 1. Raccogli i parametri dalla UI di App Designer
            cal_params = struct();
            cal_params.rint = str2double(app.Rint.Value)/2000;
            cal_params.rext = str2double(app.Rext.Value)/2000;
            cal_params.calibration_index = find(strcmp(app.calibration.Items, app.calibration.Value));
            cal_params.node1_str = app.nodeEnc1.Value;
            cal_params.node2_str = app.nodeEnc2.Value;
            cal_params.is_GH = app.GH.Value;
            cal_params.is_TC = app.TC.Value;
            cal_params.is_vac = app.vac.Value;
            cal_params.is_thickness = app.get_thickness.Value;
            cal_params.ztl = str2double(app.zeroThicknessLVDT.Value);
            cal_params.zts = str2double(app.zeroThicknessLVDTShort.Value);
            cal_params.is_gefran = app.Gefran.Value;
            cal_params.is_adjrate = app.AdjRate.Value;
            cal_params.is_torque_ctrl = app.Torque.Value;
            cal_params.popup_PF_index = find(strcmp(app.popupPF.Items, app.popupPF.Value));
            cal_params.popup_PC_index = find(strcmp(app.popupPC.Items, app.popupPC.Value));
            
            AIstate=zeros(1,18);
            for L=1:18
                if isprop(app,['popupAI',num2str(L)]) == 0
                else
                    h=app.(['popupAI',num2str(L)]);
                    AIstate(L)=find(strcmp(h.Items, h.Value));
                end
            end
            cal_params.AI_states = AIstate;
            
            % 2. Chiama la funzione di calibrazione esterna
            handles = calibrate_data(handles, cal_params);
            
            % 3. Aggiorna la UI
            % In App Designer, l'aggiornamento dei campi di testo/liste
            % potrebbe richiedere un approccio diverso, ma per ora ci concentriamo
            % sulla logica.
            
            guidata(hObject, handles);
            plotta_ora(app, handles);
        end

        % Button pushed function: unwrap
        function unwrap_Callback(app, event)
            %% generate unwrap
            % --- Executes on button press in pushbutton22.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

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

            h_=findobj('Tag','edit1LB'); set(h_,'Value',handles.column)
            h_=findobj('Tag','edit2LB'); set(h_,'Value',handles.column)
            h_=findobj('Tag','edit3LB'); set(h_,'Value',handles.column)


            handles.Done=1;
            guidata(hObject, handles);
            plotta_ora(app, handles);
        end

        % Button pushed function: refreshThickness
        function refreshThickness_Callback(app, event)
            %% calculate gouge layer thickness
            % --- Executes on button press in refresh_thickness.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to refresh_thickness (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            cal.lv(1)=5.0634;
            cal.lv(2)=0.3;

            h_=findobj('Tag','zero_thickness_long'); % volts
            ztl=get(h_,'Value');
            ztl=str2double(ztl);

            h_=findobj('Tag','zero_thickness_short'); % mm
            zts=get(h_,'Value');
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

            h_=findobj('Tag','edit1LB'); set(h_,'Value',handles.column)
            h_=findobj('Tag','edit2LB'); set(h_,'Value',handles.column)
            h_=findobj('Tag','edit3LB'); set(h_,'Value',handles.column)


            handles.Done=1;
            handles.new=fieldnames(new)';
            guidata(hObject, handles);
            plotta_ora(app, handles);
        end

        % Button pushed function: runningMean
        function runningMean_Callback(app, event)
            %% --- Executes on button press in running.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to running (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            hOb=app.XLab;
            h_ele=get(hOb,'Value');
            t_cut=trovadataX(app, handles.axes1);
            [xi,yi]=ginput(2);
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

            % eval(['h_=findobj(''Tag'',''edit' num2str(n) ''');']); %n=numero asse
            h_ = app.(['edit',num2str(n)]); %n=numero asse
            s=str2double(get(h_,'Value'));                        %numero della colonna

            %cla
            x_variable = strsplit(app.XLab.Value, ' '); x_variable{1};

            eval(['mmed_torq=mean(smooth(handles.' handles.column{s} '(ll(:,1):ll(:,2),:)));']);
            eval(['handles.' handles.column{s} '=handles. ' handles.column{s} '- mmed_torq;']);
            plot(handles.(x_variable{1}),handles.(handles.column{s}),'ob','parent',handles.(['axes',num2str(finestra)]));
            set(ax_,'Xlim',posx)

            guidata(hObject, handles);
            plotta_ora(app, handles);
        end

        % Menu selected function: saveRED
        function saveRED_Callback(app, event)
            %% SAVERED--------------------------------------------------------------------

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to saveRED (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            % hObject    handle to save (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            pat0=pwd;

            app.figure1.WindowStyle='normal';
            [nome,pat]=uiputfile( ...
                {'*.m;*.fig;*.mat;*.mdl', 'All MATLAB Files (*.m, *.fig, *.mat, *.mdl)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Save as',[pat0 '/' handles.filename]);
            app.figure1.WindowStyle='alwaysontop';
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

        % Menu selected function: save
        function save_Callback(app, event)
            %% SAVE--------------------------------------------------------------------

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to save (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            pat0=pwd;

            app.figure1.WindowStyle='normal';
            [nome,pat]=uiputfile( ...
                {'*.m;*.fig;*.mat;*.mdl', 'All MATLAB Files (*.m, *.fig, *.mat, *.mdl)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Save as',[pat0 '/' handles.filename]);
            app.figure1.WindowStyle='alwaysontop';
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

        % Value changed function: smooth
        function smooth_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to smooth (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)

            % Hints: get(hObject,'Value') returns contents of smooth as text
            %        str2double(get(hObject,'Value')) returns contents of smooth as a double

            set(hObject,'Enable','on','BackGroundColor','white')
            handles.sm=str2num(app.smooth.Value);

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

            h_=app.(['edit',num2str(n)]); %n=numero asse
            s=str2double(get(h_,'Value'));  %numero della colonna

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

            h_=findobj('Tag','edit1LB'); set(h_,'Value',handles.column);
            h_=findobj('Tag','edit2LB'); set(h_,'Value',handles.column);
            h_=findobj('Tag','edit3LB'); set(h_,'Value',handles.column);



            guidata(hObject, handles);

            plotta_ora(app, handles);
        end

        % Button pushed function: trigger
        function trigger_Callback(app, event)
            % --- Executes on button press in trigger.

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to trigger (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            hOb=app.XLab;
            h_ele=get(hOb,'Value');
            t_cut=trovadataX(app, handles.axes1);

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

            set(hOb,'Value',hOb.Items(2))


            ax_=get(handles.axes1,'Children'); dataY=get(ax_,'YData'); dataX=get(ax_,'XData');
            set(ax_,'XData',handles.Time,'YData',dataY); set(handles.axes1,'XLim',[handles.Time(1) handles.Time(end)]);
            ax_=get(handles.axes2,'Children'); dataY=get(ax_,'YData'); dataX=get(ax_,'XData');
            set(ax_,'XData',handles.Time,'YData',dataY); set(handles.axes1,'XLim',[handles.Time(1) handles.Time(end)]);
            ax_=get(handles.axes3,'Children'); dataY=get(ax_,'YData'); dataX=get(ax_,'XData');
            set(ax_,'XData',handles.Time,'YData',dataY); set(handles.axes1,'XLim',[handles.Time(1) handles.Time(end)]);

            guidata(hObject, handles);
            plotta_ora(app, handles);
        end

        % Menu selected function: write
        function write_Callback(app, event)
            %% WRITE --------------------------------------------------------------------

            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to write (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            app.figure1.WindowStyle='normal';
            [nome,pat]=uiputfile( ...
                {'*.txt', 'All MATLAB Files (*txt)'; ...
                '*.*',                   'All Files (*.*)'}, ...
                'Write as',['~/',handles.filename]);
            app.figure1.WindowStyle='alwaysontop';
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

        % Button pushed function: zoom
        function zoom_Callback(app, event)
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            pippo=[handles.axes1, handles.axes2,handles.axes3];
            linkaxes(pippo,'x');
            
            zoom on;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create figure1 and hide until all components are created
            app.figure1 = uifigure('Visible', 'off');
            colormap(app.figure1, 'parula');
            app.figure1.Position = [772 -59 1179 653];
            app.figure1.Name = 'shivaUNIX';
            app.figure1.HandleVisibility = 'callback';
            app.figure1.Tag = 'figure1';
            app.figure1.WindowStyle = 'alwaysontop';

            % Create File
            app.File = uimenu(app.figure1);
            app.File.Text = 'File';
            app.File.Tag = 'File';

            % Create open
            app.open = uimenu(app.File);
            app.open.MenuSelectedFcn = createCallbackFcn(app, @open_Callback, true);
            app.open.Accelerator = 'o';
            app.open.Text = 'Open 1710-->';
            app.open.Tag = 'OpenMenuItem2';

            % Create close
            app.close = uimenu(app.File);
            app.close.MenuSelectedFcn = createCallbackFcn(app, @close_Callback, true);
            app.close.Separator = 'on';
            app.close.Text = 'Close';
            app.close.Tag = 'CloseMenuItem';

            % Create save
            app.save = uimenu(app.File);
            app.save.MenuSelectedFcn = createCallbackFcn(app, @save_Callback, true);
            app.save.Accelerator = 's';
            app.save.Text = 'Save (as .mat)';
            app.save.Tag = 'save';

            % Create write
            app.write = uimenu(app.File);
            app.write.MenuSelectedFcn = createCallbackFcn(app, @write_Callback, true);
            app.write.Text = 'Write (as .txt)';
            app.write.Tag = 'write';

            % Create load
            app.load = uimenu(app.File);
            app.load.MenuSelectedFcn = createCallbackFcn(app, @load_Callback, true);
            app.load.Accelerator = 'l';
            app.load.Text = 'Load (.mat)';
            app.load.Tag = 'Load';

            % Create saveBinary
            app.saveBinary = uimenu(app.File);
            app.saveBinary.MenuSelectedFcn = createCallbackFcn(app, @saveBinary_Callback, true);
            app.saveBinary.Text = 'Save to bin';
            app.saveBinary.Tag = 'binary';

            % Create saveRED
            app.saveRED = uimenu(app.File);
            app.saveRED.MenuSelectedFcn = createCallbackFcn(app, @saveRED_Callback, true);
            app.saveRED.Text = 'Save reduced';
            app.saveRED.Tag = 'saveRED';

            % Create Figure
            app.Figure = uimenu(app.figure1);
            app.Figure.Text = 'Figure';
            app.Figure.Tag = 'Figure';

            % Create print
            app.print = uimenu(app.Figure);
            app.print.MenuSelectedFcn = createCallbackFcn(app, @print_Callback, true);
            app.print.Text = 'Print';
            app.print.Tag = 'print';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.figure1);
            app.GridLayout.ColumnWidth = {'1x', '15x', '5x', '15x', '3x', '3x', '3x', '3x', '3x', '3x', '3x'};
            app.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout.ColumnSpacing = 5;
            app.GridLayout.RowSpacing = 1;
            app.GridLayout.Padding = [5 1 5 1];

            % Create axes6
            app.axes6 = uiaxes(app.GridLayout);
            app.axes6.FontSize = 1;
            app.axes6.NextPlot = 'replace';
            app.axes6.Layout.Row = [2 4];
            app.axes6.Layout.Column = 11;
            app.axes6.Tag = 'axes6';

            % Create axes5
            app.axes5 = uiaxes(app.GridLayout);
            app.axes5.FontSize = 12;
            app.axes5.NextPlot = 'replace';
            app.axes5.Layout.Row = [24 28];
            app.axes5.Layout.Column = [6 11];
            app.axes5.Tag = 'axes5';

            % Create axes4
            app.axes4 = uiaxes(app.GridLayout);
            app.axes4.FontSize = 12;
            app.axes4.NextPlot = 'replace';
            app.axes4.Layout.Row = [18 22];
            app.axes4.Layout.Column = [6 11];
            app.axes4.Tag = 'axes4';

            % Create axes3
            app.axes3 = uiaxes(app.GridLayout);
            app.axes3.CameraPosition = [0.5 0.5 9.16025403784439];
            app.axes3.CameraTarget = [0.5 0.5 0.5];
            app.axes3.CameraUpVector = [0 1 0];
            app.axes3.CameraViewAngle = 6.60861036031192;
            app.axes3.DataAspectRatio = [1 1 1];
            app.axes3.PlotBoxAspectRatio = [1 1 1];
            app.axes3.XLim = [0 1];
            app.axes3.YLim = [0 1];
            app.axes3.ZLim = [0 1];
            app.axes3.CLim = [0 1];
            app.axes3.ALim = [0 1];
            app.axes3.XTick = [0 0.2 0.4 0.6 0.8 1];
            app.axes3.XTickLabel = {'0  '; '0.2'; '0.4'; '0.6'; '0.8'; '1  '};
            app.axes3.YTick = [0 0.2 0.4 0.6 0.8 1];
            app.axes3.YTickLabel = {'0  '; '0.2'; '0.4'; '0.6'; '0.8'; '1  '};
            app.axes3.ZTick = [0 0.5 1];
            app.axes3.ZTickLabel = '';
            app.axes3.TickDir = 'in';
            app.axes3.FontSize = 12;
            app.axes3.NextPlot = 'replace';
            app.axes3.Layout.Row = [21 28];
            app.axes3.Layout.Column = [1 4];
            app.axes3.Tag = 'axes3';

            % Create axes2
            app.axes2 = uiaxes(app.GridLayout);
            app.axes2.CameraPosition = [0.5 0.5 9.16025403784439];
            app.axes2.CameraTarget = [0.5 0.5 0.5];
            app.axes2.CameraUpVector = [0 1 0];
            app.axes2.CameraViewAngle = 6.60861036031192;
            app.axes2.DataAspectRatio = [1 1 1];
            app.axes2.PlotBoxAspectRatio = [1 1 1];
            app.axes2.XLim = [0 1];
            app.axes2.YLim = [0 1];
            app.axes2.ZLim = [0 1];
            app.axes2.CLim = [0 1];
            app.axes2.ALim = [0 1];
            app.axes2.XTick = [0 0.2 0.4 0.6 0.8 1];
            app.axes2.XTickLabel = {'0  '; '0.2'; '0.4'; '0.6'; '0.8'; '1  '};
            app.axes2.YTick = [0 0.2 0.4 0.6 0.8 1];
            app.axes2.YTickLabel = {'0  '; '0.2'; '0.4'; '0.6'; '0.8'; '1  '};
            app.axes2.ZTick = [0 0.5 1];
            app.axes2.ZTickLabel = '';
            app.axes2.TickDir = 'in';
            app.axes2.FontSize = 12;
            app.axes2.NextPlot = 'replace';
            app.axes2.Layout.Row = [12 19];
            app.axes2.Layout.Column = [1 4];
            app.axes2.Tag = 'axes2';

            % Create axes1
            app.axes1 = uiaxes(app.GridLayout);
            app.axes1.CameraPosition = [0.5 0.5 9.16025403784439];
            app.axes1.CameraTarget = [0.5 0.5 0.5];
            app.axes1.CameraUpVector = [0 1 0];
            app.axes1.CameraViewAngle = 6.60861036031192;
            app.axes1.DataAspectRatio = [1 1 1];
            app.axes1.PlotBoxAspectRatio = [1 1 1];
            app.axes1.XLim = [0 1];
            app.axes1.YLim = [0 1];
            app.axes1.ZLim = [0 1];
            app.axes1.CLim = [0 1];
            app.axes1.ALim = [0 1];
            app.axes1.XTick = [0 0.2 0.4 0.6 0.8 1];
            app.axes1.XTickLabel = {'0  '; '0.2'; '0.4'; '0.6'; '0.8'; '1  '};
            app.axes1.YTick = [0 0.2 0.4 0.6 0.8 1];
            app.axes1.YTickLabel = {'0  '; '0.2'; '0.4'; '0.6'; '0.8'; '1  '};
            app.axes1.ZTick = [0 0.5 1];
            app.axes1.ZTickLabel = '';
            app.axes1.TickDir = 'in';
            app.axes1.FontSize = 12;
            app.axes1.NextPlot = 'replace';
            app.axes1.Layout.Row = [2 9];
            app.axes1.Layout.Column = [1 4];
            app.axes1.Tag = 'axes1';

            % Create text13
            app.text13 = uilabel(app.GridLayout);
            app.text13.Tag = 'text13';
            app.text13.HorizontalAlignment = 'center';
            app.text13.VerticalAlignment = 'top';
            app.text13.WordWrap = 'on';
            app.text13.FontSize = 16;
            app.text13.FontWeight = 'bold';
            app.text13.Layout.Row = 1;
            app.text13.Layout.Column = [5 11];
            app.text13.Text = 'SHIVAunix';

            % Create edit1
            app.edit1 = uieditfield(app.GridLayout, 'text');
            app.edit1.ValueChangedFcn = createCallbackFcn(app, @edit1_Callback, true);
            app.edit1.Tag = 'edit1';
            app.edit1.HorizontalAlignment = 'center';
            app.edit1.FontSize = 10.6666666666667;
            app.edit1.Layout.Row = 2;
            app.edit1.Layout.Column = 1;
            app.edit1.Value = '2';

            % Create zoom
            app.zoom = uibutton(app.GridLayout, 'push');
            app.zoom.ButtonPushedFcn = createCallbackFcn(app, @zoom_Callback, true);
            app.zoom.Layout.Row = 2;
            app.zoom.Layout.Column = 6;
            app.zoom.Text = 'zoom';

            % Create AdjRate
            app.AdjRate = uicheckbox(app.GridLayout);
            app.AdjRate.Tag = 'AdjRate';
            app.AdjRate.Text = 'AdjRate';
            app.AdjRate.Layout.Row = 2;
            app.AdjRate.Layout.Column = 9;

            % Create cutDt
            app.cutDt = uieditfield(app.GridLayout, 'text');
            app.cutDt.ValueChangedFcn = createCallbackFcn(app, @cutDt_Callback, true);
            app.cutDt.Tag = 'cut_dt';
            app.cutDt.HorizontalAlignment = 'center';
            app.cutDt.Layout.Row = 2;
            app.cutDt.Layout.Column = 10;
            app.cutDt.Value = 'cut_dt';

            % Create offset
            app.offset = uibutton(app.GridLayout, 'push');
            app.offset.ButtonPushedFcn = createCallbackFcn(app, @offset_Callback, true);
            app.offset.Tag = 'offset';
            app.offset.Layout.Row = 3;
            app.offset.Layout.Column = 6;
            app.offset.Text = 'offset';

            % Create runningMean
            app.runningMean = uibutton(app.GridLayout, 'push');
            app.runningMean.ButtonPushedFcn = createCallbackFcn(app, @runningMean_Callback, true);
            app.runningMean.Tag = 'running';
            app.runningMean.Layout.Row = 3;
            app.runningMean.Layout.Column = 7;
            app.runningMean.Text = 'running mean';

            % Create trigger
            app.trigger = uibutton(app.GridLayout, 'push');
            app.trigger.ButtonPushedFcn = createCallbackFcn(app, @trigger_Callback, true);
            app.trigger.Tag = 'trigger';
            app.trigger.Layout.Row = 3;
            app.trigger.Layout.Column = 8;
            app.trigger.Text = 'trigger';

            % Create decimate
            app.decimate = uieditfield(app.GridLayout, 'text');
            app.decimate.ValueChangedFcn = createCallbackFcn(app, @decimate_Callback, true);
            app.decimate.Tag = 'decimate';
            app.decimate.HorizontalAlignment = 'center';
            app.decimate.Layout.Row = 3;
            app.decimate.Layout.Column = 9;
            app.decimate.Value = 'decimate';

            % Create smooth
            app.smooth = uieditfield(app.GridLayout, 'text');
            app.smooth.ValueChangedFcn = createCallbackFcn(app, @smooth_Callback, true);
            app.smooth.Tag = 'smooth';
            app.smooth.HorizontalAlignment = 'center';
            app.smooth.Layout.Row = 3;
            app.smooth.Layout.Column = 10;
            app.smooth.Value = 'smooth';

            % Create outlayers
            app.outlayers = uibutton(app.GridLayout, 'push');
            app.outlayers.ButtonPushedFcn = createCallbackFcn(app, @outlayers_Callback, true);
            app.outlayers.Tag = 'outlayers';
            app.outlayers.Layout.Row = 4;
            app.outlayers.Layout.Column = 6;
            app.outlayers.Text = 'outlayers';

            % Create cut
            app.cut = uibutton(app.GridLayout, 'push');
            app.cut.ButtonPushedFcn = createCallbackFcn(app, @cut_Callback, true);
            app.cut.Tag = 'cut';
            app.cut.Layout.Row = 4;
            app.cut.Layout.Column = 7;
            app.cut.Text = 'cut';

            % Create offsetEncoder0
            app.offsetEncoder0 = uibutton(app.GridLayout, 'push');
            app.offsetEncoder0.ButtonPushedFcn = createCallbackFcn(app, @offsetEncoder0_Callback, true);
            app.offsetEncoder0.Tag = 'off_enc_0';
            app.offsetEncoder0.Layout.Row = 4;
            app.offsetEncoder0.Layout.Column = 8;
            app.offsetEncoder0.Text = 'offset Enc 0';

            % Create brutalfilt
            app.brutalfilt = uieditfield(app.GridLayout, 'text');
            app.brutalfilt.ValueChangedFcn = createCallbackFcn(app, @brutalfilt_Callback, true);
            app.brutalfilt.Tag = 'brutalfilt';
            app.brutalfilt.HorizontalAlignment = 'center';
            app.brutalfilt.Layout.Row = 4;
            app.brutalfilt.Layout.Column = 9;
            app.brutalfilt.Value = 'brutalfilt';

            % Create filtvel
            app.filtvel = uibutton(app.GridLayout, 'state');
            app.filtvel.ValueChangedFcn = createCallbackFcn(app, @filtvel_Callback, true);
            app.filtvel.Tag = 'filtvel';
            app.filtvel.Text = 'filtvel';
            app.filtvel.Layout.Row = 4;
            app.filtvel.Layout.Column = 10;

            % Create incremental
            app.incremental = uibutton(app.GridLayout, 'push');
            app.incremental.Tag = 'incremental';
            app.incremental.Layout.Row = 5;
            app.incremental.Layout.Column = 8;
            app.incremental.Text = 'incremental';

            % Create nodeEnc1label
            app.nodeEnc1label = uilabel(app.GridLayout);
            app.nodeEnc1label.Tag = 'text7';
            app.nodeEnc1label.HorizontalAlignment = 'center';
            app.nodeEnc1label.VerticalAlignment = 'bottom';
            app.nodeEnc1label.WordWrap = 'on';
            app.nodeEnc1label.Layout.Row = 7;
            app.nodeEnc1label.Layout.Column = 5;
            app.nodeEnc1label.Text = '1';

            % Create nodeEnc2label
            app.nodeEnc2label = uilabel(app.GridLayout);
            app.nodeEnc2label.Tag = 'text8';
            app.nodeEnc2label.HorizontalAlignment = 'center';
            app.nodeEnc2label.VerticalAlignment = 'bottom';
            app.nodeEnc2label.WordWrap = 'on';
            app.nodeEnc2label.Layout.Row = 7;
            app.nodeEnc2label.Layout.Column = 6;
            app.nodeEnc2label.Text = '2';

            % Create calibration
            app.calibration = uidropdown(app.GridLayout);
            app.calibration.Items = {'calibration', '2) s0001 -- s0035', '3) s0036 -- s0236', '4) s0237 -- s0253', '5) s0254 -- s0261', '6) s0262 -- s1178', '7) s1179 -- s1231; 1.2', '8) s1232 -- s1336; 1.25', '9) s1337; 2', '10) s1338 -- s1667; 1, fc=1.25', '11) s1668 -- s1709; 1, fc =1.25', '12) s1710 -->'};
            app.calibration.Tag = 'calibration';
            app.calibration.Layout.Row = 7;
            app.calibration.Layout.Column = [7 9];
            app.calibration.Value = 'calibration';

            % Create calibrate
            app.calibrate = uibutton(app.GridLayout, 'push');
            app.calibrate.ButtonPushedFcn = createCallbackFcn(app, @calibrate_Callback, true);
            app.calibrate.Tag = 'pushbutton20';
            app.calibrate.Layout.Row = 7;
            app.calibrate.Layout.Column = [10 11];
            app.calibrate.Text = 'calibrate';

            % Create nodeEnc1
            app.nodeEnc1 = uieditfield(app.GridLayout, 'text');
            app.nodeEnc1.Tag = 'nodeEnc1';
            app.nodeEnc1.HorizontalAlignment = 'center';
            app.nodeEnc1.Layout.Row = 8;
            app.nodeEnc1.Layout.Column = 5;
            app.nodeEnc1.Value = '80, 0.9';

            % Create nodeEnc2
            app.nodeEnc2 = uieditfield(app.GridLayout, 'text');
            app.nodeEnc2.Tag = 'nodeEnc2';
            app.nodeEnc2.HorizontalAlignment = 'center';
            app.nodeEnc2.Layout.Row = 8;
            app.nodeEnc2.Layout.Column = 6;
            app.nodeEnc2.Value = '40, 0.9';

            % Create refreshThickness
            app.refreshThickness = uibutton(app.GridLayout, 'push');
            app.refreshThickness.ButtonPushedFcn = createCallbackFcn(app, @refreshThickness_Callback, true);
            app.refreshThickness.Tag = 'refresh_thickness';
            app.refreshThickness.Layout.Row = 8;
            app.refreshThickness.Layout.Column = [7 8];
            app.refreshThickness.Text = 'refresh_thickness';

            % Create text6
            app.text6 = uilabel(app.GridLayout);
            app.text6.Tag = 'text6';
            app.text6.HorizontalAlignment = 'center';
            app.text6.VerticalAlignment = 'bottom';
            app.text6.WordWrap = 'on';
            app.text6.Layout.Row = 8;
            app.text6.Layout.Column = 10;
            app.text6.Text = 'int (mm)';

            % Create text5
            app.text5 = uilabel(app.GridLayout);
            app.text5.Tag = 'text5';
            app.text5.HorizontalAlignment = 'center';
            app.text5.VerticalAlignment = 'bottom';
            app.text5.WordWrap = 'on';
            app.text5.Layout.Row = 8;
            app.text5.Layout.Column = 11;
            app.text5.Text = 'ext (mm)';

            % Create unwrap
            app.unwrap = uibutton(app.GridLayout, 'push');
            app.unwrap.ButtonPushedFcn = createCallbackFcn(app, @unwrap_Callback, true);
            app.unwrap.Tag = 'pushbutton22';
            app.unwrap.Layout.Row = 9;
            app.unwrap.Layout.Column = [5 6];
            app.unwrap.Text = 'unwrap Enc2';

            % Create refreshTau
            app.refreshTau = uibutton(app.GridLayout, 'push');
            app.refreshTau.ButtonPushedFcn = createCallbackFcn(app, @refreshTau_Callback, true);
            app.refreshTau.Tag = 'pushbutton19';
            app.refreshTau.Layout.Row = 9;
            app.refreshTau.Layout.Column = [7 8];
            app.refreshTau.Text = 'refresh_tau';

            % Create refreshTemperature
            app.refreshTemperature = uibutton(app.GridLayout, 'push');
            app.refreshTemperature.ButtonPushedFcn = createCallbackFcn(app, @refreshTemperature_Callback, true);
            app.refreshTemperature.Tag = 'pushbutton18';
            app.refreshTemperature.Layout.Row = 9;
            app.refreshTemperature.Layout.Column = 9;
            app.refreshTemperature.Text = 'refreshT';

            % Create Rint
            app.Rint = uieditfield(app.GridLayout, 'text');
            app.Rint.Tag = 'Rint';
            app.Rint.HorizontalAlignment = 'center';
            app.Rint.Layout.Row = 9;
            app.Rint.Layout.Column = 10;
            app.Rint.Value = '30';

            % Create Rext
            app.Rext = uieditfield(app.GridLayout, 'text');
            app.Rext.Tag = 'Rext';
            app.Rext.HorizontalAlignment = 'center';
            app.Rext.Layout.Row = 9;
            app.Rext.Layout.Column = 11;
            app.Rext.Value = '50';

            % Create popupPF
            app.popupPF = uidropdown(app.GridLayout);
            app.popupPF.Items = {'PoreFluid', '2) Gefran', '3) Gems', '4) Isco PA/PB'};
            app.popupPF.Tag = 'popupPF';
            app.popupPF.BackgroundColor = [1 1 1];
            app.popupPF.Layout.Row = 11;
            app.popupPF.Layout.Column = [5 6];
            app.popupPF.Value = 'PoreFluid';

            % Create Gefran
            app.Gefran = uicheckbox(app.GridLayout);
            app.Gefran.ValueChangedFcn = createCallbackFcn(app, @Gefran_Callback, true);
            app.Gefran.Tag = 'Gefran';
            app.Gefran.Text = 'Gefran';
            app.Gefran.Layout.Row = 11;
            app.Gefran.Layout.Column = [8 9];

            % Create edit2
            app.edit2 = uieditfield(app.GridLayout, 'text');
            app.edit2.ValueChangedFcn = createCallbackFcn(app, @edit2_Callback, true);
            app.edit2.Tag = 'edit2';
            app.edit2.HorizontalAlignment = 'center';
            app.edit2.FontSize = 10.6666666666667;
            app.edit2.Layout.Row = 12;
            app.edit2.Layout.Column = 1;
            app.edit2.Value = '3';

            % Create popupPC
            app.popupPC = uidropdown(app.GridLayout);
            app.popupPC.Items = {'ConfiningPressure', '2) Gefran', '3) Gems', '4) Isco PA/PB'};
            app.popupPC.Tag = 'popupPC';
            app.popupPC.BackgroundColor = [1 1 1];
            app.popupPC.Layout.Row = 12;
            app.popupPC.Layout.Column = [5 6];
            app.popupPC.Value = 'ConfiningPressure';

            % Create fluid
            app.fluid = uicheckbox(app.GridLayout);
            app.fluid.Tag = 'fluid';
            app.fluid.Text = 'Fluid Pressure';
            app.fluid.Layout.Row = 12;
            app.fluid.Layout.Column = [8 9];

            % Create popupAI6
            app.popupAI6 = uidropdown(app.GridLayout);
            app.popupAI6.Items = {'AI6', '2) Cosino', '3) TC', '4) Vacuum', '5) Isco PA/PB', '6) Isco VA/VB', '7) Isco FA/FB', '8) RH', '9) TA', '10) Other', '11) Big Motor Torque'};
            app.popupAI6.Tag = 'popupAI6';
            app.popupAI6.BackgroundColor = [1 1 1];
            app.popupAI6.Layout.Row = 12;
            app.popupAI6.Layout.Column = 10;
            app.popupAI6.Value = 'AI6';

            % Create T0
            app.T0 = uieditfield(app.GridLayout, 'text');
            app.T0.Tag = 'T0';
            app.T0.HorizontalAlignment = 'center';
            app.T0.Layout.Row = 13;
            app.T0.Layout.Column = 7;
            app.T0.Value = '23';

            % Create GH
            app.GH = uicheckbox(app.GridLayout);
            app.GH.Tag = 'GH';
            app.GH.Text = 'GougeHolder';
            app.GH.Layout.Row = 13;
            app.GH.Layout.Column = [8 9];

            % Create popupAI7
            app.popupAI7 = uidropdown(app.GridLayout);
            app.popupAI7.Items = {'AI7', '2) Cosino', '3) TC', '4) Vacuum', '5) Isco PA/PB', '6) Isco VA/VB', '7) Isco FA/FB', '8) RH', '9) TA', '10) Other', '11) Big Motor Torque'};
            app.popupAI7.Tag = 'popupAI7';
            app.popupAI7.BackgroundColor = [1 1 1];
            app.popupAI7.Layout.Row = 13;
            app.popupAI7.Layout.Column = 10;
            app.popupAI7.Value = 'AI7';

            % Create TC
            app.TC = uicheckbox(app.GridLayout);
            app.TC.Tag = 'TC';
            app.TC.Text = 'ThermoCouple';
            app.TC.Layout.Row = 14;
            app.TC.Layout.Column = [8 9];

            % Create popupAI8
            app.popupAI8 = uidropdown(app.GridLayout);
            app.popupAI8.Items = {'AI8', '2) Cosino', '3) TC', '4) Vacuum', '5) Isco PA/PB', '6) Isco VA/VB', '7) Isco FA/FB', '8) RH', '9) TA', '10) Other', '11) Big Motor Torque'};
            app.popupAI8.Tag = 'popupAI8';
            app.popupAI8.BackgroundColor = [1 1 1];
            app.popupAI8.Layout.Row = 14;
            app.popupAI8.Layout.Column = 10;
            app.popupAI8.Value = 'AI8';

            % Create popupAI16
            app.popupAI16 = uidropdown(app.GridLayout);
            app.popupAI16.Items = {'AI16', '2) Cosino', '3) TC', '4) Vacuum', '5) Isco PA/PB', '6) Isco VA/VB', '7) Isco FA/FB', '8) RH', '9) TA', '10) Other', '11) Big Motor Torque'};
            app.popupAI16.Tag = 'popupAI16';
            app.popupAI16.BackgroundColor = [1 1 1];
            app.popupAI16.Layout.Row = 14;
            app.popupAI16.Layout.Column = 11;
            app.popupAI16.Value = 'AI16';

            % Create Torque
            app.Torque = uicheckbox(app.GridLayout);
            app.Torque.Tag = 'Torque';
            app.Torque.Text = 'Torque Ctrl';
            app.Torque.Layout.Row = 15;
            app.Torque.Layout.Column = [8 9];

            % Create popupAI9
            app.popupAI9 = uidropdown(app.GridLayout);
            app.popupAI9.Items = {'AI9', '2) Cosino', '3) TC', '4) Vacuum', '5) Isco PA/PB', '6) Isco VA/VB', '7) Isco FA/FB', '8) RH', '9) TA', '10) Other', '11) Big Motor Torque'};
            app.popupAI9.Tag = 'popupAI9';
            app.popupAI9.BackgroundColor = [1 1 1];
            app.popupAI9.Layout.Row = 15;
            app.popupAI9.Layout.Column = 10;
            app.popupAI9.Value = 'AI9';

            % Create popupAI17
            app.popupAI17 = uidropdown(app.GridLayout);
            app.popupAI17.Items = {'AI17', '2) Cosino', '3) TC', '4) Vacuum', '5) Isco PA/PB', '6) Isco VA/VB', '7) Isco FA/FB', '8) RH', '9) TA', '10) Other', '11) Big Motor Torque'};
            app.popupAI17.Tag = 'popupAI17';
            app.popupAI17.BackgroundColor = [1 1 1];
            app.popupAI17.Layout.Row = 15;
            app.popupAI17.Layout.Column = 11;
            app.popupAI17.Value = 'AI17';

            % Create zeroThicknessLVDTLabel
            app.zeroThicknessLVDTLabel = uilabel(app.GridLayout);
            app.zeroThicknessLVDTLabel.Tag = 'text14';
            app.zeroThicknessLVDTLabel.HorizontalAlignment = 'right';
            app.zeroThicknessLVDTLabel.WordWrap = 'on';
            app.zeroThicknessLVDTLabel.Layout.Row = 16;
            app.zeroThicknessLVDTLabel.Layout.Column = [5 6];
            app.zeroThicknessLVDTLabel.Text = 'LVDT - zero (V)';

            % Create zeroThicknessLVDT
            app.zeroThicknessLVDT = uieditfield(app.GridLayout, 'text');
            app.zeroThicknessLVDT.Tag = 'zero_thickness_long';
            app.zeroThicknessLVDT.HorizontalAlignment = 'center';
            app.zeroThicknessLVDT.Tooltip = 'Zero position of LVDT long (V)';
            app.zeroThicknessLVDT.Layout.Row = 16;
            app.zeroThicknessLVDT.Layout.Column = 7;
            app.zeroThicknessLVDT.Value = '0';

            % Create vac
            app.vac = uicheckbox(app.GridLayout);
            app.vac.Tag = 'vac';
            app.vac.Text = 'Vacuum';
            app.vac.Layout.Row = 16;
            app.vac.Layout.Column = [8 9];

            % Create popupAI10
            app.popupAI10 = uidropdown(app.GridLayout);
            app.popupAI10.Items = {'AI10', '2) Cosino', '3) TC', '4) Vacuum', '5) Isco PA/PB', '6) Isco VA/VB', '7) Isco FA/FB', '8) RH', '9) TA', '10) Other', '11) Big Motor Torque'};
            app.popupAI10.Tag = 'popupAI10';
            app.popupAI10.BackgroundColor = [1 1 1];
            app.popupAI10.Layout.Row = 16;
            app.popupAI10.Layout.Column = 10;
            app.popupAI10.Value = 'AI10';

            % Create popupAI18
            app.popupAI18 = uidropdown(app.GridLayout);
            app.popupAI18.Items = {'AI18', '2) Cosino', '3) TC', '4) Vacuum', '5) Isco PA/PB', '6) Isco VA/VB', '7) Isco FA/FB', '8) RH', '9) TA', '10) Other', '11) Big Motor Torque'};
            app.popupAI18.Tag = 'popupAI18';
            app.popupAI18.BackgroundColor = [1 1 1];
            app.popupAI18.Layout.Row = 16;
            app.popupAI18.Layout.Column = 11;
            app.popupAI18.Value = 'AI18';

            % Create zeroThicknessLVDTShortLabel
            app.zeroThicknessLVDTShortLabel = uilabel(app.GridLayout);
            app.zeroThicknessLVDTShortLabel.Tag = 'text15';
            app.zeroThicknessLVDTShortLabel.HorizontalAlignment = 'right';
            app.zeroThicknessLVDTShortLabel.WordWrap = 'on';
            app.zeroThicknessLVDTShortLabel.Layout.Row = 17;
            app.zeroThicknessLVDTShortLabel.Layout.Column = [5 6];
            app.zeroThicknessLVDTShortLabel.Text = 'LVDTshort - zero (mm)';

            % Create zeroThicknessLVDTShort
            app.zeroThicknessLVDTShort = uieditfield(app.GridLayout, 'text');
            app.zeroThicknessLVDTShort.Tag = 'zero_thickness_short';
            app.zeroThicknessLVDTShort.HorizontalAlignment = 'center';
            app.zeroThicknessLVDTShort.Tooltip = 'Initial thickness of the gouge layer (mm).';
            app.zeroThicknessLVDTShort.Layout.Row = 17;
            app.zeroThicknessLVDTShort.Layout.Column = 7;
            app.zeroThicknessLVDTShort.Value = '0';

            % Create get_thickness
            app.get_thickness = uicheckbox(app.GridLayout);
            app.get_thickness.Tag = 'get_thickness';
            app.get_thickness.Tooltip = '1) Get thickness from LVDT_long specifying the zero position (V) and 2) get thickness subtracting LVDT_short from the initial thickness (mm).';
            app.get_thickness.Text = 'Thickness';
            app.get_thickness.Layout.Row = 17;
            app.get_thickness.Layout.Column = [8 9];

            % Create edit3
            app.edit3 = uieditfield(app.GridLayout, 'text');
            app.edit3.ValueChangedFcn = createCallbackFcn(app, @edit3_Callback, true);
            app.edit3.Tag = 'edit3';
            app.edit3.HorizontalAlignment = 'center';
            app.edit3.FontSize = 10.6666666666667;
            app.edit3.Layout.Row = 21;
            app.edit3.Layout.Column = 1;
            app.edit3.Value = '5';

            % Create fft
            app.fft = uibutton(app.GridLayout, 'push');
            app.fft.ButtonPushedFcn = createCallbackFcn(app, @fft_Callback, true);
            app.fft.Tag = 'fft';
            app.fft.Layout.Row = 22;
            app.fft.Layout.Column = 5;
            app.fft.Text = 'fft';

            % Create XLab
            app.XLab = uilistbox(app.GridLayout);
            app.XLab.Items = {'Rate (#)', 'Time (s)', 'Slip (m)'};
            app.XLab.ValueChangedFcn = createCallbackFcn(app, @XLab_Callback, true);
            app.XLab.Tag = 'XLab';
            app.XLab.Layout.Row = 30;
            app.XLab.Layout.Column = 3;
            app.XLab.Value = 'Rate (#)';

            % Show the figure after all components are created
            app.figure1.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = shivaUNIX_App_exported(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.figure1)

                % Execute the startup function
                runStartupFcn(app, @(app)shivaUNIX_OpeningFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.figure1)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.figure1)
        end
    end
end