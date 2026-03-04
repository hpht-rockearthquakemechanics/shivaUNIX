% Created by:
% ----------------------------------------------------------------------- %
%   Author:  Elena Spagnuolo                                              %
%   Date:    2012                                                         %
%   E-mail:                                                               %
% ----------------------------------------------------------------------- %

function [TimeS,CO2]=spectrometer(nom)
cd(['D:/dati/' nom])
filnom=dir('*.asc')
data=importdata(filnom.name, '\t', 24)
TimeS=data.data(:,1);


%20
mass14=data.data(:,2); mass28=data.data(:,3); mass29=data.data(:,4);
mass32=data.data(:,5); mass40=data.data(:,6); mass44=data.data(:,7);
mass18=data.data(:,8); mass38=data.data(:,9);

%detrend
CO2=mass44*3.5E7+0.00024;
CO2mass=(mass44./mass44(1) - ( - 0.00024*TimeS)).^(1/2);
O2mass=(mass32./mass32(1) - (- 0.00013*TimeS)).^(1/2);
H2Omass=mass18./mass18(1) - (- 0.00013*TimeS);
%normalize on pressure variations
CO2mass_2=CO2mass.^(1/4); %CO2mass_2(J)=(CO2mass(J)).^(1/4)
O2mass_2=O2mass.^(1/4); %O2mass_2(J)=(O2mass(J)).^(1/4)
H2Omass_2= H2Omass.^(1/4); %H2Omass_2(J)=(H2Omass(J)).^(1/4)

%colonna 1 =time(s)
%colonna 2--> 8 concentrazione ioni
%colonna 9 -->end corrente
%14
O2=data.data(:,2); CO2=data.data(:,3);


%16
N2=data.data(:,2); O2=data.data(:,3);
CO2=data.data(:,4); H2O=data.data(:,5);

%34
N2=data.data(:,2); O2=data.data(:,3);
Ar=data.data(:,4); CO2=data.data(:,5); He=data.data(:,6); Kr=data.data(:,7); CH4=data.data(:,8);
mass2=data.data(:,9); mass4=data.data(:,10); mass14=data.data(:,11); mass15=data.data(:,12); mass16=data.data(:,13);
mass28=data.data(:,14); mass32=data.data(:,15); mass40=data.data(:,16); mass44=data.data(:,17); mass84=data.data(:,18);
pk=data.data(:,19);


%mass 24
mass2=data.data(:,2); mass12=data.data(:,3); mass14=data.data(:,4);
mass15=data.data(:,5); mass16=data.data(:,6); mass18=data.data(:,7);
mass28=data.data(:,8); mass29=data.data(:,9); mass32=data.data(:,10);
mass40=data.data(:,11); mass44=data.data(:,12); mass38=data.data(:,13)

c=interp1(Time*1000, mass44,handles.Time); handles.mass44=c;
c=interp1(Time*1000, mass12,handles.Time); handles.mass12=c;
c=interp1(Time*1000, mass14,handles.Time); handles.mass14=c;
c=interp1(Time*1000, mass28,handles.Time); handles.mass28=c;
c=interp1(Time*1000, mass29,handles.Time); handles.mass29=c;

c=interp1(Time*1000, mass15,handles.Time); handles.mass15=c;
c=interp1(Time*1000, mass16,handles.Time); handles.mass16=c;
c=interp1(Time*1000, mass32,handles.Time); handles.mass32=c;
c=interp1(Time*1000, mass2,handles.Time); handles.mass2=c;
c=interp1(Time*1000, mass18,handles.Time); handles.mass18=c;
c=interp1(Time*1000, mass28,handles.Time); handles.mass28=c;
c=interp1(Time*1000, mass29,handles.Time); handles.mass29=c;

handles.column{end+1}='mass2';
handles.column{end+1}='mass14';

handles.column{end+1}='mass12';
handles.column{end+1}='mass15';
handles.column{end+1}='mass16';
handles.column{end+1}='mass18';
handles.column{end+1}='mass32';
handles.column{end+1}='mass44';
handles.column{end+1}='mass28';
handles.column{end+1}='mass29';

guidata(hObject, handles);







%inside ShivaUNIX
CO2n=interp1(TimeS*1000,CO2, handles.Time);
O2n=interp1(TimeS*1000,O2,handles.Time);
CH4n=interp1(TimeS*1000,CH4,handles.Time);

handles.column{end+1}='CO2';
handles.column{end+1}='O2';
handles.column{end+1}='CH4';

handles.CO2=CO2n;
handles.O2=O2n;
handles.CH4=CH4n;
guidata(hObject, handles);
%

figure; plot(Time,CO2); set(gca,'FontName', 'Nimbus sans l', 'FontSize', 16); title([pwd],'FontName', 'Nimbus sans l', 'FontSize', 16)
ghy=get(gca,'YLabel')
ghx=get(gca,'XLabel')

set(ghy,'string','CO2 concentration %','FontName', 'Nimbus sans l', 'FontSize', 16)
set(ghx,'string','Abs Time(s)','FontName','Nimbus sans l', 'FontSize',16)