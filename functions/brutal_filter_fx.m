% Created by:
% ----------------------------------------------------------------------- %
%   Author:  Stefano Aretusini                                            %
%   Date:    06/06/2020                                                   %
%   E-mail:  ste.aretu (at) gmail (dot) com                               %
% ----------------------------------------------------------------------- %

function output=brutal_filter_fx(nodes,fcrat,fref,input,Stamp)
% nodes=1024;
% fcrat=0.9;
% fref=100;
% load('s1730.mRED.mat')

%convert timestep in seconds (or not?)
if min(Stamp)<1
    h=Stamp/1;
else
    h=Stamp/1000;
end

fcamp=(1./max(1/fref,h));
Fs=max(fcamp);
alphas=ceil(log10(Fs));
fc=max(fref/100,Fs/10^(alphas));
disp(['fc= ',num2str(fc)])

if Fs > fref/100
    disp('red')
    %riduci l'effetto window
    d=fdesign.lowpass('N,Fc',nodes,fcrat,Fs);
    Hd=design(d,'window','Window',tukeywin(nodes+1,0));
    output=filtfilt(Hd.Numerator,1,input);
else
    output=input;
end
%     figure(999)
%     plot(input,'ob'); hold on; plot(output,'r')
end