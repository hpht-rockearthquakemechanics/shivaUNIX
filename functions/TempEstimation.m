% Created by:
% ----------------------------------------------------------------------- %
%   Author:  Elena Spagnuolo                                              %
%   Date:    2012                                                         %
%   E-mail:                                                               %
% ----------------------------------------------------------------------- %

clear Tm

%   def_path=pwd;
%    cd /home/spagnuolo/shivadir/S'hiva Experiments'/;
[TCName,PathName] = uigetfile( '*.*','Select the TC file to import');

TC=importdata([PathName,TCName],'\t',2);

T=Tmeas(TC.data(:,1).*1000);
time=(1:length(T)).*70;
time2=cumsum(handles.Stamp);
y=handles.TorqueHG;
T2=interp1(time,T,time2);
figure;h=plotyy(time,T,time2,y)
linkaxes(h,'x');
%set(h(1),'XLim',[3.8E6 5E6])
set(h(1),'YLim',[-10,150],'YTick',[-10 : 10 :150])
% cd(def_path)
Tm=[time,T];
open Tm