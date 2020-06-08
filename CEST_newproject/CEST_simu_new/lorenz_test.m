clc
clear 
close all
addpath('func')

% w0=pi*2*10;
% sigma_0 = 1;
% t=0:0.001:1;    %s
% x = exp((j*w0-sigma_0)*t);
% plot(real(x))
% plot(t,x)


%% water
amplitude = 0.8;
omega_0 = 0;
fwhm = 1;
par0 =[amplitude, omega_0,fwhm]; %initial guess
omega = -6:0.01:6; %ppm
Lof_1=WJG_Lorentz(par0,omega);
%% amide
amplitude = 0.1;
omega_0 = 3.5;
fwhm = 1;
par0 =[amplitude, omega_0,fwhm]; %initial guess
omega = -6:0.01:6; %ppm
Lof_2=WJG_Lorentz(par0,omega);
%% amine
amplitude = 0.1;
omega_0 = 2;
fwhm = 1;
par0 =[amplitude, omega_0,fwhm]; %initial guess
omega = -6:0.01:6; %ppm
Lof_3=WJG_Lorentz(par0,omega);
%% noe
amplitude = 0.2;
omega_0 = -3;
fwhm = 5;
par0 =[amplitude, omega_0,fwhm]; %initial guess
omega = -6:0.01:6; %ppm
Lof_4=WJG_Lorentz(par0,omega);
%% mt
amplitude = 0.01;
omega_0 = 0;
fwhm = 300;
par0 =[amplitude, omega_0,fwhm]; %initial guess
omega = -6:0.01:6; %ppm
Lof_5=WJG_Lorentz(par0,omega);
figure
set(gca,'fontname','Times');
plot(omega,Lof_1,'b-','LineWidth',2);hold on
plot(omega,Lof_2,'r-.','LineWidth',2);
plot(omega,Lof_3,'m--','LineWidth',2);
plot(omega,Lof_4,'g:','LineWidth',2);
plot(omega,Lof_5,'k-','LineWidth',2);
plot(omega,Lof_1+Lof_2+Lof_3+Lof_4+Lof_5-4,'r-','LineWidth',2)
set(gca,'XDir','reverse','LineWidth',1.5,'fontsize',10,'fontweight','bold');
legend('water','amide','amine','noe','mt','z-spectrum')
ylim([0,1])
xlim([-6,6])
xlabel('chemical shift (ppm)')
ylabel('M_z/M_0')
