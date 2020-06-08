% fitting the simu data
% validate the syn data
clc
clear
close all
warning off
addpath('func')
addpath('/data4/angus_wj/CEST/CEST/code/cest_tool')
addpath('../cest_tool')
%%%%%%%%%%%%%%%%%%%%%%%%%%
load('../gen_sample/data1/1.mat')
[~,~,channel] = size(cest_image_out);
label_num = 3;
fre_num = channel-label_num-1;
divide = 128;
ppm_start = -5;
ppm_end = 5;
ppm_list = linspace(ppm_start,ppm_end,fre_num);                % 
ppm_select = [-1.5,1.5;4.5,5];  
ppm_step = ppm_list(2)-ppm_list(1);
ppm_show = 3.5;
%% divide the image, increase the snr
ave_value = zeros(divide,divide,fre_num);
[row,col] = size(cest_image_out(:,:,1));
for ppmi = 1:fre_num +1   
   ave_value(:,:,ppmi) =  blkproc( cest_image_out(:,:,ppmi),[row/divide,col/divide],@mean2);     
end

% M0 = abs( blkproc( cest_image_out(:,:,ppmi+1),[row/divide,col/divide],@mean2));      %should be changed
%% mask
mask = squeeze(ave_value(:,:,1));
figure(34);imshow(squeeze(ave_value(:,:,1)),[]);colormap jet
mask = mask/max(mask(:));%
level = graythresh(mask);%
mask =  im2bw(mask,level);%
result = zeros(divide,divide);
figure(35);imshow(squeeze(mask),[]);colormap jet

for loopi =   1:divide      
    for loopj =  1:divide
        if(mask(loopi,loopj)==1)
            temp_ave_value = ave_value(loopi,loopj,:);
            temp_ave_value = squeeze(temp_ave_value)/max([ squeeze(temp_ave_value)']);  
            temp_ave_value = temp_ave_value(1:end-1);
           %%   Z   
            [Loy,kp] = WJG_cest_effect_NOE4sta(temp_ave_value,ppm_step,ppm_list,ppm_select);
            n=linspace(ppm_start,ppm_end,fre_num);
            n1=linspace(ppm_start,ppm_end,length(Loy));              
            cond = sum(abs(diff(Loy)));
            if cond>max(Loy) %%
                temp_ave_value2 = interp1(n,temp_ave_value,n1,'PCHIP');
                sample =Loy-temp_ave_value2;
            else
                temp_ave_value2 = interp1(n,temp_ave_value,n1,'PCHIP');
                sample = zeros(1,length(Loy));
            end
            %% far offset delete
%             if (kp(2)>1.5)||(kp(2)<-1.5)       
%                  sample = zeros(1,length(Loy));
%             end
           %% small value wrong fitting delete
%             if (kp(1)<0.5) ||  min(Loy)<0  
%                  sample = zeros(1,length(Loy));
%             end 
            %% large fitting error delete
%             if(sum(abs(Loy-temp_ave_value2)))>length(Loy)*0.1
%                 sample = zeros(1,length(Loy));
%             end
            %% water too wide delete
%              if (kp(3)>2.5)   
%                  sample = zeros(1,length(Loy));
%             end
           [~,center_ppm] = min(Loy);
%            center_ppm=500;

            sele_middle = floor((ppm_show)/0.01)+center_ppm;       % 0.01 the ppm_step after inter

            temp_result = mean(sample(sele_middle-20:sele_middle+20));%%

            temp_result = temp_result.*(temp_result>0);
            result(loopi,loopj)=temp_result; 
        end
    end
end
figure(1);imagesc(result,[0,0.3]);colormap jet;colorbar
% figure;imagesc(cest_image_out(:,:,24),[0,0.3]);colormap jet;colorbar
figure(2);imagesc(cest_image_out(:,:,23),[0,0.3]);colormap jet;colorbar
% cest_image_out(100,95,23)