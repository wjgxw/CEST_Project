%simulate the propeller acquisition scheme in cest images
%input WJG_generate_cest_simu.m
%output : the downsampled images (mag) 
%2019.1.23
% created by Angus, wjtcw@hotmail.com

clear 
close all
clc
sel_line = 10;      %  the number of acquisition lines in each k-space
deg=7.2;            % degree for propeller
dirname='/data1/wj/data/cest/';
fid_dir_all=dir([dirname,'*.mat']);       %list all directories
propeller_cest=zeros(slice,row,col);    % downsampled data, include inputs and label
for loopj =1:length(fid_dir_all)
    fid_file =[dirname,fid_dir_all(loopj).name];
    load(fid_file);
    [row,col,slice] = size(cest_image_out);
    img_noise=abs(normrnd(0,3e-2,row,col,25))+0.004;%???
    cest_image_out(:,:,1:25) =  cest_image_out(:,:,1:25)+img_noise;

%     result=zeros(slice+1,row,col);
%      mask_org=zeros(row,2*col,slice);
     mask_org=zeros(row,col,slice);
%      mask_org(floor(row/2)-floor(sel_line/2):floor(row/2)+floor(sel_line/2)-1,:,:)=ones(sel_line,2*col,slice);
   mask_org(floor(row/2)-floor(sel_line/2):floor(row/2)+floor(sel_line/2)-1,:,:)=ones(sel_line,col,slice);
%       imshow(mask_org(:,:,15));
    for loopi=1:slice-1
        img_roat=imrotate(mask_org(:,:,loopi),deg*(loopi-1), 'nearest');
        [row_roat,col_roat,slice_roat] = size(img_roat);
        mask(:,:)=img_roat(floor((row_roat-row)/2)+1:floor((row_roat+row)/2),floor((col_roat-col)/2)+1:floor((col_roat+col)/2));
        %%%
%         nor = abs(cest_image_out(:,:, 1));
%         nor = max(nor(:));
%         cest_image_out(:,:, loopi)=cest_image_out(:,:, loopi)./nor;
        img_f=fftshift(fft2(ifftshift(cest_image_out(:,:, loopi))));
        img_temp = abs( ifftshift(ifft2(fftshift(  img_f.*mask))));
        propeller_cest(loopi,:,:)=img_temp;
%            imagesc(squeeze( result(loopi+1,:,:)));colormap jet
    end
%        result(loopi+1,:,:)=abs((cest_image_out(:,:,9))-(cest_image_out(:,:,17)));
%         result(loopi+1,:,:)=imnoise(abs(cest_image_out(:,:,20)),'gaussian',0,0.01);
%      result=result./(max(result(:)));

 nor=abs((cest_image_out(:,:,1)));
         result_f = squeeze( result_f);%????

%%%%
%      img_noise=normrnd(0,3e-3,25,row,col);
%    result_f(1:25,:,:) =   result_f(1:25,:,:)+img_noise;
%       result_f = (result_f>=1).*1+(result_f<1).*result_f;
%       result_f= result_f./(max(result_f(:)));
      result_f(26,:,:) = abs((cest_image_out(:,:,26)));

%      result = (result>1).*1+(result<=1).*result;
    filename1=[num2str(loopj),'.bin'];
    [fid,~]=fopen(filename1,'wb');
    fwrite(fid, result_f,'single'); % 'single' because gpu can only process data with single precision
    fclose(fid); 
    loopj
end    
   
