clc
clear 
close all
fre_num=25;
 mydir='D:\CEST 模拟\cjz_dataprocessing\';
filenames_fse=dir([mydir,'2018.11.05.fse_cest_128*']);
nphase= 128;
% expend =  128;
%%相位顺序
cc=[-3 -7 -11 -15 -19 -23 -27 -31 -35 -39 -43 -47 -51 -55 -59 -63 -2 -6 -10 -14 -18 -22 -26 -30 -34 -38 -42 -46 -50 -54 -58 -62 -1 -5 -9 -13 -17 -21 -25 -29 -33 -37 -41 -45 -49 -53 -57 -61 0 -4 -8 -12 -16 -20 -24 -28 -32 -36 -40 -44 -48 -52 -56 -60 1 5 9 13 17 21 25 29 33 37 41 45 49 53 57 61 2 6 10 14 18 22 26 30 34 38 42 46 50 54 58 62 3 7 11 15 19 23 27 31 35 39 43 47 51 55 59 63 4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 ];
cc=cc+64;
%%   画图
for i=1:length(filenames_fse)
%     ave_value = zeros(expend,expend,fre_num);
%     image=zeros(expend,expend,fre_num);
    filename=[mydir,filenames_fse(i).name];
    %filename就是单个文件名了
    [RE,IM,NP,NB,NT,HDR] = load_fid(filename);
    k=RE+1i*IM;
    for frame = 1:fre_num  %有几幅图像
    %       subplot(ceil(sqrt(fre_num)),ceil(sqrt(fre_num)),frame)
    II1 = k(:,(frame-1)*nphase+1:(frame-1)*nphase+nphase);
    II2(:,cc) = II1;
    % II3 = ifftshift(ifft2(fftshift( II2)));
    %  imagesc(abs(II3))  
%      imagesc(abs(II2))
%     expend_K = zeros(expend,expend);
%     expend_K((expend-nphase)/2+1:expend-nphase/2,(expend-nphase)/2+1:expend-nphase/2) = II2;
    ave_value(:,:,frame) = II2;
     II3 = ifftshift(ifft2(fftshift(II2)));
     image(:,:,frame) = II3;
    %     imagesc(abs(II3))
    end
    %%%%
     image(:,:,frame+1) = II3;
     %%%%
    filename_var=strcat('real_data_fse',num2str(i),'.mat');   
    filename_final=strcat('2018_11_05_fsecset_realdata_128','\',filename_var);
    save( filename_final,'image');  
    i

end 
% for loopi = 1:25
% subplot(5,5,loopi);
%  imagesc(abs(squeeze(image(:,:,loopi))),[0,3]);colormap jet
% %   imagesc(abs(cest_image_out(:,:,loopi)));colormap jet
% end