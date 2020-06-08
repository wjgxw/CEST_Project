clc
clear 
close all
fre_num=25;
 mydir='D:\CEST 模拟\cjz_dataprocessing\20180709\';
filenames_fse=dir([mydir,'epi_25dofs*']);
fid_name = 'D:\CEST 模拟\cjz_dataprocessing\20180709\fse_25dofs_26db_11slice.fid';

% nphase= 64;
% expend =  128;
% %%相位顺序
% % cc=[-7	-15	-23	-31	-39	-47	-55	-63	-6	-14	-22	-30	-38	-46	-54	-62	-5	-13	-21	-29	-37	-45	-53	-61	-4	-12	-20	-28	-36	-44	-52	-60 -3	-11	-19	-27	-35	-43	-51	-59 -2	-10	-18	-26	-34	-42	-50	-58	-1	 -9	-17	-25	-33	-41	-49	-57	 0	 -8	-16	-24	-32	-40	-48	-56	1	  9	 17	 25	 33	 41	 49	 57	2	 10	 18	 26	 34	 42	 50	 58	3	 11	 19	 27	 35	 43	 51	 59	 4	 12	 20	 28	 36	 44	 52	 60	5	 13	 21	 29	 37	 45	 53	 61	 6	 14	 22	 30	 38	 46	 54	 62	 7	 15	 23	 31	 39	 47	 55	 63	8	 16	 24	 32	 40	 48	 56	 64];
% % cc=cc+64;
% cc = [ -3 -7 -11 -15 -19 -23 -27 -31 -2 -6 -10 -14	-18	-22	-26	-30 -1 -5 -9 -13 -17 -21 -25 -29  0	 -4	 -8	-12	-16	-20	-24	-28	  1	  5	  9	 13	 17	 21	 25	 29	  2	  6	 10	 14	 18	 22	 26	 30	  3	  7	 11	 15	 19	 23	 27	 31	  4	  8	 12	 16	 20	 24	 28	 32	];
% cc = cc+32;
% %%   画图
% for i=1:length(filenames_fse)
%     ave_value = zeros(expend,expend,fre_num);
%     image=zeros(expend,expend,fre_num);
%     filename=[mydir,filenames_fse(i).name];
%     %filename就是单个文件名了
%     [RE,IM,NP,NB,NT,HDR] = load_fid(filename);
%     k=RE+1i*IM;
%     for frame = 1:fre_num  %有几幅图像
%     %       subplot(ceil(sqrt(fre_num)),ceil(sqrt(fre_num)),frame)
%     II1 = k(:,(frame-1)*nphase+1:(frame-1)*nphase+nphase);
%     II2(:,cc) = II1;
%     % II3 = ifftshift(ifft2(fftshift( II2)));
%     %  imagesc(abs(II3))  
% %      imagesc(abs(II2))
%     expend_K = zeros(expend,expend);
%     expend_K((expend-nphase)/2+1:expend-nphase/2,(expend-nphase)/2+1:expend-nphase/2) = II2;
%     ave_value(:,:,frame) = expend_K;
%      II3 = ifftshift(ifft2(fftshift(expend_K)));
%      image(:,:,frame) = II3;
%     %     imagesc(abs(II3))
%     end
%     %%%%
%      image(:,:,frame+1) = II3;
%      %%%%
%     filename_var=strcat('real_data_fse',num2str(i),'.mat');   
%     filename_final=strcat('D:\进展2\cest_simu\cest_simu\real_egg_data','\',filename_var);
%     save( filename_final,'image');  
% 
% end 
%%%%%%%%%%%%%%%%%%%%%%%%%
% epi
%%%%%%%%%%%%%%
% nphase= 64;
% expend =  128;
% fre_num=25;
% cc_epi=[ 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 -16 -17 -18 -19 -20 -21 -22 -23 -24 -25 -26 -27 -28 -29 -30 -31 ];
% cc_epi= cc_epi+32;
% filenames_epi=dir([mydir,'epi_25*']);
% for i=1:length(filenames_epi)
%     ave_value = zeros(expend,expend,fre_num);
%     image=zeros(expend,expend,fre_num);
%     filename=[mydir,filenames_epi(i).name];
%     %filename就是单个文件名了
%     [RE,IM,NP,NB,NT,HDR] = load_fid(filename);
%     k=RE+1i*IM;
%     for frame = 1:fre_num  %有几幅图像
% %           subplot(ceil(sqrt(fre_num)),ceil(sqrt(fre_num)),frame)
%     II1 = k(:,(frame)*nphase+1:(frame)*nphase+nphase);
%     II1(:,2:2:end)= flipud(II1(:,2:2:end));    %should be changed
%     expend_K = zeros(expend,expend);
%     expend_K((expend-nphase)/2+1:expend-nphase/2,(expend-nphase)/2+1:expend-nphase/2) = II1;
%     ave_value(:,:,frame) = expend_K;
%      II3 = ifftshift(ifft2(fftshift(expend_K)));
% %      II4=ifftshift(ifft2(fftshift( II1)));
%      image(:,:,frame) = II3;
% %       imagesc(abs(II3))
%     end
%     image(:,:,frame+1) = II3;
%     filename_var=strcat('real_data_epi',num2str(i),'.mat');   
%     filename_final=strcat('D:\进展2\cest_simu\cest_simu\real_data','\',filename_var);
%     save( filename_final,'image');  
% % imagesc(abs(expend_K));colormap jet
%   i
% end 
% % imagesc(abs(expend_K));colormap jet