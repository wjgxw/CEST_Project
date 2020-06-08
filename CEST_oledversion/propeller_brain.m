clear ; close all;  clc
% imagesc(abs(image));colormap jet;
% imagesc(abs(image(:,:,1) ));colormap jet;
%  img_f=fftshift(fft2(ifftshift(image(:,:,1))));
%  figure;
%    imagesc(abs( img_f));colormap jet;
%   image_I = ifftshift(ifft2(fftshift( img_f)));
%   figure;
%   imagesc(abs( image_I ));colormap jet;
sel_line = 10;
deg=7.2;
dirname='D:\进展2\cest_simu\cest_simu\2018_11_05_fsecset_realdata_128\';
fid_dir_all=dir([dirname,'real_data_fse*']);       %list all directories
for loopj =1:length(fid_dir_all)
    fid_file =[dirname,fid_dir_all(loopj).name];
    load(fid_file);
    cest_image_out = image;
     nor=max(abs((cest_image_out(:))));
      for loopi = 1:25
        cest_image_out(:,:,loopi)=cest_image_out(:,:,loopi)./nor ;
      end
%     I=abs(cest_image_out(:,:,1));
%     I=I/max(I(:));
%     level = graythresh(  I );%%matlab 自带的自动确定阈值的方法，大津法，类间方差
%     BW = im2bw( I ,level);%%用得到的阈值直接对图像进行二值化


%      for loopx = 1:25
%         cest_image_out(:,:,loopx)= cest_image_out(:,:,loopx).*BW;
%     end
%     imshow(BW);
%%%%EPI


%%%%%
    [row,col,slice] = size(cest_image_out);
    result_f=zeros(slice,row,col);
%     result=zeros(slice+1,row,col);
%      mask_org=zeros(row,2*col,slice);
     mask_org=zeros(row,col,slice);
%      mask_org(floor(row/2)-floor(sel_line/2):floor(row/2)+floor(sel_line/2)-1,:,:)=ones(sel_line,2*col,slice);
   mask_org(floor(row/2)-floor(sel_line/2):floor(row/2)+floor(sel_line/2)-1,:,:)=ones(sel_line,col,slice);
%       imshow(mask_org(:,:,15));
    for loopi=1:slice-1
%         img_roat=imrotate(mask_org(:,:,loopi),deg*(loopi-1), 'bilinear','crop');
        img_roat=imrotate(mask_org(:,:,loopi),deg*(loopi-1), 'bilinear');
        [row_roat,col_roat,slice_roat] = size(img_roat);
        mask(:,:)=img_roat(floor((row_roat-row)/2)+1:floor((row_roat+row)/2),floor((col_roat-col)/2)+1:floor((col_roat+col)/2));
%          mask(:,:)=img_roat;
        %%%
%         nor = abs(cest_image_out(:,:, 1));
%         nor = max(nor(:));
%         cest_image_out(:,:, loopi)=cest_image_out(:,:, loopi)./nor;
        %%%

        img_f=fftshift(fft2(ifftshift(cest_image_out(:,:, loopi))));
%         img_f([123:128,1:122],:)= img_f([5:-1:1,6:128],:);
         img_f([127:128,1:126],:)= img_f([2:-1:1,3:128],:);
         img_f(:,[1,2:128])= img_f(:,[128,1:127]);
        img_temp = abs( ifftshift(ifft2(fftshift(  img_f.*mask))));
         result_f(loopi,:,:)=img_temp;
           
%         imagesc(abs(img_f));
       
        
%        figure;    imagesc(log(abs( img_f)));colormap jet
% figure(1)
%             subplot(5,5,loopi);
%           imagesc(abs(cest_image_out(:,:,loopi)));colormap jet
%               subplot(5,5,loopi);
%        imagesc(log(abs( img_f.*mask)),[-10,10]);colormap jet
%         subplot(5,5,loopi);
%        imshow(mask)
    % if loopi==20
% figure(2)
%            subplot(5,5,loopi);
%            imagesc(squeeze( result_f(loopi,:,:)));colormap jet
    % end
    end
%        result(loopi+1,:,:)=abs((cest_image_out(:,:,9))-(cest_image_out(:,:,17)));
%         result(loopi+1,:,:)=imnoise(abs(cest_image_out(:,:,20)),'gaussian',0,0.01);
%      result=result./(max(result(:)));
%     filename=strcat('propeller',num2str(loopj),'.mat');   
%     filenames=strcat('D:\进展2\cest_simu\cest_simu\propeller_mat','\',filename);
%  %    save('D:\进展2\cest_simu\cest_simu\example\filename','cest_image_out')
%     save(filenames,'result');   
    %%%%%%%
%     M0 = result(1,:,:);
%     M0= reshape(M0,[row,col]);
%     M1 = result(2,:,:);
%     M1= reshape(M1,[row,col]);
%     nor = abs( M0+M1)/2;
%     nor=max(nor(:));

%     M2 = result(2,:,:);
%     M2= reshape(M2,[row,col]);
%     M0 = (M0+M2)/2;
%%%%%FSE
 nor=abs((cest_image_out(:,:,1)));
    for loopi = 1:25
%          result_f(loopi,:,:) = squeeze( result_f(loopi,:,:)) .*BW;
         result_f(loopi,:,:) = squeeze( result_f(loopi,:,:)) ;
    end
%%%%

%       result_f = (result_f>=3).*3+(result_f<1).*result_f;
%       result_f= result_f./(max(result_f(:)));
%%%fse
      result_f(26,:,:) = abs((cest_image_out(:,:,26)));
         

%      result = (result>1).*1+(result<=1).*result;
    filename1=['D:\进展2\cest_simu\cest_simu\2018_11_05_fsecset_realdata_128_chars\',num2str(loopj),'.Charles'];
    [fid,msg]=fopen(filename1,'wb');
    fwrite(fid, result_f,'double');
    fclose(fid); 
    loopj
end    
%    figure;
% for loopi = 1:25
% subplot(5,5,loopi);
% %  imagesc(squeeze( result_f(loopi,:,:)),[0,1]);colormap jet
%  imagesc(abs(cest_image_out(:,:,loopi)),[0,1]);colormap jet
% end