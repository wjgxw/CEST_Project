% created by WJ angus
%  wjtcw@hotmail.com
%modified 2019.3.3
%output paramaters
function [output,kp] = WJG_cest_effect_NOE4sta(z_value,ppm_step,ppm_list,ppm_select)
step=0.01;
sample_point = [];
[row,~] = size(ppm_select);
for loopi = 1:row
    temp_ppm = linspace(ppm_select(loopi,1),ppm_select(loopi,2),round(abs(ppm_select(loopi,1)-ppm_select(loopi,2))/ppm_step)+1);
    sample_point = [sample_point,temp_ppm];
end

sample_point_sel =round(sample_point/ppm_step)+floor(length(ppm_list)/2)+1;
z_value_sel = z_value(sample_point_sel);

par0 =[0.8, 0, 0.5,max(z_value_sel)]; %initial guess
LB = [0.2,-1,0.1,1];   %amp, offset, width, maximum
UB = [1,1,4,1];
kp=lsqcurvefit('WJG_Lorentz',par0,sample_point,z_value_sel',LB,UB);
Loy=WJG_Lorentz(kp,ppm_list(1):step:ppm_list(end));%%%the fitting value
output = Loy;

% plot(ppm_list,z_value);hold on;plot(ppm_list(1):step:ppm_list(end),Loy)