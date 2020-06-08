%for partial lorenz fitting
%the sampling frequency point
%ppm_list:the whole ppm
%ppm_select: start_ppm, end_ppm
% created by WJ angus
%  wjtcw@hotmail.com
%2019.2.28
function [Loy_line,Loy_par] = WJG_cest_effect_NOE(z_value,ppm_step,ppm_list,ppm_select)

Loy =ones(1,length(ppm_list(1):0.01:ppm_list(end)))*mean(z_value)/max(z_value);
[row,~] = size(ppm_select);
sample_point = [];
for loopi = 1:row
    temp_ppm = linspace(ppm_select(loopi,1),ppm_select(loopi,2),round(abs(ppm_select(loopi,1)-ppm_select(loopi,2))/ppm_step)+1);
    sample_point = [sample_point,temp_ppm];
end

sample_point_sel =round(sample_point/ppm_step)+floor(length(ppm_list)/2)+1;
cond = sum(abs(diff(z_value)));
if cond>max(Loy) %%
    z_value=z_value/max(z_value);
    z_value_sel = z_value(sample_point_sel);
    z_value_sel = z_value_sel/max(z_value_sel);
    cest_point = length(z_value_sel);%% the length of z spectrum
    kp=lsqcurvefit('Lofun',[1,3,-5,0],sample_point,z_value_sel');
%         kp=fminsearch(@(K)Lo(K,1:fre_num,ave_value(1:fre_num)'),[100,-150,8,16]);%%fitting parameters
    Loy=Lofun(kp,ppm_list(1):0.01:ppm_list(end));%%%the fitting value
end
% plot(ppm_list(1):0.01:ppm_list(end),Loy);hold on 
% plot(ppm_list,z_value)
Loy_line = Loy;

