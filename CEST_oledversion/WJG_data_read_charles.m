clc
clear 
close all
slice = 26;
row =128;
col =128;
%D:\进展2\cest_simu\cest_simu\real_data_chars
%D:\进展2\cest_simu\cest_simu\anothertype_cest
filename ='D:\进展2\cest_simu\cest_simu\without_noe_chars\1.Charles';
fid = fopen(filename, 'r');
data_in = fread(fid,'double')';
% fclose('all') 
step = length(data_in)/row/col;
M2=zeros(row,col,slice);
%  M0 = data_in(1:step:end);
%  M0= reshape(M0,[row,col]);
%   M2 = data_in(2:step:end);
%  M2= reshape(M2,[row,col]);
%  M0 = (M0+M2)/2;
% figure;
for loopi = 1:step
    temp_input = data_in(loopi:step:end);
   M1= reshape(temp_input,[row,col]);
%     figure(3);imagesc((abs(M1)));colormap jet
%     imagesc((abs( M1./(M0+eps))),[0,1]);colormap jet
subplot(5,6,loopi);
imagesc((abs(M1)));colormap jet
M2(:,:,loopi)=M2(:,:,loopi)+M1;
% imagesc(log(abs(fftshift(fft2(ifftshift((M1)))))));colormap jet    
end


% figure;
% temp_input = data_in(loopi+1:step:end);
%    M1= reshape(temp_input,[row,col]);
%     imagesc((abs(M1)));colormap jet
% figure()
% image_2D1 = input_data(:,:,6);
% imagesc(abs(image_2D1));colormap jet
% figure;
% image_2D2 = input_data(:,:,20);
% imagesc(abs(image_2D2));colormap jet
% figure;
% image_2D3 = input_data(:,:,26);
% imagesc(abs(image_2D3));colormap jet



