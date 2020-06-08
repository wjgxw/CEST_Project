function [cest_image_out,new_mask,APT_out] =  WJGshape_cest(APT,K2K3_range,cest_image,mask,dirname,dirs,row,col,type,ratio,apt_ppm,noe_ppm)
%产生随机图形，并在图形内添加纹理
%在已经生成的模板的基础上继续添加几何模板
%mask为几何模板
%dir为随机纹理的光学图像路径

radius_limit = row;
mini_size = 3;%最小尺寸
cest_image_out = cest_image;
APT_out = APT;
switch type 
    case 1    
        %生成圆
        mask1 = zeros(row,col);
        RADIUS = randi([mini_size,round(radius_limit/6)],1); 
        center = randi([5,row-5],1,2); 
        temp_mask = WJGgenCircle(row,RADIUS,center);
        if(sum(temp_mask(:))>5)    %防止出现面积过小的图形
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask);%防止模板间重叠
         [cest_image_out,APT_out] = Add_tex(APT,cest_image,dirname,dirs,new_mask,K2K3_range,ratio,apt_ppm,noe_ppm);  
        new_mask = abs(new_mask+mask)>0;  

    case 2
        %生成环
        mask1 = zeros(row,col);
        RADIUS1 = randi([mini_size,round(radius_limit/4)],1);
        RADIUS2 = randi([mini_size,round(radius_limit/16)],1);
        center = randi([-5,5],1,2); 
        temp_mask = WJGgenRing( row,max(RADIUS1,RADIUS2),min(RADIUS1,RADIUS2),center );
        if(sum(temp_mask(:))>5)    %防止出现面积过小的图形
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask);%防止模板间重叠
         [cest_image_out,APT_out] = Add_tex(APT,cest_image,dirname,dirs,new_mask,K2K3_range,ratio,apt_ppm,noe_ppm);  

        new_mask = abs(new_mask+mask)>0; 
    case 3
        %生成正方形
        mask1 = zeros(row,col);
        shape = randi([1,round(radius_limit/2)],2,2);  %大小
        center = randi([5,row-row/8],2,1); 
        center = [center,center];
        shape = shape+center;
        x = min([sort(shape(1,:));row,row]);    %控制范围
        y = min([sort(shape(2,:));col,col]);
        vx = [x(1),x(1),x(2),x(2),x(1)];
        vy = [y(1),y(2),y(2),y(1),y(1)];
        temp_mask = WJG_convex_S(row,vx,vy);
        if(sum(temp_mask(:))>5)    %防止出现面积过小的图形
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask);%防止模板间重叠
         [cest_image_out,APT_out] = Add_tex(APT,cest_image,dirname,dirs,new_mask,K2K3_range,ratio,apt_ppm,noe_ppm); 
        new_mask = abs(new_mask+mask)>0;
    case 4 
%生成三角形
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
        if(sum(temp_mask(:))>5)    %防止出现面积过小的图形
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask);%防止模板间重叠
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

%         if (min(Lof_W)<0.5)&&(min(Lof_W)>0.35)
             if (min(Lof_W)<0.1)&&(min(Lof_W)>0.01)

%                         break
                    [num,ind] = find(Lof_W<0.5);
                    Water_width = ind(end)- ind(1);
%                      if(0.14*length(x)<Water_width&&Water_width<0.15*length(x))     %cest
                     if(Water_width<0.15*length(x)) 
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
if (unifrnd(0,1)>0)
    cest_effect=0;
    Lof = Lof_W;
end
%% apt

while cest_effect
%%%%%%%%%%%%%%%%%%%%%%%%%%cest point
cest_init = randint(1,1,[50,60]);
dead_line=50;
total_cest=1;
cest_count=cest_init;
cest_ppm = linspace(2,3.5,cest_count);
%generate K2 K3
    while 1
        K2 = unifrnd(K2_min,K2_max);
        loc_row = floor((K2-K2_min)/((K2_max-K2_min)/1000))+1;
        K3 = unifrnd(K3_min,K3_max);
        loc_col = floor((K3-K3_min)/((K3_max-K3_min)/1000))+1;
        if(K2K3_mask(loc_row,loc_col)>0)
            K(1)=1;K(2) =K2;K(3) =K3;K(4) =0;
            Lof_APT=Lofun(K,x);
            if (min(Lof_APT)<0.99)&&(min(Lof_APT)>0.9)
                min_apt = min(Lof_APT);
                [num,ind] = find(Lof_APT<(1-(1-min_apt)/2));
                Cest_width = ind(end)- ind(1);
                 if(Cest_width<0.1*length(x))
                    break;
                 end
            end
        end
    end
    K_apt(1)=1;K_apt(2) =K2;K_apt(3) =K3;
%     K_apt(4) =apt_ppm+unifrnd(-0.05,0.05);     
%      K_apt(4) =cest_ppm(cest_count);
%     Lof_APT=Lofun(K_apt,x);
    for loopi=1:cest_count  
        K_apt(4) =cest_ppm(loopi);
        Lof_APT=Lofun(K_apt,x);
         Lof_APT = 1-(1-Lof_APT)/11;
        total_cest=total_cest+Lof_APT-1;    
%         Lof_cest = Lof_W+Lof_APT-1;
%         Lof=Lof+Lof_cest;        
    end
           Lof = Lof_W+total_cest-1;
           K_apt(4) =apt_ppm+unifrnd(-0.01,0.01);
%     Lof = Lof_W+Lof_APT-1;
    %鸡蛋第二个cest峰
%     apt2_ppm=2;
%     K_apt(1)=1;K_apt(2) =K2;K_apt(3) =K3;
%     K_apt(4) =apt2_ppm+unifrnd(-0.05,0.05); 
%     Lof_APT2=Lofun(K_apt,x);
%     Lof = Lof+Lof_APT2-1;
%     figure;plot(x,total_cest)
%  figure;plot(x,Lof_APT);ylim([0,1])
%     figure;plot(x,Lof)
%  figure;plot(x,Lof_cest)
    if(min(Lof)>0)
        break;
    else 
        dead_line=dead_line-1;
        cest_count=cest_init;
    end
    if( dead_line ==0)    
         Lof = Lof_W;
         cest_effect =0;
        break;
    end
   
end
%% noe
%some areas have no cest effect
noe_effect=0;
noe_count_init = randint(1,1,[50,60]);
noe_count=noe_count_init; %contral the num of noe 
% r =0.5 + (3.5-0.5).*rand([1 1]);%0.5---3.5
noe_ppm = linspace(-6,-2,noe_count);%the ppm range of noe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (unifrnd(0,1)>0.1)
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
            if (min(Lof_NOE)<1)&&(min(Lof_NOE)>0.9)
                break;
%                 min_noe= min(Lof_NOE);
%                 [num,ind] = find(Lof_NOE<(1-(1-min_noe)/2));
%                 Cest_width = ind(end)- ind(1);
%                  if(Cest_width<0.1*length(x))
%                     break;
%                  end
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

        noe_count = noe_count -1;
        Lof_NOE = 1-(1-Lof_NOE);
        total_NOE= total_NOE+ Lof_NOE;
%         Lof = Lof+Lof_NOE-1;
    
end
if  noe_effect
    noe_amp_range =unifrnd(1,10);
    total_NOE1  =  ((total_NOE)/(noe_count_init)-1)*noe_amp_range;
    Lof = Lof+total_NOE1;
end
%   figure;plot(Lof)
%         figure;plot((total_NOE1))
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


% if cest_effect ==0
%     APT_out = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*0+APT;
% else
% %     temp_ppm = floor((K_apt(4)+6)/(12/length(x)));%APT        
% %    cest= Lof_W-Lof;%APT 
% %     APT_out = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*(mean(cest(temp_ppm-3:temp_ppm+3)))+APT;
% end
if noe_effect ==0
    APT_out = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*0+APT;
else
%     temp_ppm = floor((K_apt(4)+6)/(12/length(x)));%APT        
%    cest= Lof_W-Lof;%APT 
%     APT_out = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*(mean(cest(temp_ppm-3:temp_ppm+3)))+APT;
%%%%%%%%%%noe
    temp_ppm =   floor((-3.5+6)/(12/length(x)));%NOE
   noe= Lof_W-Lof;  
   APT_out = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*(mean(noe(temp_ppm-3:temp_ppm+3)))+APT;
end
%  figure;plot(Lof)
% figure;plot(Lof_W-Lof);
% figure;plot(200*(x+6),1-Lof_APT)
% figure;plot(cest)
% imagesc(APT_out,[0,1]);colormap jet
% pause(0.01)
% figure(5)
% for loopi  =1:25
% subplot(5,5,loopi);

% figure; imagesc(abs(cest_out(:,:,9)-cest_out(:,:,17)),[0,1]);colormap jet
% end








