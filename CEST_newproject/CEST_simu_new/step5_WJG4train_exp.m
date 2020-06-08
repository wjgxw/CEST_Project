%sampling the experiment data with propeller scheme
%2019.6.21

% created by Angus, wjtcw@hotmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  norm1
clc
clear 
close all
addpath('../cest_tool')
ppm_num = 21;
output_channel = 3;
fid_file = 'Isreal_data_21_m0.mat';
load(fid_file);
[row,col,slice] = size(cest_image_out);
output = zeros(row,col,ppm_num+output_channel);
output(:,:,1:ppm_num) = cest_image_out(:,:,1:end-1);
image_max = cest_image_out(:,:,end);
image_max = max(image_max(:));
for loopi = 1:ppm_num
    output(:,:,loopi) = output(:,:,loopi)/image_max;
end
for loopi=1:ppm_num+output_channel
    temp_I = output(:,:,loopi);
    subplot(5,6,loopi);
    imagesc(((temp_I)),[0,1]);colormap jet;axis off
end 
output = permute(output,[3,1,2]);

%% save
filename1='1.Charles';
[fid,msg]=fopen(filename1,'wb');
fwrite(fid, output,'single');
fclose(fid); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



