function [cest_image_out,new_mask,APT_out] =  WJGshape_cest(APT,K2K3_range,cest_image,mask,dirname,dirs,row,col,type,ratio,apt_ppm,noe_ppm)
%�������ͼ�Σ�����ͼ�����������
%���Ѿ����ɵ�ģ��Ļ����ϼ�����Ӽ���ģ��
%maskΪ����ģ��
%dirΪ�������Ĺ�ѧͼ��·��

radius_limit = row;
mini_size = 3;%��С�ߴ�
cest_image_out = cest_image;
APT_out = APT;
switch type 
    case 1    
        %����Բ
        mask1 = zeros(row,col);
        RADIUS = randi([mini_size,round(radius_limit/6)],1); 
        center = randi([5,row-5],1,2); 
        temp_mask = WJGgenCircle(row,RADIUS,center);
        if(sum(temp_mask(:))>5)    %��ֹ���������С��ͼ��
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask);%��ֹģ����ص�
         [cest_image_out,APT_out] = Add_tex(APT,cest_image,dirname,dirs,new_mask,K2K3_range,ratio,apt_ppm,noe_ppm);  
        new_mask = abs(new_mask+mask)>0;  

    case 2
        %���ɻ�
        mask1 = zeros(row,col);
        RADIUS1 = randi([mini_size,round(radius_limit/4)],1);
        RADIUS2 = randi([mini_size,round(radius_limit/16)],1);
        center = randi([-5,5],1,2); 
        temp_mask = WJGgenRing( row,max(RADIUS1,RADIUS2),min(RADIUS1,RADIUS2),center );
        if(sum(temp_mask(:))>5)    %��ֹ���������С��ͼ��
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask);%��ֹģ����ص�
         [cest_image_out,APT_out] = Add_tex(APT,cest_image,dirname,dirs,new_mask,K2K3_range,ratio,apt_ppm,noe_ppm);  

        new_mask = abs(new_mask+mask)>0; 
    case 3
        %����������
        mask1 = zeros(row,col);
        shape = randi([1,round(radius_limit/2)],2,2);  %��С
        center = randi([5,row-row/8],2,1); 
        center = [center,center];
        shape = shape+center;
        x = min([sort(shape(1,:));row,row]);    %���Ʒ�Χ
        y = min([sort(shape(2,:));col,col]);
        vx = [x(1),x(1),x(2),x(2),x(1)];
        vy = [y(1),y(2),y(2),y(1),y(1)];
        temp_mask = WJG_convex_S(row,vx,vy);
        if(sum(temp_mask(:))>5)    %��ֹ���������С��ͼ��
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask);%��ֹģ����ص�
         [cest_image_out,APT_out] = Add_tex(APT,cest_image,dirname,dirs,new_mask,K2K3_range,ratio,apt_ppm,noe_ppm); 
        new_mask = abs(new_mask+mask)>0;
    case 4 
%����������
        mask1 = zeros(row,col);
        shape = randi([1,round(radius_limit/2)],2,3);
        center = randi([5,row--row/8],2,1); 
        center = [center,center,center];
        shape = shape+center;
        x = min([sort(shape(1,:));row,row,row]);
        y = min([sort(shape(2,:));col,col,col]);
        vx = [x(1),x(2),x(3),x(1)];
        vy = [y(1),y(2),y(3),y(1)];
        temp_mask = WJG_convex_S(row,vx,vy);
        if(sum(temp_mask(:))>5)    %��ֹ���������С��ͼ��
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask);%��ֹģ����ص�
        [cest_image_out,APT_out] = Add_tex(APT,cest_image,dirname,dirs,new_mask,K2K3_range,ratio,apt_ppm,noe_ppm);  
        new_mask = abs(new_mask+mask)>0;
end
      
% imshow(mask1+mask2+mask3+mask4)

function [cest_out,APT_out] =  Add_tex(APT,cest_image,dirname,dirs,new_mask,K2K3_range,ratio,apt_ppm,noe_ppm)
ppm_step = 0.01;
x = -6:ppm_step:6;
% the range of K2 K3
K2_min = K2K3_range.K2_min;
K2_max = K2K3_range.K2_max;
K3_min = K2K3_range.K3_min;
K3_max = K2K3_range.K3_max;
K2K3_mask = K2K3_range.BW;
%%%%%%%%%%%%%%%%%%%%%%%%%%water point
%generate K2 K3
while 1
    K2 = unifrnd(K2_min,K2_max);
    loc_row = floor((K2-K2_min)/((K2_max-K2_min)/1000))+1;
    K3 = unifrnd(K3_min,K3_max);
    loc_col = floor((K3-K3_min)/((K3_max-K3_min)/1000))+1;
    if(K2K3_mask(loc_row,loc_col)>0)
        
        K(1)=1;K(2) =K2;K(3) =K3;K(4) =0;
        Lof_W=Lofun(K,x);

        if (min(Lof_W)<0.35)&&(min(Lof_W)>0.01)
%             min(Lof_W)
                    [num,ind] = find(Lof_W<0.5);
                    Water_width = ind(end)- ind(1);
                     if(Water_width<0.1*length(x))
                            break;
                     end
        end
    end
end
%    figure;plot(x,Lof_W)
K(1)=1;K(2) =K2;K(3) =K3;
K(4) =0+unifrnd(-0.1,0.1);
Lof_W=Lofun(K,x);
%some areas have no cest effect
cest_effect=1;
if (unifrnd(0,1)>0.9)
    cest_effect=0;
    Lof = Lof_W;
end
%% apt

while cest_effect
%%%%%%%%%%%%%%%%%%%%%%%%%%cest point
%generate K2 K3
    while 1
        K2 = unifrnd(K2_min,K2_max);
        loc_row = floor((K2-K2_min)/((K2_max-K2_min)/1000))+1;
        K3 = unifrnd(K3_min,K3_max);
        loc_col = floor((K3-K3_min)/((K3_max-K3_min)/1000))+1;
        if(K2K3_mask(loc_row,loc_col)>0)
            K(1)=1;K(2) =K2;K(3) =K3;K(4) =0;
            Lof_APT=Lofun(K,x);
            if (min(Lof_APT)<0.99)&&(min(Lof_APT)>0.5)
                min_apt = min(Lof_APT);
                [num,ind] = find(Lof_APT<(1-(1-min_apt)/2));
                Cest_width = ind(end)- ind(1);
                 if(Cest_width<0.15*length(x))
                    break;
                 end
            end
        end
    end
    K_apt(1)=1;K_apt(2) =K2;K_apt(3) =K3;
    K_apt(4) =apt_ppm+unifrnd(-0.05,0.05);
    Lof_APT=Lofun(K_apt,x);
    Lof = Lof_W+Lof_APT-1;
%     figure;plot(x,Lof_W)
%  figure;plot(x,Lof_APT);ylim([0,1])
%     figure;plot(x,Lof)
    if(min(Lof)>0)
        break;
    else 
        Lof = Lof_W;
    end
end
%% noe
%some areas have no cest effect
noe_effect=0;
noe_count_init = randi([30,40],1);
noe_count=noe_count_init; %contral the num of noe 
% r =0.5 + (3.5-0.5).*rand([1 1]);%0.5---3.5
noe_ppm = linspace(-4.5,-3,noe_count);%the ppm range of noe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (unifrnd(0,1)>0.2)
    noe_effect=1;
end
%%%%%%%%%%%%%
Lof1 = Lof;
dead_contral=50;
 total_NOE=0;
while noe_effect
%%%%%%%%%%%%%%%%%%%%%%%%%%noe point
%generate K2 K3
    while 1
        K2 = unifrnd(K2_min,K2_max);
        loc_row = floor((K2-K2_min)/((K2_max-K2_min)/1000))+1;
        K3 = unifrnd(K3_min,K3_max);
        loc_col = floor((K3-K3_min)/((K3_max-K3_min)/1000))+1;
        if(K2K3_mask(loc_row,loc_col)>0)
            K(1)=1;K(2) =K2;K(3) =K3;K(4) =0;
            Lof_NOE=Lofun(K,x);
            if (min(Lof_NOE)<1)&&(min(Lof_NOE)>0.82)
                break;
            end
        end
    end
    if noe_count==0
        break;
    end
    K(1)=1;K(2) =K2;K(3) =K3;K(4) =noe_ppm(noe_count);
    Lof_NOE=Lofun(K,x);

%     figure;plot(Lof)
%     figure;plot(Lof_NOE)
% figure;plot(total_NOE)
%     figure;plot(Lof_APT)
    if(min(Lof)>0)
        noe_count = noe_count -1;
        Lof_NOE = 1-(1-Lof_NOE)/10;
        total_NOE= total_NOE+ Lof_NOE;
        Lof = Lof+Lof_NOE-1;
    else
        dead_contral = dead_contral-1;
        noe_count = noe_count_init;
        Lof = Lof1;
    end
    
    if( dead_contral ==0)
        noe_effect=0;
        Lof = Lof1;
        break;
    end
    
end
%         figure;plot(Lof)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cest_out = zeros(size(cest_image));
[row,col,slice] = size(cest_image);
samples = length(dirs);
frame_i = randi([1,samples],1); 
filename = [dirname,dirs(frame_i).name];
II1 = double(rgb2gray(imread(filename)))/255;% 
II1 = abs(imresize(II1,[row,col],'nearest'));
w = fspecial('gaussian',4,4);
II1 = imfilter(II1,w','replicate');


for loopi = 1:slice
    temp_ppm = floor(length(x)/(slice-1))*(loopi-1)+1;
    temp_cest= (new_mask.*II1*ratio+(new_mask*(1-ratio))).*Lof(temp_ppm);
    cest_out(:,:,loopi) = temp_cest+cest_image(:,:,loopi);
end


if cest_effect ==0
    APT_out = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*0+APT;
else
    temp_ppm = floor((K_apt(4)+6)/(12/length(x)));
    APT_out = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*(Lof_W(temp_ppm)-Lof(temp_ppm))+APT;
end
% figure;plot(Lof_W);
% figure;plot(Lof_APT)
% figure;plot(Lof)
% imagesc(APT_out,[0,1]);colormap jet
% pause(0.01)
% figure(5)
% for loopi  =1:25
% subplot(5,5,loopi);

% figure; imagesc(abs(cest_out(:,:,9)-cest_out(:,:,17)),[0,1]);colormap jet
% end








