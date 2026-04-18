function new_handles = calibrate_data(handles, cal_params)
% CALIBRATE_DATA - Esegue la calibrazione completa dei dati dell'esperimento SHIVA.
%
% SINTASSI:
%   new_handles = calibrate_data(handles, cal_params)
%
% INPUT:
%   handles: (struct) La struttura dati principale contenente i dati grezzi.
%   cal_params: (struct) Una struttura contenente i parametri necessari per la calibrazione.
%               Campi richiesti:
%               .rint, .rext, .calibration_index, .node1_str, .node2_str,
%               .AI_states, .popup_PF_index, .popup_PC_index, .is_incremental
%               .is_GH, .is_TC, .is_vac, .is_thickness, .ztl, .zts,
%               .is_gefran, .is_adjrate, .is_torque_ctrl
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata con i dati calibrati.
%
% AUTORE:
%   Basato sul codice originale di E. Spagnuolo, C. Harbord, S. Aretusini.
%   Refactoring di Gemini Code Assist.
%
%--------------------------------------------------------------------------

new_handles = handles; % Inizia con la struttura esistente

new_handles.log = append_action_to_log(new_handles.log, 'calibrate_data', cal_params);

disp('Starting full data calibration...');

% --- 1. PULIZIA INIZIALE ---
% Rimuove i campi calcolati in precedenza ('smooth', 'new') per evitare conflitti.
if any(strcmp(fieldnames(new_handles),'smooth'))
    nomi = new_handles.column;
    for i=1:length(nomi)
        if strfind(nomi{i},'smooth')
            new_handles = rmfield(new_handles, nomi{i});
            K = find(~strcmp(nomi{i}, new_handles.column));
            new_handles.column = new_handles.column(K);
        end
    end
end

if any(strcmp(fieldnames(new_handles),'new'))
    nomi = new_handles.new;
    for i=1:length(nomi)
        new_handles = rmfield(new_handles, nomi(i));
        K = find(~strcmp(nomi(i), new_handles.column));
        new_handles.column = new_handles.column(K);
    end
    if any(strcmp(fieldnames(new_handles),'new')); new_handles=rmfield(new_handles,'new');end
end

% --- 2. IMPOSTAZIONE DEI PARAMETRI DI CALIBRAZIONE ---
disp(' -> Setting up calibration constants...');

rint = cal_params.rint;
rext = cal_params.rext;
contents = cal_params.calibration_index;

cal.enc(1:2)=4/3*pi*(rext^2+rint*rext+rint^2)/(rext+rint);

switch contents
    % Imposta le costanti di calibrazione (tHG, tLG, fref) e corregge il tempo se necessario
    case 1
        disp("Select correct calibration!")
        return
    case 2
        cal.tHG=73.86; cal.tLG=cal.tHG; fref=250;
    case 3
        cal.tHG=1117.17; cal.tLG=cal.tHG; fref=250;
    case 4
        cal.tHG=730.94; cal.tLG=cal.tHG; fref=250;
    case 5
        cal.tLG=1118; cal.tHG=cal.tLG*100; fref=250;
    case 6
        cal.tHG=1179.2; cal.tLG=0.736e6; fref=250;
    case 7
        cal.tHG=0; cal.tLG=0.736e6; fref=125;
        if isempty(new_handles.Done)
            new_handles.Stamp=new_handles.Stamp*1.2; new_handles.Time=new_handles.Time*1.2;
        end
    case 8
        cal.tHG=0; cal.tLG=0.736e6; fref=125;
        if isempty(new_handles.Done)
            new_handles.Stamp=new_handles.Stamp*1.24; new_handles.Time=new_handles.Time*1.25;
        end
    case 9
        cal.tHG=0; cal.tLG=0.736e6; fref=125;
        if isempty(new_handles.Done)
            new_handles.Stamp=new_handles.Stamp*2; new_handles.Time=new_handles.Time*2;
        end
    case 10
        cal.tHG=0; cal.tLG=0.736e6; fref=125;
    case 11
        cal.tHG=0; cal.tLG=0.736e6; fref=125;
    case 12
        cal.tHG=0; cal.tLG=0.736e6; fref=100; cal.enc(1)=4/3*pi*(rext^2+rint*rext+rint^2)/(rext+rint)*10;
end

% Costanti fisse per Strain Gauge, Gems, ecc.
cal.tSG=17.19E6;
cal.GEM=3.1;
cal.gems=[3.15911 -2.557];
%after s1949
cal.gems=[3.1022 -2.5052];

cal.torqueHG(1:12)=cal.tHG*3/2/pi/(rext^3-rint^3)*1E-6;
cal.torqueLG(1:12)=cal.tLG*3/2/pi/(rext^3-rint^3)*1E-6;
cal.torqueSG(1:12)=cal.tSG*3/2/pi/(rext^3-rint^3)*1E-6;

% Costante per lo stress assiale
if contents>=11; cal.ax=-7.93457/pi/(rext^2-rint^2)/1000; %MPa
else cal.ax=2.5/pi/(rext^2-rint^2)/1000; %MPa
end

% Costanti per LVDT e fluidi
cal.lv(1)=5.0634;
cal.lv(2)=0.3;
cal.lv(3)=1;
cal.fluids(1:12)=4; %MPa/mV

AIstate = cal_params.AI_states;

% Costanti per sensori opzionali
cal.cosino=[9.0067 0.79664];
cal.ceriani=[1.667 9.333];
cal.iscoP=[6.879 -0.328];
cal.iscoV=[-50.885694343591595 508.7206208742802];
cal.iscoF=[1 0];
cal.ftutaRH=[1/0.05 0];
cal.ftutaT=[1/0.05 -20];
cal.other=[1 0];
cal.BigMotorTorque=[58.018 0];

new = struct();

% --- 3. ELABORAZIONE DATI ---

%% 3.1 Calcolo dello Stress Normale
disp(' -> Calculating Normal Stress...');
b=(strfind(new_handles.column,'Axial')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n)
    % Applica la costante di calibrazione per ottenere lo stress normale in MPa
    new.Normal=new_handles.(new_handles.column{n(j)})*cal.ax(1);
end

%% 3.2 Correzione dello Stress Normale per Gouge Holder (GH)
if cal_params.is_GH
    if isfield(new_handles,"Axial") && isfield(new_handles,"LVDT")
        disp(' -> Correcting Normal Stress for Gouge Holder...');
        x=new_handles.LVDT-new_handles.LVDT(1);
        a=abs(x- 5.37);
        Ia=find(a==min(a),1,'first');
        new.dspring=(x - x(Ia))*cal.lv(1);
        new.dspring(1:Ia)=0;
        
        % Ricalcola lo stress normale tenendo conto della deformazione delle molle
        if contents>=11; new.NormalGH=(-7.93457*new_handles.Axial-(0.2666+0.0501*new.dspring))/pi/(rext^2-rint^2)/1000; %MPa
        else new.NormalGH=(2.5*new_handles.Axial-(0.2666+0.0501*new.dspring))/pi/(rext^2-rint^2)/1000;
        end
    end
end

%% 3.3 Calibrazione dei Sensori Opzionali (AI1-AI18)
for L=1:18
    if AIstate(L) > 1
        b=strfind(new_handles.column,strcat('AI',num2str(L))); j=0; n=[];
        for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
        for j=1:length(n)
            switch AIstate(L)
                case 2 % Cosino
                    disp('    - Calibrating Internal Pressure (Cosino)...');
                    new.InternalPressure=new_handles.(new_handles.column{n(j)})*cal.cosino(1)+cal.cosino(2);
                case 3 % TC
                    disp('    - Calibrating Internal Temperature (TC)...');
                    new.InternalTemperature=calibrate_temperature_fx(120,new_handles.(new_handles.column{n(j)}),[],[]);
                case 4 % Vacuum (Ceriani)
                    disp('    - Calibrating Chamber Pressure (Vacuum)...');
                    new.ChamberPressure=10.^(new_handles.(new_handles.column{n(j)})*cal.ceriani(1)+cal.ceriani(2));
                case 5 % IscoP
                    disp('    - Calibrating Pump Pressure (IscoP)...');
                    new.PumpPressure=new_handles.(new_handles.column{n(j)})*cal.iscoP(1)+cal.iscoP(2);
                case 6 % IscoV
                    disp('    - Calibrating Pump Volume (IscoV)...');
                    new.PumpVolume=new_handles.(new_handles.column{n(j)})*cal.iscoV(1)+cal.iscoV(2);
                case 7 % IscoF
                    disp('    - Calibrating Pump Flow (IscoF)...');
                    new.PumpFlow=new_handles.(new_handles.column{n(j)})*cal.iscoF(1)+cal.iscoF(2);
                case 8 % FtutaRH
                    disp('    - Calibrating Probe Humidity (FtutaRH)...');
                    new.ProbeH=new_handles.(new_handles.column{n(j)})*cal.FtutaRH(1)+cal.FtutaRH(2);
                case 9 % FtutaT
                    disp('    - Calibrating Probe Temperature (FtutaT)...');
                    new.ProbeT=new_handles.(new_handles.column{n(j)})*cal.FtutaT(1)+cal.FtutaT(2);
                case 10 % Other
                    disp('    - Calibrating Other sensor...');
                    new.Other=new_handles.(new_handles.column{n(j)})*cal.other(1)+cal.other(2);
                case 11 % BigMotorTorque
                    disp('    - Calibrating Big Motor Torque...');
                    new.BigMotorTorque=new_handles.(new_handles.column{n(j)})*cal.BigMotorTorque(1)+cal.BigMotorTorque(2);
                    new.BigMotorShearStress=abs(new.BigMotorTorque)*3/2/pi/(rext^3-rint^3)*1E-6;
            end
        end
    end
end

%% 3.4 Calcolo della Pressione dei Pori (Pore Fluid Pressure)
popupPF = cal_params.popup_PF_index;
switch popupPF
    case 2 % Gefran
        disp(' -> Calculating Pore Fluid Pressure (Gefran)...');
        if contents>=12; b=(strfind(new_handles.column,'GefranPressure'));
        elseif contents<=11; b=(strfind(new_handles.column,'FluidPressure'));
        else b=strfind(new_handles.column,'IO');
        end
        j=0; n=[];
        for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
        for j=1:length(n)
            new.Pf=new_handles.(new_handles.column{n(j)})*cal.fluids(1);
            new.EffPressure=new.Normal-new.Pf;
        end
    case 3 % Gems
        disp(' -> Calculating Pore Fluid Pressure (Gems)...');
        b=strfind(new_handles.column,'GEMS'); j=0; n=[];
        for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
        for j=1:length(n)
            new.Pf=new_handles.(new_handles.column{n(j)})*cal.gems(1) + cal.gems(2);
            new.EffPressure=new.Normal-new.Pf;
        end
    case 4 % IscoPump
        % Usa il nome del vettore specifico per la pressione dei pori
        if isfield(cal_params, 'isco_pump_pf_vector_name') && ~isempty(cal_params.isco_pump_pf_vector_name)
            disp([' -> Calculating Pore Fluid Pressure (IscoPump) using vector: ', cal_params.isco_pump_pf_vector_name]);
            b=strfind(new_handles.column, cal_params.isco_pump_pf_vector_name); j=0; n=[];
            for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
            if ~isempty(n)
                % Assicurati di usare il primo match se ce ne sono più
                new.Pf=new_handles.(new_handles.column{n(1)})*cal.iscoP(1) + cal.iscoP(2);
                new.EffPressure=new.Normal-new.Pf;
            end
        else
            warning('IscoPump selected for Pore Fluid, but no vector name was provided. Skipping calculation.');
        end
end

%% 3.5 Calcolo della Pressione di Confinamento (Confining Pressure)
popupPC = cal_params.popup_PC_index;
switch popupPC
    case 2 % Gefran
        disp(' -> Calculating Confining Pressure (Gefran)...');
        if contents>=12; b=(strfind(new_handles.column,'GefranPressure'));
        elseif contents<=11; b=(strfind(new_handles.column,'FluidPressure'));
        else b=strfind(new_handles.column,'IO');
        end
        j=0; n=[];
        for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
        for j=1:length(n)
            new.Pc=new_handles.(new_handles.column{n(j)})*cal.fluids(1);
        end
    case 3 % Gems
        disp(' -> Calculating Confining Pressure (Gems)...');
        b=strfind(new_handles.column,'GEMS'); j=0; n=[];
        for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
        for j=1:length(n)
            new.Pc=new_handles.(new_handles.column{n(j)})*3.15911 - 2.557;
        end
    case 4 % IscoPump
        % Usa il nome del vettore specifico per la pressione di confinamento
        if isfield(cal_params, 'isco_pump_pc_vector_name') && ~isempty(cal_params.isco_pump_pc_vector_name)
            disp([' -> Calculating Confining Pressure (IscoPump) using vector: ', cal_params.isco_pump_pc_vector_name]);
            b=strfind(new_handles.column, cal_params.isco_pump_pc_vector_name); j=0; n=[];
            for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
            if ~isempty(n)
                % Assicurati di usare il primo match se ce ne sono più
                new.Pc=new_handles.(new_handles.column{n(1)})*cal.iscoP(1) + cal.iscoP(2);
                % new.EffPressure non è calcolato qui per Pc, solo per Pf
            end
        else
            warning('IscoPump selected for Confining Pressure, but no vector name was provided. Skipping calculation.');
        end
end

%% 3.6 Calcolo di Velocità e Scorrimento (Slip) dagli Encoder
disp(' -> Calculating Slip and Velocity from Encoders...');
node = str2num(cal_params.node1_str);
node1=node(:,1); f1crat=node(:,2);
node = str2num(cal_params.node2_str);
node2=node(:,1); f2crat=node(:,2);

b=(strfind(new_handles.column,'Encoder')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n)
    d0 = new_handles.(new_handles.column{n(j)});
    h_ele = new_handles.Stamp/1000;
    
    % Correzione del rate se il flag è attivo
    if cal_params.is_adjrate
        I_ele=find(diff(h_ele)<mode(diff(h_ele)));
        if ~isempty(I_ele)
            I_fit=[I_ele-10:I_ele];
            cv=fit(new_handles.Time(I_fit)/1000, d0(I_fit),'linear');
            deltaslip=d0(I_ele+1) - cv(new_handles.Time(I_ele+1)/1000);
            d0(I_ele+1:end)=d0(I_ele+1:end)/1000 - deltaslip(1);
        end
    end
    
    % Correzione per encoder di tipo incrementale se il flag è attivo
    if cal_params.is_incremental
        J = local_max(d0); % Funzione helper per trovare massimi locali
        if length(J) > 10
            [c,d]=hist(diff(d0(J)));
            Jc=find(c==max(c));
            r=abs(diff(d0(J))-d(Jc(1)));
            In=find(r > mode(diff(d)));
            I=J(In);
            for ii=1:length(I)
                if ii==length(I) && I(ii) + 2 < length(d0)
                    d0(I(ii)+1:end)=d0(I(ii)+1:end)-d0(I(ii)+2)+d0(I(ii));
                elseif ii < length(I)
                    d0(I(ii)+1:I(ii+1))=d0(I(ii)+1:I(ii+1))-d0(I(ii)+2)+d0(I(ii));
                end
            end
        end
    end

    d0(d0<0)=0;
    h=new_handles.Stamp/1000;
    d1=d0*cal.enc(1);
    
    % Applica un filtro passa-basso se non si è in modalità controllo di torsione
    if ~cal_params.is_torque_ctrl
        fcamp=(1./max(1/fref,h));
        Fs=max(fcamp);
        nodes=node2; fcrat=f2crat;
        if j==1; nodes=node1; fcrat=f1crat; end
        
        if Fs > fref/100
            d=fdesign.lowpass('N,Fc',nodes,fcrat,Fs);
            Hd=design(d,'window','Window',tukeywin(nodes+1,0));
            d_sm=filtfilt(Hd.Numerator,1,d1);
        else
            d_sm=d1;
        end
    else
        d_sm=d1;
    end
    
    % Calcola la velocità e lo scorrimento
    bb=diff(d_sm); bb(end+1)=bb(end);
    v=(bb./h)./new_handles.tconv;
    
    new.(['SlipVel_Enc_' num2str(j)]) = v;
    new.(['Slip_Enc_' num2str(j)]) = d_sm;
    
    if j==1; del0=d_sm; v0=v; end
    % Combina i dati dei due encoder per ottenere il segnale migliore
    if j==2
        del10=max(d_sm,del0);
        Iv=find(v < 0.01 );
        d_sm(Iv)=del0(Iv);
        v=max(v0,v);
        
        new.slip=del10;
        if max(v) <= 20E-3
            new.vel=v0;
        else
            new.vel=v;
        end
        
        % Rimuove eventuali outlier dalla velocità calcolata
        IOL=find(new.vel >=10);
        for i_ol=1:length(IOL)
            new.vel(IOL(i_ol))=new.vel(IOL(i_ol)-1);
        end
        IOL=find(new.vel < -1);
        for i_ol=1:length(IOL)
            new.vel(IOL(i_ol))=new.vel(IOL(i_ol)-1);
        end
    end
end

%% 3.7 Calibrazione degli LVDT
disp(' -> Calibrating LVDT...');
b=(strfind(new_handles.column,'LVDT')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n)
    if ~any(strfind(new_handles.column{n(j)},'LVDT_'))
        if j==1; new.LVDT_low= new_handles.(new_handles.column{n(j)})*cal.lv(j); end
        if j==2; new.LVDT_high= new_handles.(new_handles.column{n(j)})*cal.lv(j); end
    end
end

%% 3.8 Calibrazione della Torsione (Torque) e calcolo di Shear Stress e Frizione (Mu)
disp(' -> Calculating Shear Stress and Friction...');
b=(strfind(new_handles.column,'Torque')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n)
    if or(~isempty(strfind(new_handles.column{n(j)},'HG')),strcmp(new_handles.column{n(j)},'Torque'))
        cali=cal.torqueHG(j);
    elseif ~isempty(strfind(new_handles.column{n(j)},'LG'))
        cali=cal.torqueLG(j);
    end
    
    new.(['shear' num2str(j)])=new_handles.(new_handles.column{n(j)})*cali;
    new.(['Mu' num2str(j)])=new.(['shear' num2str(j)])./new.Normal;
    
    if (popupPF>=2)
        new.(['Mu' num2str(j)])=new.(['shear' num2str(j)])./new.EffPressure;
    end
end

%% 3.9 Importazione dei dati da Termocoppia (se presente)
if cal_params.is_TC && isempty(dir('*TC'))==0
    disp(' -> Importing thermocouple data...');
    try
        filname=dir('*TC');
        if length(filname) > 1
            [fileName,PathName] = uigetfile('*.*','Select TC File', pwd);
            filname.name=fileName;
        end
        TC=importdata(filname.name,'\t',2);
        time2=cumsum(new_handles.Stamp);
        [a,b]=size(TC.data);
        if b==5
            time=(1:length(TC.data)).*400;
            new.T1=interp1(time,TC.data(:,1),time2);
            new.T2=interp1(time,TC.data(:,2),time2);
            new.T3=interp1(time,TC.data(:,3),time2);
            new.T4=interp1(time,TC.data(:,4),time2);
        elseif b==2
            time=cumsum(TC.data(:,2));
            new.T1=interp1(time,TC.data(:,1),time2);
        end
    catch
        disp("Error in importing thermocouples data")
    end
end

%% 3.10 Stima della Temperatura basata su dati meccanici
disp(' -> Estimating Temperature from mechanical data...');
dn=50;
time2=cumsum(new_handles.Stamp);
if any(strcmp(fieldnames(new),'vel'))
    if max(new.vel) <= 20e-3 && any(strcmp(fieldnames(new),'SlipVel_Enc_1'))
        [Temp]=temp(new_handles.Time/1000,new.SlipVel_Enc_1,new.shear1,new.Slip_Enc_1,dn);
        new.TempE=interp1(time2(1:dn:end),Temp,time2);
    else
        [Temp]=temp(new_handles.Time/1000,new.vel,new.shear1,new.slip, dn);
        new.TempE=interp1(time2(1:dn:end),Temp,time2);
    end
elseif any(strcmp(fieldnames(new),'SlipVel_Enc_2'))
    [Temp]=temp(new_handles.Time/1000,new.SlipVel_Enc_2,new.shear1,new.Slip_Enc_2,dn);
    new.TempE=interp1(time2(1:dn:end),Temp,time2);
else
    disp('Not possible to perform temperature modelling')
end

%% 3.11 Calibrazione dello Strain Gauge
b=(strfind(new_handles.column,'StrainGauge')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n)
    new.(['StrainGauge' num2str(j)])=new_handles.(new_handles.column{n(j)})*cal.torqueSG(j);
    new.(['MuSG' num2str(j)])=new.(['StrainGauge' num2str(j)])./new.Normal;
end

%% 3.12 Calibrazione dei sensori di umidità e temperatura ambiente
b=(strfind(new_handles.column,'RH')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n)
    new.HRc=new_handles.(new_handles.column{n(j)})./0.05;
end
b=(strfind(new_handles.column,'TA')); j=0; n=[];
for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
for j=1:length(n)
    new.TAc=(new_handles.(new_handles.column{n(j)})./0.05)-20;
end

%% 3.13 Calibrazione del misuratore di vuoto (Vacuum Gauge)
if cal_params.is_vac & isfield(new_handles,"TA")
    disp(' -> Calibrating vacuum gauge...');
    new.VAC=10.^(new_handles.TA*1.667-9.333);
end

%% 3.14 Calcolo dello spessore del Gouge Layer
if cal_params.is_thickness
    disp(' -> Calculating gouge layer thickness...');
    ztl = cal_params.ztl;
    zts = cal_params.zts;
    
    b=(strfind(new_handles.column,'LVDT')); j=0; n=[];
    for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
    for j=1
        new.thickness_low=(new_handles.(new_handles.column{n(j)})-ztl)*cal.lv(1);
    end
    
    b=(strfind(new_handles.column,'short')); j=0; n=[];
    for i=1:length(b); if ~isempty(b{i}); j=j+1; n(j)=i; end; end
    for j=1
        new.thickness_high=zts-cal.lv(2)*(new_handles.(new_handles.column{n(j)}));
    end
end

%% 3.15 Importazione dei dati da GEFRAN (se presente)
if cal_params.is_gefran
    disp(' -> Importing and processing GEFRAN data...');
    I=find(abs(new_handles.timeGEF)==min(abs(new_handles.timeGEF))); if isempty(I); I=1; end
    J=find(abs(new_handles.Time)==min(abs(new_handles.Time))); if isempty(J); J=1; end
    
    if length(new.Normal)>=length(new_handles.VGEF)
        I2=length(new_handles.VGEF);
        if I2+J > length(new.Normal); I2=I2-J; end
        J2=J-1+I2;
        
        new.SpeedGEF=zeros(size(new.Normal)); new.SpeedGEF(J:J2)=(-1)*new_handles.VGEF(I:I2).*cal.enc(1)/60;
        new.SlipGEF=zeros(size(new.Normal)); new.SlipGEF(J:J2)=cumsum((-1)*new_handles.VGEF(I:I2))*cal.enc(1)/60/1000;
        if any(find(strcmp(fieldnames(new_handles),'TqGEF')))
            new.TorqueGEF=zeros(size(new.Normal)); new.TorqueGEF(J:J2)=(-1)*new_handles.TqGEF(I:I2);
        end
    else
        l=J+length(new_handles.VGEF)-1; resl=l-length(new_handles.Time);
        new.SpeedGEF(J:length(new_handles.Time))=(-1)*new_handles.VGEF(1:length(new_handles.VGEF)-resl).*cal.enc(1)/60;
        new.SlipGEF(J:length(new_handles.Time))=cumsum((-1)*new_handles.VGEF(1:length(new_handles.VGEF)-resl))*cal.enc(1)/60/1000;
        if any(find(strcmp(fieldnames(new_handles),'TqGEF')))
            new.TorqueGEF(J:J+length(new_handles.VGEF)-1)=(-1)*new_handles.TqGEF;
        end
    end
end

%% --- 4. AGGIORNAMENTO FINALE DELLA STRUTTURA DATI ---
% Aggiunge i nuovi campi calcolati alla struttura 'handles' e aggiorna la lista delle colonne.
new_fnames = fieldnames(new);
for i=1:length(new_fnames)
    fname = new_fnames{i};
    % Rimuovi il vecchio campo se esiste per evitare conflitti
    K = find(~strcmp(fname, new_handles.column));
    new_handles.column = new_handles.column(K);
    % Aggiungi il nuovo campo dati
    new_handles.(fname) = new.(fname);
end

% Aggiorna la lista delle colonne
sz=size(new_handles.column);
sz2=size(new_fnames);

if sz(1)>1 %is a column
    if sz2(1)>1 % also a column
        new_handles.column=[new_handles.column; new_fnames];
    else % is a row, need to transpose
        new_handles.column=[new_handles.column; new_fnames'];
    end
else % is a row
    if sz2(1)>1 % is a column, need to transpose
        new_handles.column = [new_handles.column, new_fnames'];
    else % is a row
        new_handles.column = [new_handles.column, new_fnames];
    end
    % maybe transpose new_handles.column
end

new_handles.Done=1;
new_handles.new=new_fnames;

disp('Full data calibration complete.');

end