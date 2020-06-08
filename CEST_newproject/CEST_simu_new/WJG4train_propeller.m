%sampling the experiment data with propeller scheme
%2019.3.3
%modified 2019.6.22
% created by Angus, wjtcw@hotmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Isreal
clc
clear 
close all
addpath('../cest_tool')
row = 128;
col = 128;
ppm_num = 21;
sel_line = 16;
deg = 7.2;% 
propeller_K = zeros(row,col,ppm_num);
fid_file = 'Isreal_data_21_m0.mat';
load(fid_file);
output_channel = 3;
mask_org = zeros(row,col);
mask_org(floor(row/2)-floor(sel_line/2):floor(row/2)+floor(sel_line/2)-1,:)=ones(sel_line,col);
propeller_I = zeros(row,col,ppm_num+output_channel);

for loopi = 1:ppm_num
    img_rot = imrotate(mask_org,deg*(loopi-1), 'nearest');
    [row_rot,col_rot] = size(img_rot);
    mask(:,:) = img_rot(floor((row_rot-row)/2)+1:floor((row_rot+row)/2),floor((col_rot-col)/2)+1:floor((col_rot+col)/2));
    K_space = fftshift(fft2(ifftshift(cest_image_out(:,:, loopi)))).*mask;
    subplot(8,8,loopi);
    imagesc(log(abs(K_space)));colormap jet;axis off
    propeller_K(:,:,loopi) = K_space;
end
for loopi=1:ppm_num
    temp_K = propeller_K(:,:,loopi);
    temp_I = abs( ifftshift(ifft2(fftshift(temp_K))));
    propeller_I(:,:,loopi) = temp_I;
end      
image_max = propeller_I(:,:,1);
image_max = max(image_max(:));   
for loopi = 1:ppm_num
    propeller_I(:,:,loopi) = propeller_I(:,:,loopi)/image_max;
end

propeller_I = permute(propeller_I,[3,1,2]);
%% save
filename1='1.Charles';
[fid,msg]=fopen(filename1,'wb');
fwrite(fid, propeller_I,'single');
fclose(fid); 
% WJG_show_cest(propeller_I,0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% XMU Varian
% clc
% clear 
% % close all
% addpath('/data1/wj/CEST/code/cest_tool')
% 
% fid_name = '/data1/wj/CEST/code/WJGdata/phantom/fsems_lu_fatsat_02.fid';
% [RE,IM,NY,NB,NL,HDR] = load_fid(fid_name);
% Para=getpar(fid_name,'ns','pelist','etl','np','lro');
% K_space_data=RE+1i*IM;
% num_slice=Para.ns;
% num_phase = Para.np/2;
% num_etl=Para.etl;
% FOVx = Para.lro*10;%unit mm the parameters can be found in procpar
% FOVy = FOVx;%mm
% pelist=Para.pelist;
% pelist = pelist + num_phase/2;
% cest_image_out = zeros(num_phase,num_phase,25);
% sel_line = 16;
% deg = 7.2;
% row = 128;
% col = 128;
% ppm_num = 25;
% propeller_K = zeros(row,col,ppm_num);
% mask_org = zeros(row,col);
% mask_org(floor(row/2)-floor(sel_line/2):floor(row/2)+floor(sel_line/2)-1,:)=ones(sel_line,col);
% for slicei  = 1:1
%     for loopj = 1:25
%         ph_sel = [];
%         phi_start = (loopj-1)*num_slice*num_phase;
%         for loop_phi = 1:num_phase/num_etl
%             ph_sel = [ph_sel,phi_start+(loop_phi-1)*num_slice*num_etl+(slicei-1)*num_etl+1:phi_start+(loop_phi-1)*num_slice*num_etl+slicei*num_etl];
%         end
%         WJG_K = K_space_data(:,ph_sel);
%         WJG_K(:,pelist(:)) = WJG_K;
%         mask_rot = imrotate(mask_org,deg*(loopj-1), 'nearest');
%         [row_rot,col_rot] = size(mask_rot);
%         mask(:,:) = mask_rot(floor((row_rot-row)/2)+1:floor((row_rot+row)/2),floor((col_rot-col)/2)+1:floor((col_rot+col)/2));
%         K_space = WJG_K.*mask;
%         propeller_K(:,:,loopj) = K_space;
%     end
% %% normalized the data
% max_K = max(abs(propeller_K(:)));
% propeller_I = zeros(row,col,ppm_num+1);
% for loopi=1:ppm_num
%     temp_K = propeller_K(:,:,loopi)/max_K;
%     temp_I = abs(ifftshift(ifft2(fftshift(temp_K))));
%     propeller_I(:,:,loopi) = temp_I*row*col;
% end   
% max_I = max(propeller_I(:));
% propeller_I = propeller_I/max_I;
% propeller_I(:,:,ppm_num+1) = zeros(row,col);
% % WJG_show_cest(propeller_I,0)
% propeller_I = permute(propeller_I,[3,1,2]);
% 
% %% save
% filename1=['sample4train/xmu_phantom',num2str(slicei),'.Charles'];
% [fid,msg]=fopen(filename1,'wb');
% fwrite(fid, propeller_I,'single');
% fclose(fid); 
% 
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% XMU propeller acquisition experiment
% clc
% clear 
% % close all
% 
% addpath('../cest_tool')
% 
% ppm_num = 25;
% output_channel = 3;
% load('../propeller/egg_25_slice1_propeller.mat')
% %% normalized the data
% [row,col,slice] = size(cest_image_out);
% propeller_I = zeros(row,col,ppm_num+output_channel);
% propeller_I(:,:,1:ppm_num) = abs(cest_image_out);
% image_max = propeller_I(:,:,1);
% image_max = max(abs(image_max(:)));  
% propeller_I = propeller_I/image_max;
% propeller_I = permute(propeller_I,[3,1,2]);
% 
% %% save
% filename1=['xmu_egg_propeller_slice',num2str(1),'.Charles'];
% [fid,msg]=fopen(filename1,'wb');
% fwrite(fid, propeller_I,'single');
% fclose(fid); 



