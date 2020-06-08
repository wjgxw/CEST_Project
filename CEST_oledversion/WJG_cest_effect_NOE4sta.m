% created by WJ angus
%  wjtcw@hotmail.com
%modified 2018.8.4
%output paramaters
function [output,kp] = WJG_cest_effect_NOE4sta(ave_value,fre_num)

step=0.1;
fre_x = 1:step:fre_num;
Loy =ones(1,length(fre_x)).*mean(ave_value);
kp=[0,0,0,0];
sample_point = 1:fre_num;
if max(ave_value)-min(ave_value)>0.1 %%去除噪声值时使用,阈值
    ave_value = ave_value(sample_point);
    ave_value=ave_value/max(ave_value);
    kp=lsqcurvefit('Lofun',[1,0.4,-5,12],sample_point,ave_value');
%         kp=fminsearch(@(K)Lo(K,1:fre_num,ave_value(1:fre_num)'),[100,-150,8,16]);%%拟合参数
    Loy=Lofun(kp,fre_x);%%%拟合的值
end
output = Loy;

