%analysis paramaters of lorentz  curve
%for fse
% created by WJ angus
%  wjtcw@hotmail.com
%2018.8.4
clc
clear 
close all 
%%the order of phase
% cc=[-7	-15	-23	-31	-39	-47	-55	-63	-6	-14	-22	-30	-38	-46	-54	-62	-5	-13	-21	-29	-37	-45	-53	-61	-4	-12	-20	-28	-36	-44	-52	-60 -3	-11	-19	-27	-35	-43	-51	-59 -2	-10	-18	-26	-34	-42	-50	-58	-1	 -9	-17	-25	-33	-41	-49	-57	 0	 -8	-16	-24	-32	-40	-48	-56	1	  9	 17	 25	 33	 41	 49	 57	2	 10	 18	 26	 34	 42	 50	 58	3	 11	 19	 27	 35	 43	 51	 59	 4	 12	 20	 28	 36	 44	 52	 60	5	 13	 21	 29	 37	 45	 53	 61	 6	 14	 22	 30	 38	 46	 54	 62	 7	 15	 23	 31	 39	 47	 55	 63	8	 16	 24	 32	 40	 48	 56	 64];
% cc=cc+64;
cc = [ -3 -7 -11 -15 -19 -23 -27 -31 -2 -6 -10 -14	-18	-22	-26	-30 -1 -5 -9 -13 -17 -21 -25 -29  0	 -4	 -8	-12	-16	-20	-24	-28	  1	  5	  9	 13	 17	 21	 25	 29	  2	  6	 10	 14	 18	 22	 26	 30	  3	  7	 11	 15	 19	 23	 27	 31	  4	  8	 12	 16	 20	 24	 28	 32	];
cc = cc+32;
dirname='D:\CEST Ä£Äâ\cjz_dataprocessing\20180709';
fid_dir_all=dir([dirname,'\fse_25*']);       %list all directories
nphase= 64;
fre_num = 25;   %the number of frequency
divide = 32; %divide the image
ave_value = zeros(divide,divide,fre_num);
output_Z_para=[];
for loopi = 1:length(fid_dir_all)
    fid_name =[dirname,'\',fid_dir_all(loopi).name];
    [RE,IM,NP,NB,NT,HDR] = load_fid(fid_name);
    k=RE+1i*IM;
    for frame = 1:fre_num  %ÓÐ¼¸·ùÍ¼Ïñ
%        subplot(ceil(sqrt(fre_num)),ceil(sqrt(fre_num)),frame)
        II1 = k(:,(frame-1)*nphase+1:(frame-1)*nphase+nphase);
        II2(:,cc) = II1;
        II3 = ifftshift(ifft2(fftshift(II2)));
%         imshow(abs(II3),[])
        [row,col] = size(II3);
        B=blkproc(abs(II3),[row/divide col/divide],@mean2);
        ave_value(:,:,frame) = B;
%         imshow(abs(ave_value(:,:,frame)),[])
    end
    output_Z_para = [output_Z_para;WJG_zspec(ave_value)];    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%show the parameters in image
K2_min =0;
K2_max =7;
K3_min =-10;%
K3_max =1;%
K2=output_Z_para(:,2);
K3=output_Z_para(:,3);
distribution_para=zeros(1001,1001);

for loopi = 1:length(output_Z_para)
    K2(loopi) = min(K2(loopi),K2_max);%clip the min max data
    K2(loopi) = max(K2(loopi),K2_min);
    K3(loopi) = min(K3(loopi),K3_max);
    K3(loopi) = max(K3(loopi),K3_min);
    
    loc_row = floor((K2(loopi)-K2_min)/((K2_max-K2_min)/1000))+1;
    loc_col = floor((K3(loopi)-K3_min)/((K3_max-K3_min)/1000))+1;
    distribution_para(loc_row,loc_col) = distribution_para(loc_row,loc_col) +1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the range of K2 & K3
K2_min =0;
K2_max =7;
K3_min =-10;%
K3_max =1;%
imagesc(distribution_para);
K2K3_range = range4_k2k3(distribution_para,K2_min,K2_max,K3_min,K3_max);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%generate K2 & K3 randomly
%load('K2K3_range.mat')
K2_min = K2K3_range.K2_min;
K2_max = K2K3_range.K2_max;
K3_min = K2K3_range.K3_min;
K3_max = K2K3_range.K3_max;
K2K3_mask = K2K3_range.BW;
[row,col] = size(K2K3_mask);
figure;imshow(K2K3_mask);hold on 

for loopi = 1:1
    while 1
        K2 = unifrnd(K2_min,K2_max);
        loc_row = floor((K2-K2_min)/((K2_max-K2_min)/1000))+1;
        K3 = unifrnd(K3_min,K3_max);
        loc_col = floor((K3-K3_min)/((K3_max-K3_min)/1000))+1;
        if (K2K3_mask(loc_row,loc_col)>0)
            plot(loc_col,loc_row,'*')
            break;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the Z spec correpond with K2 and K3
figure;
x = -6:0.5:6;
K(1)=1;K(2) =K2;K(3) =K3;K(4) =0;
Lof=Lofun(K,x);
plot(Lof)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%generate cest image with different frequency point









