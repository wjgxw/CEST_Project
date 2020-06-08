% %compare the cest effect of the simulated data

% % created by Angus, wjtcw@hotmail.com
% % 2019.3.3 angus
clc
clear
% close all
%
warning off

addpath('func')
addpath('./cest_tool')
load('../expdata/Isreal_data_25.mat')
%% cest effect
fre_num=25;
divide =128;
ppm_start = -6;
ppm_end = 6;
ppm_list = linspace(ppm_start,ppm_end,fre_num);                %for GlioblastomaRat 9
ppm_select = [-1.5,1.5;5,5.88];  
% ppm_select = [-1.4,1.4;4.4,5];% partial lorenz  %the ppm_aelect should be listed in the ppm_list
ppm_step = ppm_list(2)-ppm_list(1);
ppm_show = 3.5;
%% divide the image, increase the snr
ave_value = zeros(divide,divide,fre_num);
[row,col] = size(cest_image_out(:,:,1));
for ppmi = 1:fre_num   
   ave_value(:,:,ppmi) =  blkproc( cest_image_out(:,:,ppmi),[row/divide,col/divide],@mean2);     
end

% M0 = abs( blkproc( cest_image_out(:,:,ppmi+1),[row/divide,col/divide],@mean2));      %should be changed
%% mask
mask = squeeze(ave_value(:,:,1));
% figure();imshow(squeeze(ave_value(:,:,1)),[0,1.5]);colormap jet
mask = mask/max(mask(:));%
level = graythresh(mask)/3;%
mask =  im2bw(mask,level);%
result = zeros(divide,divide);
% figure();imshow(squeeze(mask),[]);colormap jet

for loopi = 1:divide      
    for loopj = 1:divide
        if(mask(loopi,loopj)==1)
            temp_ave_value = ave_value(loopi,loopj,:);
            temp_ave_value = squeeze(temp_ave_value)/max([ squeeze(temp_ave_value)']);  
%             if(max(temp_ave_value)>1.2)
%                 plot(ppm_list,squeeze(temp_ave_value))
%                 a=9;
%             end
           %%   Z   
            [Loy,kp] = WJG_cest_effect_NOE4sta(temp_ave_value,ppm_step,ppm_list,ppm_select);
            n=linspace(ppm_start,ppm_end,fre_num);
            n1=linspace(ppm_start,ppm_end,length(Loy));              
            cond = sum(abs(diff(Loy)));
            if cond>max(Loy) %%
                temp_ave_value2 = interp1(n,temp_ave_value,n1,'PCHIP');
                sample =Loy-temp_ave_value2;
            else
                sample = zeros(length(Loy));
            end
           [~,center_ppm] = min(Loy);
            sele_middle = floor((ppm_show)/0.01)+center_ppm;       % 0.01 the ppm_step after inter
%             figure();plot(n,temp_ave_value,n1,Loy,n1,sample);
% plot(Loy);hold on ;plot(sample)
            if (length(Loy)>length(Loy)/2-100)&&(center_ppm<length(Loy)/2+100)
                temp_result = mean(sample(sele_middle-20:sele_middle+20));%%
            else
                temp_result = 0;
            end
            temp_result = temp_result.*(temp_result>0);
            result(loopi,loopj)=temp_result; 
        end
    end
end
    result_cest=result;
   figure; imagesc(result,[0,0.07]);colormap jet;colorbar;axis off
% WJG_show_cest(cest_image_out./max(cest_image_out(:)),0)
%  figure; imagesc(cest_image_out(:,:,26),[0.,0.2]);colormap jet;