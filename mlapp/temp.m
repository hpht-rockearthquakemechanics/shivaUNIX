% Created by:
% ----------------------------------------------------------------------- %
%   Author:  Elena Spagnuolo                                              %
%   Date:    2012                                                         %
%   E-mail:                                                               %
% ----------------------------------------------------------------------- %

function [Temp,Tf,Ta]=temp(time,vel,shear,slip,dn,reaction)
%% Stima della TEMPERATURA
%time in seconds
%dn=10; default
%/// Temp= usual dry temeprature on an infinitelly thin surface
% (now there is a flag for decarbonation on desire)
%/// Ta = temeprature on the asperities wet
% (asperitiy size is computed from indentation and number of
% asperities)
%///Tf = temeprature transferred to the a volume of water.
% (The volume is estimated ad the annular area x hypotesized hydraulic
% aperture).
%% flags
%decarb=0 % if decarbonation is active

if length(who)==5; decarb=0; mineral=0;
elseif length(who)> 5 & length(reaction)==2; decarb=reaction(1); mineral=reaction(2);
elseif length(who)> 5 & length(reaction)==1; decarb=reaction(1); mineral=0;
end
%% inputs
%________________________surafece percentage

rat=100/100;
as=(0.025^2-0.015^2)*pi;

% _______________________volume acqua tra le due superfici (apertura idraulica effettiva circa 10 um)
ha=1e-3; %hydraulic aperture
% _____________________volume interessato dalla deformazione (nel caso di trasformazioni di
% fase)
thick=5e-2;



%%

%__________________Input Thermal propeties (from file "thermal.txt")
patty='C:\Users\Elena Spagnuolo\Documents\script\script\SHIVA\thermal.txt'
fid=fopen(patty,'r');
if fid==0 | fid ==-1
    c=2200;
    Rho=2860; Kappa=1.27E-006; %carbonates
    disp('TempFile NOT found')
    
else
    disp('TempFile found')
    disp(['mineral= ' num2str(mineral), '; decarb= ' num2str(decarb)]);
    
    for i=1:40
        cac=fgets(fid);
        if cac==-1 | isempty(cac)
            break
        elseif cac(1) ~= '%' & length(cac)>1
            cac1=str2num(cac);
            c=cac1(1); Rho=cac1(2); Kappa=cac1(3);
        end
    end
    fclose(fid);
    
end

Gamma = (Rho*c*sqrt(Kappa*pi));


%%_________________Input mechanical variables

clear Temp
tI=1;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tI=find(time>=0,1,'first');
%t=time(tI:dn:end)/1000;
%dt=stamp(tI:dn:end)/1000;
Area=rat*as;
Va=ha*(Area); %volume d'acqua
Vdec=Area*thick; %volume interessato dalla deformazione

%variables
tm=time(tI:dn:end);
dt=diff(tm); dt(end+1)=dt(end); %dt=abs(dt);
s=shear(tI:dn:end).*1E6*as/Area; %corrected for presumed real contact area (considering parameter rat)
v=vel(tI:dn:end); v(v<0)=0;
sl=slip(tI:dn:end);

%themal parameters water
Lh=1.5E6; %latent heat vaporization
cw=4186; %Joules per kg per °K %thermal capacity water
Rhow=999.97; %water density

%______________________ initialize variables

M=length(s);
Temp(1:2)=0; Tf(1:2)=0; Ta(1:2)=0;

%______________________ model for contact asperities
Ma=60; %number of contact aperities;
F=12500; %normal force;
Pm=1900E6; % cantact stress; %190E6 calcite; 1900e6 feldspars (i.e. gabbro)
ar=sqrt(F/Ma/pi/Pm); %raggio delle asperità di contatto
Vw=ha*(pi*(2*ar)^2-pi*(ar^2)); %volume d'acqua tra le asperità
vmod=smooth(v,500);
tc = (ar)./vmod; tc=ones(size(s)).*tc; %contact time on the asperities
sa=ones(size(s)).*0.6*Pm;           %effective shear stress on the asperities
%sa=s*(0.025^2-0.015^2)*pi./(pi*ar^2);
disp(['ar=', num2str(ar) ',Vw= ', num2str(Vw)])

%reactions
alpha=Vdec;
alpha_m=6.2e-3; %mol CO2 inizialmente presenti nel sistema
%alpha_m=11.26e-6 %m3/mol 66.87e-9; %assuming only MgO: Molar volume of MgO = (24.31+16.00) (g/mol) / 3.58 (g/mL) = 11.3 mL / mol = 11.3e-6m3/mol
%numero di moli calcolato come: 49.3% MgO in Olivine:
%49.3:100=x:0.43 -> x/40.3344=numero di moli. 0.43g valore da rivedere
aa=0;
dd=0;
ee=0;
% calculations
for m=3:M
    bb=0;
    cc=0;
    ff=0;
    aa=0; %temperatura RH
    dd=0; %sulle asperità con acqua
    ee=0; %trasferito all'acqua
    
    for n=2:m-1
        x=0; %distanza dalla sorgente di calore
        %    bb = (v(n) .* s(n)) * dt(n) / sqrt(dt(n)*(m-n)) *exp(-x^2/Kappa/pi/(dt(n)*(m-n)))/Gamma;
        bb = (v(n) * s(n)) * dt(n) / sqrt(dt(n)*(m-n))./Gamma;
        
        %____________________________________decarb
        if decarb ==1 && aa > 600
            
            % simplest model with latent heat for CO2 vaporization.
            Lcarb=389e3; %J/kg
            %         bb = ((v(n) .* s(n)) * dt(n) - Lcarb*Rho*Vdec) / sqrt(dt(n)*(m-n)) *exp(-x^2/Kappa/pi/(dt(n)*(m-n)))/Gamma;
            % reliable model for kinetic decomposition reaction of CaCO3
            % from Michael Grantham,Carmelo Majorana,Valentina Salomoni: Concrete Solutions, pp 69
            
            R=8.314; % gas constant [J/mol/K]
            Eacarb=164.152e3; %energia attovazione [J/mol]
            deltaH=3.890e3; % entalpy: energy variation for compund J/kg
            fa=alpha^0.075*(1-alpha)^0.476;  %kinetic model
            alpha=alpha + dt(n)*fa*exp(12.064)*exp(-Eacarb/R/aa); %reaction kinetics this is a volume
            
            phi=Rho*deltaH*alpha;
            %heat sink = Latent heat [J/kg] * c [kg(m3)] *V [m3])
            % in this case V is the initial condition. The evolution of the
            % involved volume vearies with time. alpha accounts for this
            % raction kinetics.
            
            %       bb = ((v(n) .* s(n)) * dt(n) - phi) / sqrt(dt(n)*(m-n)) *exp(-x^2/Kappa/pi/(dt(n)*(m-n)))/Gamma;
            bb = ((v(n) .* s(n)) * dt(n) - phi - Lcarb ) / sqrt(dt(n)*(m-n))./Gamma;
            
            
        end
        
        %____________________________________decarb
        
        if mineral ==1 & aa >=400 %mineral carbonation
            
            R=8.314; % gas constant [J/mol/K]
            deltaH=-118e3; % entalpy: energy variation for compund J/mol
            %moli che si convertono:
            %y=1/(exp(-3.535 + 4794/(aa+273)));
            %x=1/(y+1);
            %      cmax=PCO2^alfa5+PCO2^alfa4*(PH2O/(PH2O/alfa1+1/(alfa1*alfa2*exp(-alfa3/aa))));
            %      x=0.024 % frazione molare cO2 a 50 bar
            %      PCO2=(47-25)/x; PH2O=25/(1-x);
            
            phi=deltaH*alpha_m; %
            %heat sink = Latent heat [J/mol] * mol in reazione
            
            %      bb = ((v(n) .* s(n)) * dt(n) - phi) / sqrt(dt(n)*(m-n)) *exp(-x^2/Kappa/pi/(dt(n)*(m-n)))/Gamma;
            bb = ((v(n) .* s(n)) * dt(n) - phi ) / sqrt(dt(n)*(m-n))./Gamma;
            
            
        end
        
        if mineral ==1 & dd >= 400
            deltaH=-118e3;
            phi=deltaH*alpha_m;
        else
            phi=0;
        end
        % qui rimane l'incognita di chi sia dt; dt==tc?
        
        cc = (vmod(n) .* sa(n) .*  dt(n) *0.5 - phi)/ sqrt(dt(n)*(m-n)) /Gamma ...
            - Vw*Rhow./(dt(n)*(m-n)*pi*ar^2).*(cc.*cw).*dt(n)./sqrt(dt(n)*(m-n))/Gamma;
        
        if dd > 260 %vaporizzazione acqua
            cc = (vmod(n) .* sa(n) .*  dt(n) *0.5 - phi) / sqrt(dt(n)*(m-n)) /Gamma ...
                - Vw*Rhow./(dt(n)*(m-n)*pi*ar^2).*(cc.*cw+Lh).*dt(n)./sqrt(dt(n)*(m-n))/Gamma;
            
        end
        
        ff = bb ...
            - Va*Rhow./(dt(n)*(m-n)*as).*(aa.*cw).*dt(n)./sqrt(dt(n)*(m-n))/Gamma;
        
        if  ee > 260 %vaporizzazione acqua
            ff=  bb ...
                - Va*Rhow./(dt(n)*(m-n)*as).*(aa.*cw+Lh).*dt(n)./sqrt(dt(n)*(m-n))/Gamma;
        end
        
        aa=aa+bb;
        dd=cc+dd;
        ee=ee+ff;
    end
    Temp(m) = aa ; %RH con il flag sulla reazione
    Ta(m)= dd; %sulle asperità con acqua
    Tf(m)=ee;  %in acqua con vaporizzazione
    
end


%figure; plot(vmod, Temp, vmod, Ta ); legend('Temp','Ta')


