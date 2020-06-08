clc
clear 
% close all
fre_num=25;
fid_name = 'D:\CEST 模拟\cjz_dataprocessing\20180709\fse_25dofs_26db_4slice.fid';
[RE,IM,NP,NB,NT,HDR] = load_fid(fid_name);
k=RE+1i*IM;
nphase= 64;
%%相位顺序
% cc=[-7	-15	-23	-31	-39	-47	-55	-63	-6	-14	-22	-30	-38	-46	-54	-62	-5	-13	-21	-29	-37	-45	-53	-61	-4	-12	-20	-28	-36	-44	-52	-60 -3	-11	-19	-27	-35	-43	-51	-59 -2	-10	-18	-26	-34	-42	-50	-58	-1	 -9	-17	-25	-33	-41	-49	-57	 0	 -8	-16	-24	-32	-40	-48	-56	1	  9	 17	 25	 33	 41	 49	 57	2	 10	 18	 26	 34	 42	 50	 58	3	 11	 19	 27	 35	 43	 51	 59	 4	 12	 20	 28	 36	 44	 52	 60	5	 13	 21	 29	 37	 45	 53	 61	 6	 14	 22	 30	 38	 46	 54	 62	 7	 15	 23	 31	 39	 47	 55	 63	8	 16	 24	 32	 40	 48	 56	 64];
% cc=cc+64;
cc = [ -3 -7 -11 -15 -19 -23 -27 -31 -2 -6 -10 -14	-18	-22	-26	-30 -1 -5 -9 -13 -17 -21 -25 -29  0	 -4	 -8	-12	-16	-20	-24	-28	  1	  5	  9	 13	 17	 21	 25	 29	  2	  6	 10	 14	 18	 22	 26	 30	  3	  7	 11	 15	 19	 23	 27	 31	  4	  8	 12	 16	 20	 24	 28	 32	];
cc = cc+32;
%%   画图
%     figure(1) ;
divide = 8;
ave_value = zeros(divide,divide,fre_num);

for frame = 1:fre_num  %有几幅图像
%       subplot(ceil(sqrt(fre_num)),ceil(sqrt(fre_num)),frame)
    II1 = k(:,(frame-1)*nphase+1:(frame-1)*nphase+nphase);
    II2(:,cc) = II1;
    II3 = ifftshift(ifft2(fftshift(II2)));
%      imshow(abs(II3),[])
    [row,col] = size(II3);
    B=blkproc(abs(II3),[row/divide col/divide],@mean2);
    ave_value(:,:,frame) = B;
end

% figure(2) ;
for loopi = 1:divide
    for loopj = 1:divide
        temp_ave_value = ave_value(loopi,loopj,:);
        temp_ave_value = squeeze(temp_ave_value);
        temp_ave_value=temp_ave_value/max(temp_ave_value);%归一化
        %%   Z谱
        Loy = cest_effect_NOE(temp_ave_value,fre_num);
        %   fre_num=31;
        n=linspace(6,-6,fre_num);
        n1=linspace(6,-6,length(Loy));
%         n=6:-0.5:-6;
%         subplot(divide,divide,(loopi-1)*divide+loopj)
%         plot(n,temp_ave_value,n1,Loy);
%         title(num2str((loopi-1)*divide+loopj))
%         xlim([-6 6])
%         pause(0.01)
    end
end