%output all Z spectral paramaters
%input images of diferent frequency points
%output all z spectral parameters
%output K1,K2,K3,K4 in Lofun.m
% created by WJ angus
%  wjtcw@hotmail.com
%2019.3.3
function final_Z_para = WJG_zspec(ave_value,ppm_step,ppm_list,ppm_select)
Z_para = [];
output_Loy_line = [];
[row,col,~] = size(ave_value);
for loopi = 1:row
    for loopj = 1:col
        temp_ave_value = ave_value(loopi,loopj,:);
        temp_ave_value = squeeze(temp_ave_value);
        [Loy_line,Loy_par] = WJG_cest_effect_NOE4sta(temp_ave_value,ppm_step,ppm_list,ppm_select);

        Z_para = [Z_para;Loy_par];
        output_Loy_line = [output_Loy_line;Loy_line];
    end
end
%delete the lines unexpected
final_Z_para = [];
[row,~] = size(Z_para);
 for loopi = 1:row
    if (sum(abs(Z_para(loopi,:)))>0)&&(var(output_Loy_line(loopi,:))>0.001)&&(max(output_Loy_line(loopi,:))<1)&&(min(output_Loy_line(loopi,:))<0.5)&&((min(output_Loy_line(loopi,:))>0))
        final_Z_para = [final_Z_para;Z_para(loopi,:)];
    end
 end



