%%

% Version 1.0, 12/06/2017.

% Created by Joel Alpízar Castillo and Rogelio José Fernández Barquero for the
% Spectroscopy Laboratory of the Physics Department of the Costa Rica Institute
% of Technology. If you need more information about the code or the Laboratory,
% you can mail us to: labramantec@gmail.com

%%

pkg load image;

clc;
close all;
clear all;

% tic    % Uncomment if you want to measure the execution time. Yo must uncomment
% the "toc" on last line.
output_precision(8);  % Define the variables presicion.

%%

% In this section, your own variables must be defined. The current ones are
% based on our equipment, so you must use your owns.

Tc=3000;        % Color temperature of the source.
% The following are the pattern color coordinates.
Xr=95.05;
Yr=100;
Zr=108.9;

espectro_reflectancia=dlmread ('reflectancias.csv',';',1,0);
% The reflectance spectra is loaded into the variable, you have to change the
% name of the .csv if your are not modifying the one which is attatched, but be
% careful to follow the structure required, using "." instead of "," for the
% decimals. Each value is separated with ";" and starting in the second row
% since the first is the columns description. Note that the reflectance
% measures must be done each 5 nm due to the standard tabuleted values given by
% the CIE.

%%

xyzbarras=dlmread ('xyzbarras.csv',';',1,0);  % The tabulated standard values
% are loaded from "xyzbarras.csv", please do not modify that archive because it
% may modify some parameters and the program won't work properly.

% The next operations are based on the method explained in the Colorimetry
% Technical Report of the CIE, 2004.

if Tc<=7000;
% 4000 K < Tc < 7000 K. 
XD=((-4.607*10^9)/Tc^3)+((2.9678*10^6)/Tc^2)+((0.09911*10^3)/Tc)+0.244063;

else
% 7000 K < Tc < 25 000 K. 
XD=((-2.0064*10^9)/Tc^3)+((1.9018*10^6)/Tc^2)+((0.24748*10^3)/Tc)+0.2233704;

endif

YD=-3*XD^2+2.87*XD-0.275;

M1=(-1.3515-1.7703*XD+5.9114*YD)/(0.0241+0.2562*XD-0.7341*YD);
M2=(0.03-31.4424*XD+30.0717*YD)/(0.0241+0.2562*XD-0.7341*YD);

f=rows(espectro_reflectancia);

xsum=0;
ysum=0;
zsum=0;

kden=0;

for i=1:f
  
  long(i)=espectro_reflectancia(i,1)*(10^3);
  ref(i)=espectro_reflectancia(i,21);
  
  xbarra(i)=xyzbarras(i,2);
  ybarra(i)=xyzbarras(i,3);
  zbarra(i)=xyzbarras(i,4);
  
  S0(i)=xyzbarras(i,7);
  S1(i)=xyzbarras(i,8);
  S2(i)=xyzbarras(i,9);
  
  S(i)=S0(i)+M1*S1(i)+M2*S2(i);
  
  phi(i)=ref(i)*S(i);
  
  xsum=xsum+phi(i)*xbarra(i);
  ysum=ysum+phi(i)*ybarra(i);
  zsum=zsum+phi(i)*zbarra(i);

  kden=S(i)*ybarra(i)+kden;
  
endfor;

k=100/(kden);

X=k*xsum;
Y=k*ysum;
Z=k*zsum;

XYZ=X+Y+Z;

x=X/XYZ;
y=Y/XYZ;
z=Z/XYZ;

%figure(1)
%plot(long,ref*100);
%title ("Reflectance spectrum", "fontsize", 16);
%axis ([long(1) long(f)]);
%xlabel("Wavelength (nm)");
%ylabel("Reflectance (%)");
% If you are measuring time, the plot function takes about 200 ms.

% The obtained XYZ coordinates are now transform into Lab, following the method
% detailed in the Colorimetry Technical Report of the CIE.

e=0.008856;
k=903.3;

xr=X/Xr;
yr=Y/Yr;
zr=Z/Zr;

if xr>e
fx=(xr)^(1/3);
elseif
fx=(k*xr+16)/116;
end

if yr>e
fy=(yr)^(1/3);
elseif
fy=(k*yr+16)/116;
end

if zr>e
fz=(zr)^(1/3);
elseif
fz=(k*zr+16)/116;
end

% The following values haven't a semicolon at porpouse so their values are
% displayed on the command window.

L=116*fy-16
a=500*(fx-fy)
b=200*(fy-fz)

X
Y
Z

% toc % Uncomment if you want to measure the execution time. Yo must uncomment
% the "tic" on line 19.