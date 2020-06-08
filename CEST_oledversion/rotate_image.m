%process the result of eeg
% norm the data
%for deep learning
%
% created by MLC
% modified by Angus, wjtcw@hotmail.com
clear ; close all;  clc

dirname='D:\进展2\cest_simu\cest_simu\sample\';
outputdir = 'D:\进展2\cest_simu\cest_simu\rotate_mat\';

WJG_order=1;
sel_line = 60;
fid_file_all1=dir([dirname,'rotate_mat*']);       %list all files
for loopj = 1:length(fid_file_all1)
    fid_file =[dirname,fid_file_all1(loopj).name];
    load(fid_file)
    [row,col,slice] =size(cest_image_out) ;
    deg=14.4;
    sel_line = 40;
     cest_image = zeros(row,col);
    for loopi=1:slice
        cest_image1 =zeros(row,col);
        img_f=fftshift(fft2(ifftshift(cest_image_out(:,:, loopi))));
        img_rota=imrotate(img_f,deg*(loopi-1), 'bicubic');
        cest_image=imrotate( cest_image,deg*(loopi-1), 'bicubic');
        [rot_row,rot_col] = size(cest_image); 
        cest_image= cest_image(floor((rot_row-row)/2)+1:floor((rot_row+row)/2),floor((rot_col-col)/2)+1:floor((rot_col+col)/2));
        cest_image1(:,end/2-sel_line/2:end/2+sel_line/2)= img_rota((end-row)/2+1:(end+row)/2,end/2-sel_line/2:end/2+sel_line/2);   
         cest_image=cest_image1+cest_image;
%           imagesc(abs(cest_image1));colormap jet
        %     subplot(ceil(sqrt(slice)),ceil(sqrt(slice)), loopi);
         image_I = ifftshift(ifft2(fftshift(cest_image)));
        image_I = image_I(end/2-64:end/2+64-1,end/2-64:end/2+64-1);
        
        %      imagesc(abs(image_final(end/2-64:end/2+64,end/2-64:end/2+64)));colormap jet    

        %      imshow( img_f,[]);
    end
         output(:,:,1) = image_I;
        cest_label = cest_image_out(:,:,20);
        cest_label =  cest_label(end/2-64:end/2+64-1,end/2-64:end/2+64-1);
        output(:,:,2) =cest_label;
        %%%%%%%%%%%%
         filename1=strcat('rotate_mat',num2str(WJG_order),'.mat');
         filenames=strcat('D:\进展2\cest_simu\cest_simu\rotate_mat','\',filename1);
          save(filenames,'output');
          %%%%%%%%%%
        filename=[outputdir,num2str(WJG_order),'.Charles'];
        [fid,msg]=fopen(filename,'wb');
        fwrite(fid,output,'double');
        fclose(fid); 
        WJG_order = WJG_order+1;
        disp(WJG_order)
end

%      imshow( image_final(:,:,25),[]);
%  imshow(image_final,[]);
%  imagesc(abs(image_final));colormap jet    