%generate cest images
%cest 
%input WJG_cest_sta_main.m
%2018.8.20
% created by Angus, wjtcw@hotmail.com
clc
clear 
close all
row =128;
col =128;
slice = 25;
num = 100;      %the number of mask
sigma = 3;    %gaussian filter
ratio = 0.2; %the ratio of texture
gausFilter = fspecial('gaussian',[16,16],sigma);
samplenum =1000; %the number of samples we want to generate
dirname = '/data1/wj/image/';
dirs=dir([dirname,'*.jpg']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the range of K2 & K3 
load('K2K3_range.mat')
K2_min = K2K3_range.K2_min;
K2_max = K2K3_range.K2_max;
K3_min = K2K3_range.K3_min;
K3_max = K2K3_range.K3_max;
K2K3_mask = K2K3_range.BW;

rng('shuffle');%the seed of random
for loopj = 1:samplenum   
    apt_ppm = 3.5+unifrnd(-0.1,0.1);
%     apt_ppm=[1 + (4.2-1).*rand([1 1])];
%     apt_ppm = 3.5+[-0.5 + (0.5-(-0.5)).*rand([1 1])];
    noe_ppm = -3.5;
    cest_image_out=zeros(row,col,slice);
    cest_mask = zeros(row,col);
    APT = zeros(row,col);
    for loopk = 1:num
        [cest_image_out,cest_mask,APT] =  WJGshape_cest(APT,K2K3_range,cest_image_out,cest_mask,dirname,dirs,row,col,1,ratio,apt_ppm,noe_ppm);
        [cest_image_out,cest_mask,APT] =  WJGshape_cest(APT,K2K3_range,cest_image_out,cest_mask,dirname,dirs,row,col,2,ratio,apt_ppm,noe_ppm);
        [cest_image_out,cest_mask,APT] =  WJGshape_cest(APT,K2K3_range,cest_image_out,cest_mask,dirname,dirs,row,col,3,ratio,apt_ppm,noe_ppm);
        [cest_image_out,cest_mask,APT] =  WJGshape_cest(APT,K2K3_range,cest_image_out,cest_mask,dirname,dirs,row,col,4,ratio,apt_ppm,noe_ppm);
%            WJG_show_cest(cest_image_out)
        if (sum(cest_mask(:))>row*col*0.9) 
            break;
        end
    end
%% gaussian filter    
%     for  loopi = 1:slice
%         cest_image_out(:,:,loopi) = abs(imfilter(cest_image_out(:,:,loopi),gausFilter,'replicate'));
%       end
    filename=['/data1/wj/data/cest/',num2str(loopj),'.mat'];
    cest_image_out(:,:,26) = APT;
    save(filename,'cest_image_out');
    loopj
end


