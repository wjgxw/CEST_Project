%sampling the cest images with propeller scheme
%2019.3.3
%modified 2019.6.22
% created by Angus, wjtcw@hotmail.com
clc
clear 
close all
addpath('func')
addpath('../cest_tool')
%% parameters
row = 128;
col = 128;
slice = 21;
output_channel = 3;
sel_line = 16;
deg = 7.2;
sigma = 0.01; %add noise to samples
sample_dir = '../gen_sample/data1/';
output_dir = ['../gen_sample/data4train1/'];
fid_dir_all = dir([sample_dir,'*.mat']);       %list all files
propeller_K = zeros(row,col,slice);
propeller_I = zeros(row,col,slice+output_channel);

for loopj = 1:length(fid_dir_all)
    fid_file = [sample_dir,fid_dir_all(loopj).name];
    load(fid_file);
    [row,col,~] = size(cest_image_out);
    mask_org = zeros(row,col);
    mask_org(floor(row/2)-floor(sel_line/2):floor(row/2)+floor(sel_line/2)-1,:)=ones(sel_line,col);
    for loopi = 1:slice
        img_rot = imrotate(mask_org,deg*(loopi-1), 'nearest');
        [row_rot,col_rot] = size(img_rot);
        mask(:,:) = img_rot(floor((row_rot-row)/2)+1:floor((row_rot+row)/2),floor((col_rot-col)/2)+1:floor((col_rot+col)/2));
        K_space = fftshift(fft2(ifftshift(cest_image_out(:,:, loopi)))).*mask;
        propeller_K(:,:,loopi) = K_space;
    end
    for loopi=1:slice
        temp_K = propeller_K(:,:,loopi);
        temp_I = abs( ifftshift(ifft2(fftshift(temp_K))));
%         subplot(6,5,loopi);
%         imagesc((abs(temp_I)));colormap jet;axis off
        propeller_I(:,:,loopi) = temp_I;
    end      
    image_max = propeller_I(:,:,1);
    image_max = max(image_max(:));
    propeller_I(:,:,slice+1:end) = cest_image_out(:,:,slice+2:end);
    % adjust B0
    propeller_I(:,:,end) = propeller_I(:,:,end).*((propeller_I(:,:,1)/image_max)>0.1);
    for loopi = 1:slice
        propeller_I(:,:,loopi) = propeller_I(:,:,loopi)/image_max+normrnd(0,sigma,row,col);
    end

    %% save
    propeller_I_final = permute(propeller_I,[3,1,2]);
    filename1=[output_dir, num2str(loopj),'.Charles'];
    [fid,msg]=fopen(filename1,'wb');
    fwrite(fid, propeller_I_final,'single');
    fclose(fid); 
    loopj
end    
%    figure;
% for loopi = 1:30
%     subplot(5,6,loopi);
%     imagesc(propeller_I(:,:, loopi));colormap jet;axis off
% end   
% WJG_show_cest(cest_image_out(:,:,1:25),0)