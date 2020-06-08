function [cest_image_out,new_mask,cest_effect_out] =  WJGshape_cest(cest_effect,cest_image,ppm_start,ppm_end,ppm_step,dB0,mask,dirname,dirs,row,col,type,ratio)
%generate the random shapes, and add texture in the shapes
%cest_effect: amide amine ...
%cest_image: 
%dB0 B0
%mask: the generateed random shape mask
%dir: the directory of the images, which used for generating random textures
%2019.3.3
% created by Angus, wjtcw@hotmail.com
%add B0  2019.6.20
%add texture in amide and amine (lian xudong)  2019.6.20
radius_limit = row;
mini_size = 3;% the minimum size
cest_image_out = cest_image;
cest_effect_out = cest_effect;
switch type 
    case 1    
        %circle
        mask1 = zeros(row,col);
        RADIUS = randi([mini_size,round(radius_limit/6)],1); 
        center = randi([5,row-5],1,2); 
        temp_mask = WJGgenCircle(row,RADIUS,center);
        if(sum(temp_mask(:))>20)    %prevent the small shape
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask);%prevent the overlap between the masks
        [cest_image_out,cest_effect_out] = Add_tex(cest_effect,cest_image,ppm_start,ppm_end,ppm_step,dB0,dirname,dirs,new_mask,ratio);  
        new_mask = abs(new_mask+mask)>0;  

    case 2
        %ring
        mask1 = zeros(row,col);
        RADIUS1 = randi([mini_size,round(radius_limit/4)],1);
        RADIUS2 = randi([mini_size,round(radius_limit/16)],1);
        center = randi([-5,5],1,2); 
        temp_mask = WJGgenRing( row,max(RADIUS1,RADIUS2),min(RADIUS1,RADIUS2),center );
        if(sum(temp_mask(:))>20)    
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask); 
        [cest_image_out,cest_effect_out] = Add_tex(cest_effect,cest_image,ppm_start,ppm_end,ppm_step,dB0,dirname,dirs,new_mask,ratio);  

        new_mask = abs(new_mask+mask)>0; 
    case 3
        %square
        mask1 = zeros(row,col);
        shape = randi([mini_size,round(radius_limit/2)],2,2);  
        center = randi([5,row-row/8],2,1); 
        center = [center,center];
        shape = shape+center;
        x = min([sort(shape(1,:));row,row]);   
        y = min([sort(shape(2,:));col,col]);
        vx = [x(1),x(1),x(2),x(2),x(1)];
        vy = [y(1),y(2),y(2),y(1),y(1)];
        temp_mask = WJG_convex_S(row,vx,vy);
        if(sum(temp_mask(:))>20)   
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask); 
        [cest_image_out,cest_effect_out] = Add_tex(cest_effect,cest_image,ppm_start,ppm_end,ppm_step,dB0,dirname,dirs,new_mask,ratio); 
        new_mask = abs(new_mask+mask)>0;
    case 4 
        %triangle
        mask1 = zeros(row,col);
        shape = randi([mini_size,round(radius_limit/2)],2,3);
        center = randi([5,row--row/8],2,1); 
        center = [center,center,center];
        shape = shape+center;
        x = min([sort(shape(1,:));row,row,row]);
        y = min([sort(shape(2,:));col,col,col]);
        vx = [x(1),x(2),x(3),x(1)];
        vy = [y(1),y(2),y(3),y(1)];
        temp_mask = WJG_convex_S(row,vx,vy);
        if(sum(temp_mask(:))>20)     
            mask1 = mask1+temp_mask;
        end
        new_mask = mask1.*abs(mask1-mask); 
        [cest_image_out,cest_effect_out] = Add_tex(cest_effect,cest_image,ppm_start,ppm_end,ppm_step,dB0,dirname,dirs,new_mask,ratio);  
        new_mask = abs(new_mask+mask)>0;
end
      
function [cest_image_out,cest_effect_out] =  Add_tex(cest_effect,cest_image,ppm_start,ppm_end,ppm_step,dB0,dirname,dirs,new_mask,ratio)
    B_water = rand()>0.05;
    B_amide = rand()>0.5;
    B_amine = rand()>0.5;
    B_noe = rand()>0.5;
    B_other = 0;    %rand()>0.95;
    B_mt = 1;       %there is no mt when traditional fitting
    omega_m0 = [ppm_start:ppm_step:ppm_end,100]; %ppm  100 ppm as M0
    omega = ppm_start:ppm_step:ppm_end;
    [row,col,slice] = size(cest_image);
    samples = length(dirs);
    filter_kernel = fspecial('gaussian',4,4);
    decay = rand()*0.4+0.6;   
    
    %% water
    while(1)
        if (B_water)
            Lof_water = zeros(row,col,slice);
            frame_i = randi([1,samples],1); 
            filename = [dirname,dirs(frame_i).name];
            II1 = double(rgb2gray(imread(filename)))/255;% 
            II1 = abs(imresize(II1,[row,col],'nearest'));
            II1 = imfilter(II1,filter_kernel','replicate');
            while(1)
                amplitude_water = rand()*0.2+0.8;
                amplitude_water = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*amplitude_water;
                omega_0_water = dB0.*new_mask;
                fwhm_water = (rand()*1+0.3).*new_mask;
                par0 ={amplitude_water, omega_0_water,fwhm_water,new_mask}; %initial guess                               
                for loopi = 1:slice
                    Lof_water(:,:,loopi) = WJG_Lorentz(par0,omega_m0(loopi));
                end
                if min(Lof_water(:))>=0
                    break;
                end
            end
            %% amide
            if(B_amide)
                Lof_amide = zeros(row,col,slice);
                frame_i = randi([1,samples],1); 
                filename = [dirname,dirs(frame_i).name];
                II1 = double(rgb2gray(imread(filename)))/255;% 
                II1 = abs(imresize(II1,[row,col],'nearest'));
                II1 = imfilter(II1,filter_kernel','replicate');

                amplitude_amide = rand()*max(amplitude_water(:))/2;
                amplitude_amide = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*amplitude_amide;
                omega_0_amide = (3.5+dB0).*new_mask;
                fwhm_amide = (rand()*2+0.3).*new_mask;
                par0 ={amplitude_amide, omega_0_amide,fwhm_amide,new_mask}; 
                for loopi = 1:slice
                        Lof_amide(:,:,loopi) = WJG_Lorentz(par0,omega_m0(loopi));
                end
            else
                Lof_amide = zeros(row,col,slice);
                amplitude_amide = zeros(row,col);
                omega_0_amide = 3.5;
            end
            %% amine
            if(B_amine)
                Lof_amine = zeros(row,col,slice);
                frame_i = randi([1,samples],1); 
                filename = [dirname,dirs(frame_i).name];
                II1 = double(rgb2gray(imread(filename)))/255;% 
                II1 = abs(imresize(II1,[row,col],'nearest'));
                II1 = imfilter(II1,filter_kernel','replicate');

                amplitude_amine = rand()*max(amplitude_water(:))/2;
                amplitude_amine = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*amplitude_amine;
                omega_0_amine = (2+dB0).*new_mask;
                fwhm_amine = (rand()*2+0.3).*new_mask;
                par0 ={amplitude_amine, omega_0_amine,fwhm_amine,new_mask}; 
                for loopi = 1:slice
                        Lof_amine(:,:,loopi) = WJG_Lorentz(par0,omega_m0(loopi));
                end
            else
                Lof_amine = zeros(row,col,slice);
                amplitude_amine = zeros(row,col);
                omega_0_amine = 2;
            end
        %% noe
            if(B_noe)
                Lof_noe = zeros(row,col,slice);
                frame_i = randi([1,samples],1); 
                filename = [dirname,dirs(frame_i).name];
                II1 = double(rgb2gray(imread(filename)))/255;% 
                II1 = abs(imresize(II1,[row,col],'nearest'));
                II1 = imfilter(II1,filter_kernel','replicate');

                amplitude_noe = rand()*max(amplitude_water(:))/2;
                amplitude_noe = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*amplitude_noe;
                omega_0_noe = (-3+dB0).*new_mask;
                fwhm_noe = (rand()*3+1).*new_mask;
                par0 ={amplitude_noe, omega_0_noe,fwhm_noe,new_mask}; 
                for loopi = 1:slice
                        Lof_noe(:,:,loopi) = WJG_Lorentz(par0,omega_m0(loopi));
                end
            else
               Lof_noe = zeros(row,col,slice);
            end
        %% mt
            if(B_mt)
                Lof_mt = zeros(row,col,slice);
                frame_i = randi([1,samples],1); 
                filename = [dirname,dirs(frame_i).name];
                II1 = double(rgb2gray(imread(filename)))/255;% 
                II1 = abs(imresize(II1,[row,col],'nearest'));
                II1 = imfilter(II1,filter_kernel','replicate');                
                
                amplitude_mt =  rand()*max(amplitude_water(:))/4;
                amplitude_mt = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*amplitude_mt;
                omega_0_mt = (0+dB0).*new_mask;
                fwhm_mt = normrnd(100,50).*new_mask;
                par0 ={amplitude_mt, omega_0_mt,fwhm_mt,new_mask}; 
                for loopi = 1:slice
                    Lof_mt(:,:,loopi) = WJG_Lorentz(par0,omega_m0(loopi));
                end
            else
                Lof_mt = zeros(row,col,slice);
            end 
            %% other
            if(B_other)
                amplitude = rand()*0.1;
                omega_0 = (rand()*2-1+dB0).*new_mask;
                fwhm = rand().*new_mask;
                par0 =[amplitude, omega_0,fwhm,1]; %initial guess
                Lof_other = WJG_Lorentz(par0,omega_m0);
            else
                Lof_other = zeros(row,col,slice);
            end 
        else
            Lof_water = zeros(row,col,slice);
            Lof_amide = zeros(row,col,slice);
            Lof_amine = zeros(row,col,slice);
            Lof_noe = zeros(row,col,slice);
            Lof_mt = zeros(row,col,slice);
            Lof_other = zeros(row,col,slice);
            omega_0_amide = (3.5+dB0).*new_mask;
            omega_0_amine=(2+dB0).*new_mask;
            amplitude_amide = zeros(row,col);
            amplitude_amine = zeros(row,col);
        end
        Lof_m0 = Lof_water+Lof_amide+Lof_amine+Lof_noe+Lof_mt+Lof_other-(B_amide+B_amine+B_noe+B_mt+B_other)*B_water.*new_mask;
        if (min(Lof_m0(:))>=0)&&(max(Lof_m0(:))<1)||~B_water
            break
        end
    end
Lof = Lof_m0(:,:,1:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cest_image_out = cest_image;
samples = length(dirs);
frame_i = randi([1,samples],1); 
filename = [dirname,dirs(frame_i).name];
II1 = double(rgb2gray(imread(filename)))/255;% 
II1 = abs(imresize(II1,[row,col],'nearest'));
II1 = imfilter(II1,filter_kernel','replicate');
for loopi = 1:slice
    select_ppm = floor(length(omega)/(slice-1))*(loopi-1)+1;
    temp_cest= (new_mask.*II1*ratio+(new_mask*(1-ratio))).*Lof(:,:,select_ppm)*decay;
    cest_image_out(:,:,loopi) = temp_cest+cest_image(:,:,loopi);
end

cest_effect_out(:,:,1) = amplitude_amide*decay./(max(cest_image_out(:,:,:),[],3)+eps)+cest_effect(:,:,1);
cest_effect_out(:,:,2) = amplitude_amine*decay./(max(cest_image_out(:,:,:),[],3)+eps)+cest_effect(:,:,2);

% amine_value  = max(Lof_amine)-min(Lof_amine);
% amine_value = 1/max(Lof)*amine_value;
% cest_effect_out(:,:,2) = (new_mask.*II1*ratio+(new_mask*(1-ratio))).*(amine_value)+cest_effect(:,:,2);







