function filtro1=filtravel_shiva(data,varargin)
%% filter signal; 

%esempio
% I da ginput tra slip_Enc_1 e slip Enc_2
%slip=filtravel(Slip_Enc_1(:,1),Time/1000,25); slip(I:end)=filtravel(Slip_Enc_2(I:end,1),Time/1000,50); 
%vel=diff(slip)./diff(Time/1000); vel(end+1)=vel(end); figure; plot(vel);

%varargin 1 = Time
%varargin 2 = Fs
%varargin 3 = filtype (1,2,3)

% es: 
%vel_butter=filtravel(data.vel,data.Time/1000,1);
%vel_tukey=filtravel(data.vel,data.Time/1000,2);

%cambiata la tipologia di filtro il 7/9/2020
filtro1=[];
Videal=0.05E-6;

dx=0.2E-6; %0.2um = res SIGNUM
fcrat=Videal./dx;
filtTYPE=1;
factor=1;
nodes=1;
Fs=[125];

if exist('varargin','var')
if length(varargin{1})==1
    Time=varargin{1}; 
     Stamp=diff(Time); Stamp(end+1)=Stamp(end);
%25/10/2022 commentare queta riga per tornare all v precedente
%[NI,G,GP]=grp2idx(Stamp);
%Fs=1./GP./factor
%[N,X]=hist(Stamp); IImax=find(N==max(N));  
%25/10/2022 decommentare queta riga per tornare all v precedente
%Fs(1)=1/(X(IImax)) %Fs(1)=1/(X(IImode)); Fs(1)=1/(X(IImin))%max(Stamp)/10; Fs(2)=1./max(Stamp); Fs(3)=1/max(Stamp)/5; Fs(4)=25;

% per s1918 Fs= 106.6667  426.6667   25.0000

end
    if length(varargin)==2 & ~isempty(varargin{2})
%   filtTYPE=varargin{2};
    Fs=varargin{2};
    end
    if length(varargin)==3 & ~isempty(varargin{3})
    filtTYPE=varargin{3};
    end
end    
for k=1:length(Fs)
% L=length(data);
% y=fft(data);
% P2=abs(y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
% figure; plot(f,P1)
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
% 
%nuovo filtro

if filtTYPE==1
nodes=1;
[a,b]=butter(nodes,fcrat/Fs(k),'low');
filtro=filtfilt(a,b,data);
%vecchio filtro
elseif filtTYPE==2
nodes=8;
d=fdesign.lowpass('N,Fc',nodes,fcrat,Fs(k));
Hd=design(d,'window','Window',tukeywin(nodes+1,0));
filtro=filtfilt(Hd.Numerator,1,data);

elseif filtTYPE==3
      D = designfilt('lowpassiir', 'FilterOrder', 1, ...
             'StopbandFrequency', fcrat, 'StopbandAttenuation',10,...
             'SampleRate',Fs(k));
filtro= filtfilt(D,data);
end %filtTYPE
 
filtro1(:,k)=filtro;
%M= [0,0,0,0,1,1,1,1,1] / 5;
%y = conv(filtro, M, 'full');
%figure; plot(data); hold on; plot(filtro)
end %for
end