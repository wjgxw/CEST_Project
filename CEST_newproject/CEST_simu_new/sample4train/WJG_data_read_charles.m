clc
clear 
% close all
slice = 28;
row =128;
col =128;

filename ='dataset5_withnoe_amine_0.5_16/train/amine2.Charles';
fid = fopen(filename, 'r');
data_in = fread(fid,'single')';
step = length(data_in)/row/col;
% figure;
for loopi = 1:step
    temp_input = data_in(loopi:step:end);
    M1= reshape(temp_input,[row,col]);

    subplot(5,6,loopi);
    imagesc((abs(M1)));colormap jet;axis off
end



