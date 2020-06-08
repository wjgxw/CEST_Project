%sampling the cest images with full samle scheme
%2019.3.3
%modified 2019.6.22
% created by Angus, wjtcw@hotmail.com
%%%%%%%%%%%%%%%%%%%%%norm1
clc
clear 
close all
addpath('func')
addpath('../cest_tool')
row = 128;
col = 128;
slice = 21;
sigma = 1e-2;
sample_dir = '../gen_sample/data1/';
output_dir = ['../gen_sample/data4train1/'];
fid_dir_all = dir([sample_dir,'*.mat']);       %list all files
propeller_K = zeros(row,col,slice);
for loopj = 1:length(fid_dir_all)
    fid_file = [sample_dir,fid_dir_all(loopj).name];
    load(fid_file);
    image_max = cest_image_out(:,:,slice);
    image_max = max(image_max(:));
    % adjust B0
    cest_image_out(:,:,end) = cest_image_out(:,:,end).*((cest_image_out(:,:,1)/image_max)>0.1);
    for loopi = 1:slice
        cest_image_out(:,:,loopi) = cest_image_out(:,:,loopi)/image_max+normrnd(0,sigma,row,col);
    end

    %% save
    output =cat(3, cest_image_out(:,:,1:slice),cest_image_out(:,:,end-2:end));
%     WJG_show_cest(output,0)
    output = permute(output,[3,1,2]);
    filename1=[output_dir, num2str(loopj),'.Charles'];
    [fid,msg]=fopen(filename1,'wb');
    fwrite(fid, output,'single');
    fclose(fid); 
    loopj
end    

