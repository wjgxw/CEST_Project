% created by WJ angus
%  wjtcw@hotmail.com
%2018.8.4
%output all Z spectral paramaters
%input images of diferent frequency points
%output K1,K2,K3,K4 in Lofun.m
function final_Z_para = WJG_zspec(ave_value)
Z_para = [];
output_Loy_line = [];
[row,col,fre_num] = size(ave_value);
for loopi = 1:row
    for loopj = 1:col
        temp_ave_value = ave_value(loopi,loopj,:);
        temp_ave_value = squeeze(temp_ave_value);
        temp_ave_value=temp_ave_value/max(temp_ave_value);%��һ��
        %%   Z��
        [Loy_line,Loy_par]=   WJG_cest_effect_NOE4sta(temp_ave_value,fre_num);
        %   fre_num=31;
%         n=linspace(6,-6,fre_num);
%         n1=linspace(6,-6,length(Loy_line));
%         n=6:-0.5:-6;
%         subplot(row,col,(loopi-1)*row+loopj)
%         plot(n,temp_ave_value,n1,Loy_line);
%         title(num2str((loopi-1)*row+loopj))
%         xlim([-6 6])
%         pause(0.01)
        Z_para = [Z_para;Loy_par];
        output_Loy_line = [output_Loy_line;Loy_line];
    end
end
%delete the lines unexpected
final_Z_para = [];

 for loopi = 1:length(Z_para)
    if (sum(abs(Z_para(loopi,:)))>0)&&(var(output_Loy_line(loopi,:))>0.001)&&(max(output_Loy_line(loopi,:))<1)&&(min(output_Loy_line(loopi,:))<0.4)&&((min(output_Loy_line(loopi,:))>0))
        final_Z_para = [final_Z_para;Z_para(loopi,:)];
    end
 end



