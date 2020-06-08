% generate cest images
% 2019.3.3
% created by Angus, wjtcw@hotmail.com
% add B0
% added mt 
clc
clear 
close all
warning off
addpath('func')
addpath('../cest_tool')
%% parameters
GAMAR = 267522120;
fov = 0.22; %unit m
row = 128;
col = 128;
Mxdims = [row,col,1]; %row, col, slice
DimRes = fov/row;
ppm_start = -5;
ppm_end = 5;
ppm_step = 0.5;
slice = 21+1; %with ppm =100
Hz_per_PPM = 150;
num = 300;      % the number of mask
ratio = 0.6; % the ratio of texture
samplenum = 2000; % the number of samples we want to generate
dirname = '../image/';     % more images can be download from website
dirs=dir([dirname,'*.jpg']);
output_channel = 3; % amide, amine, B0
load('brain_mask');
mask_num = size(brain_mask,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng('shuffle'); % the seed of random
for loopj = 1:800     
    sel_frame = randi([1,mask_num],1); 
    temp_brain_mask = brain_mask(:,:,mod(sel_frame,mask_num)+1);% 
    temp_brain_mask = imresize(temp_brain_mask,[row,col],'nearest');
    temp_brain_mask = repmat(temp_brain_mask,1,1,slice+output_channel);
    cest_image_out=zeros(row,col,slice);
    cest_mask = zeros(row,col);
    cest_effect = zeros(row,col,output_channel);
    % B0
    [VMmg.xgrid,VMmg.ygrid,VMmg.zgrid]=meshgrid((-(Mxdims(2)-1)/2)*DimRes:DimRes:((Mxdims(2)-1)/2)*DimRes,...
                                                (-(Mxdims(1)-1)/2)*DimRes:DimRes:((Mxdims(1)-1)/2)*DimRes,...
                                                (-(Mxdims(3)-1)/2)*DimRes:DimRes:((Mxdims(3)-1)/2)*DimRes);
    dB0=Mag_WW_LSM_CEST(VMmg)*GAMAR/Hz_per_PPM;
   
    for loopi = 1:num
        [cest_image_out,cest_mask,cest_effect] =  WJGshape_cest(cest_effect,cest_image_out,ppm_start,ppm_end,ppm_step,dB0,cest_mask,dirname,dirs,row,col,1,ratio);
        [cest_image_out,cest_mask,cest_effect] =  WJGshape_cest(cest_effect,cest_image_out,ppm_start,ppm_end,ppm_step,dB0,cest_mask,dirname,dirs,row,col,2,ratio);
        [cest_image_out,cest_mask,cest_effect] =  WJGshape_cest(cest_effect,cest_image_out,ppm_start,ppm_end,ppm_step,dB0,cest_mask,dirname,dirs,row,col,4,ratio);
        if (sum(cest_mask(:))>row*col*0.9) 
            break;
        end
    end
%     WJG_show_cest(cest_image_out,0)
%    figure(1); imagesc(cest_effect(:,:,2),[0,0.2]);colormap jet
%    figure(2);   imagesc(abs(cest_image_out(:,:,6)-cest_image_out(:,:,20)),[0,0.2]);colormap jet
    filenames =['../gen_sample/data1/',num2str(loopj),'.mat'];
    cest_image_out(:,:,slice+1:slice+2) = cest_effect;
    cest_image_out(:,:,slice+output_channel) = dB0;
    cest_image_out = cest_image_out.*temp_brain_mask;
    save(filenames,'cest_image_out','-single');
    loopj
end


