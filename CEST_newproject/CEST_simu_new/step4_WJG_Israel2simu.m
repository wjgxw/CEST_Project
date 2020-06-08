% %read bruker fid
% %fse
% % transform the Israel data to simu structure
% % created by Angus, wjtcw@hotmail.com
% % 2019.1.22
% modified 2019.2.28 angus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% step1  read data
% clc
% clear
% close all
addpath('../cest_tool')
fid_name = '../../data_Israel/CEST_GlioblastomaData/CEST_GlioblastomaData/GlioblastomaRat/9';
[raw, params, k]= readBrukerFid(fid_name);
pelist = params.PVM_EncSteps1;
pelist = pelist+length(pelist)/2+1;
ppm_num = 51;
ppm_list = linspace(-5,5,ppm_num);                %for GlioblastomaRat 9
pe_num = length(pelist);
ro_num = 128;
% ha = tight_subplot(floor(sqrt(length(ppm_list)))+1,floor(sqrt(length(ppm_list)))+1,[0 0],[0 0],[0 0]) ;
cest_image = zeros(ro_num,ro_num,length(ppm_list));
for loopi = 1:ppm_num
    WJG_K = raw((loopi-1)*pe_num*ro_num+1:loopi*pe_num*ro_num);
    WJG_K = reshape(WJG_K,ro_num,pe_num);
    WJG_K(:,pelist(:)) = WJG_K;
%     axes(ha(loopi));
%     imagesc(abs(WJG_K),[0,120]);colormap jet ;
    WJG_I = fftshift(ifft2(fftshift(WJG_K)));
%     imagesc(abs(WJG_I),[0,120]);colormap jet  ;axis off
    cest_image(:,:,loopi) = abs(WJG_I);
end
%% transform
ppm_num = 21;
trans_ppm_list = linspace(-5,5,ppm_num);
cest_image_out = zeros(ro_num,pe_num,length(trans_ppm_list));
for loopi = 1:ro_num
    for loopj = 1:ro_num
        z_value = squeeze(cest_image(loopi,loopj,:));
        trans_z_value = interp1(ppm_list,z_value,trans_ppm_list,'linear');
%         plot(ppm_list,z_value,trans_ppm_list,trans_z_value);
        cest_image_out(loopi,loopj,:) = trans_z_value;      
    end
end

%% m0
fid_name = '../../data_Israel/CEST_GlioblastomaData/CEST_GlioblastomaData/GlioblastomaRat/8';
[raw, params, k]= readBrukerFid(fid_name);
pelist = params.PVM_EncSteps1;
pelist = pelist+length(pelist)/2+1;
ppm_list = [100,20,10,0,-10,-20];                %for GlioblastomaRat 9
pe_num = length(pelist);
ro_num = 128;
WJG_K = raw(1:1*pe_num*ro_num);
WJG_K = reshape(WJG_K,ro_num,pe_num);
WJG_K(:,pelist(:)) = WJG_K;
M0 = fftshift(ifft2(fftshift(WJG_K)));
figure;imagesc(abs(M0));colormap jet  ;axis off
cest_image_out(:,:,ppm_num+1) = abs(M0);


save Isreal_data_21_m0.mat cest_image_out





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % phantom 
% clc
% clear
% close all
% addpath('/data1/wj/CEST/code/cest_tool/')
% %% read data
% fid_name = '/data1/wj/CEST/data_Israel/CEST_GlioblastomaData/CEST_GlioblastomaData/37/';
% [raw, params, k]= readBrukerFid(fid_name);
% pelist = params.PVM_EncSteps1;
% pelist = pelist+length(pelist)/2+1;
% ppm_list = params.PVM_ppgFreqList1/1000;       %for phantom
% pe_num = length(pelist);
% ro_num = 128;
% ha = tight_subplot(floor(sqrt(length(ppm_list)))+1,floor(sqrt(length(ppm_list)))+1,[0 0],[0 0],[0 0]) ;
% cest_image = zeros(ro_num,pe_num,length(ppm_list));
% for loopi = 1:length(ppm_list)
%     WJG_K = raw((loopi-1)*pe_num*ro_num+1:loopi*pe_num*ro_num);
%     WJG_K = reshape(WJG_K,ro_num,pe_num);
%     WJG_K(:,pelist(:)) = WJG_K;
%     axes(ha(loopi));
%     imagesc(abs(WJG_K));colormap jet ;
%     WJG_I = fftshift(ifft2(fftshift(WJG_K)));
%     imagesc(abs(WJG_I));colormap jet  ;axis off
%     cest_image(:,:,loopi) = abs(WJG_I);
% end
% %% transform
% ppm_list1 = ppm_list(1:end-1);   %delete the final ppm frequency 20K
% ppm_num = 25;
% trans_ppm_list = linspace(-6,6,ppm_num);
% trans_cest_image = zeros(ro_num,pe_num,length(trans_ppm_list));
% for loopi = 1:ro_num
%     for loopj = 1:pe_num
%         z_value = squeeze(cest_image(loopi,loopj,:));
%         z_value = z_value(1:end-1);
%         trans_z_value1 = interp1(ppm_list1,z_value,trans_ppm_list(1:floor(ppm_num/2)),'linear',(z_value(1)));
%         trans_z_value2 = interp1(ppm_list1,z_value,trans_ppm_list(floor(ppm_num/2)+1:end),'linear',(z_value(end)));
%         trans_z_value=[trans_z_value1,trans_z_value2];
% %         plot(ppm_list1,z_value,trans_ppm_list,trans_z_value);
%         trans_cest_image(loopi,loopj,:) = trans_z_value;      
%     end
%     loopi
% end
% WJG_show_cest(trans_cest_image,0)

