% Created by:
% ----------------------------------------------------------------------- %
%   Author:  Stefano Aretusini                                            %
%   Date:    06/06/2020                                                   %
%   E-mail:  ste.aretu (at) gmail (dot) com                               %
% ----------------------------------------------------------------------- %

% Documentation: https://srdata.nist.gov/its90/type_k/kcoefficients_inverse.html

function output=calibrate_temperature_fx(gain,input_hj,input_cj,compensation)

%% CJCompensation
if any(strcmp(compensation,{'y','yes','Y','ja','yup','ok','vabbuò'})==1); %compensation
    
    P=[-0.176004136860E-01,0.389212049750E-01,0.185587700320E-04,-0.994575928740E-07,0.318409457190E-09,-0.560728448890E-12,+0.560750590590E-15,-0.320207200030E-18,0.971511471520E-22,-0.121047212750E-25];
    N=0:1:9;
    a0=0.118597600000E+00;a1=-0.118343200000E-03;a2=-0.126968600000E+03;
    
    TAc_mV=ones(size(input_cj,1),1);
    TAc_mV2=ones(size(input_cj,1),1);
    
    TAc=(input_cj./0.05)-20; %cjc in °C
    
    for i=1:size(input_cj,1)
        %         TAc_mV(1,i)=-0.176004136860E-01*TAc(1,i)^0+0.389212049750E-01*TAc(1,i)^1+0.185587700320E-04*TAc(1,i)^2-0.994575928740E-07*TAc(1,i)^3+0.318409457190E-09*TAc(1,i)^4-0.560728448890E-12*TAc(1,i)^5+0.560750590590E-15*TAc(1,i)^6-0.320207200030E-18*TAc(1,i)^7+0.971511471520E-22*TAc(1,i)^8-0.121047212750E-25*TAc(1,i)^9+0.118597600000E+00*exp(-0.118343200000E-03*(TAc(1,i)-0.126968600000E+03)^2);
        TAc_mV2(1,i)=sum(P.*TAc(1,i).^N)+a0*exp(a1*(TAc(1,i)+a2)^2);
    end
    input_hj=input_hj/gain-TAc_mV;
else
end

%% INVERSION
hj=input_hj/gain*1000;

% degrees C and mV
% first column: -200°C to 0°C, second: 0°C to 500°C, third: 500°C to 1372°C
N=0:1:9;
D=[0.0000000E+00  0.000000E+00 -1.318058E+02;
    2.5173462E+01  2.508355E+01  4.830222E+01;
    -1.1662878E+00  7.860106E-02 -1.646031E+00;
    -1.0833638E+00 -2.503131E-01  5.464731E-02;
    -8.9773540E-01  8.315270E-02 -9.650715E-04;
    -3.7342377E-01 -1.228034E-02  8.802193E-06;
    -8.6632643E-02  9.804036E-04 -3.110810E-08;
    -1.0450598E-02 -4.413030E-05  0.000000E+00;
    -5.1920577E-04  1.057734E-06  0.000000E+00;
    0.0000000E+00 -1.052755E-08  0.000000E+00];

output=ones(size(hj,1),1);
for i=1:size(hj,1)
    if (hj(i,1)<=0) && (hj(i,1)>=-5.891)
        output(i,1)=sum(D(:,1)'.*hj(i,1).^N);
    elseif (hj(i,1)<=20.644) && (hj(i,1)>=0)
        %     output(i,1)=polyval(flipud(D(:,2)),input_hj(i,1));
        output(i,1)=sum(D(:,2)'.*hj(i,1).^N);
    elseif (hj(i,1)>=20.644) && (hj(i,1)<=54.886)
        %     output(i,1)=polyval(flipud(D(:,3)),input_hj(i,1));
        output(i,1)=sum(D(:,3)'.*hj(i,1).^N);
    else
        output(i)=NaN;
    end
end
end