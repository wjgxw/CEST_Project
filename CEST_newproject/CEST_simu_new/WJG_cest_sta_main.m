% analysis paramaters of lorentz  curve
% for fse Varian
% created by WJ angus
% wjtcw@hotmail.com
% 2019.3.3
%%%%%%%%%%%%%%%%%%%%%
clc
clear 
close all 
addpath('func')
%% parameters 
paracell={'at','sw','pelist','nv','dof'};
dirname='real_data/20180709';
fid_dir_all=dir([dirname,'/fse_25*']);       %list all directories
divide = 32; %divide the image (for average)
output_Z_para=[];
fre_num=25;
ppm_start = -6;
ppm_end = 6;
ppm_list = linspace(ppm_start,ppm_end,25);                %
ppm_select = [-1.5,1.5;5,6];% partial lorenz  %the ppm_aelect should be listed in the ppm_list
ppm_step = ppm_list(2)-ppm_list(1);
%% process
for loopi = 1:length(fid_dir_all)
    fid_name =[dirname,'/',fid_dir_all(loopi).name];
    Para=getpar(fid_name,paracell);
    nphase = Para.nv;
    pelist = Para.pelist+nphase/2;
    ppm_num = length(Para.dof);
    [RE,IM,NP,NB,NT,HDR] = load_fid(fid_name);
    k=RE+1i*IM;
    ave_value = zeros(divide,divide,ppm_num);
    for frame = 1:ppm_num  %
        II1 = k(:,(frame-1)*nphase+1:(frame-1)*nphase+nphase);
        II2(:,pelist) = II1;
        II3 = ifftshift(ifft2(fftshift(II2)));
        [row,col] = size(II3);
        B = blkproc(abs(II3),[row/divide col/divide],@mean2);
        ave_value(:,:,frame) = B;
    end
    output_Z_para = [output_Z_para;WJG_zspec(ave_value,ppm_step,ppm_list,ppm_select)];    
end
save output_Z_para.mat output_Z_para
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%show the parameters in image
load 'output_Z_para.mat'

omega_0=output_Z_para(:,2);
fwhm=output_Z_para(:,3);
scatter(omega_0,fwhm)
histfit (fwhm,20)
[mu,sigma] = normfit(fwhm);









