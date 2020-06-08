function WJG_show_cest(cest_image,with_label)
%show cest image 
%different frequency point
% created by WJ angus
%  wjtcw@hotmail.com
%2018.8.20
%%%%%%%%%%%%%%%%%%%%%%
%%angus 2019.1.22
%add with_label 
%%%%%%%%%%%%%%%%%%%%%
[row,col,slice] = size(cest_image);
if with_label
    figure(12345);
    ha1 = tight_subplot(floor(sqrt(slice))+1,floor(sqrt(slice))+1,[0 0],[0 0],[0 0]) ;
    for loopi = 1:1
        imagesc(abs(squeeze(cest_image(:,:,loopi)))),colormap jet
    end
        imagesc(abs(squeeze(cest_image(26,:,:)))),colormap jet;axis off
     [point_x,point_y,button] = ginput(1);
    while(button==1)
        figure;
        plot(squeeze(cest_image(floor(point_y),floor(point_x),1:slice-1)))
        figure(12345);
        [point_x,point_y,button] = ginput(1);
    end
else
    figure(12345);
    ha1 = tight_subplot(floor(sqrt(slice)+1),floor(sqrt(slice)+1),[0 0],[0 0],[0 0]) ;
    for loopi = slice:-1:1
        axes(ha1(loopi));
%         subplot(5,5,loopi)
        imagesc(abs(squeeze(cest_image(:,:,loopi))),[0,1]),colormap jet;axis off
    end
    [point_x,point_y,button] = ginput(1);
    while(button==1)
        figure;
        plot(squeeze(cest_image(floor(point_y),floor(point_x),1:slice-2)))
        figure(12345);
        [point_x,point_y,button] = ginput(1);
    end 
    
    
end
    

