function WJG_show_cest(cest_image)
%show cest image 
%different frequency point
% created by WJ angus
%  wjtcw@hotmail.com
%2018.8.20
[row,col,slice] = size(cest_image);

figure(12345);
for loopi = 1:slice-1
    subplot(floor(sqrt(slice)),floor(sqrt(slice))+1,loopi)
    imagesc(abs(cest_image(:,:,loopi))),colormap jet
end
    subplot(floor(sqrt(slice)),floor(sqrt(slice))+1,26)
    imagesc(abs(cest_image(:,:,26))),colormap jet
 [point_x,point_y,button] = ginput(1);
while(button==1)
    figure;
    plot(squeeze(cest_image(floor(point_y),floor(point_x),1:slice-1)))
    figure(12345);
    [point_x,point_y,button] = ginput(1);
end

% [slice,row,col] = size(cest_image);
% figure(12345);
% for loopi = 1:slice-1
%     subplot(floor(sqrt(slice)),floor(sqrt(slice))+1,loopi)
%     imagesc(squeeze(cest_image(loopi,:,:)),[0,1]),colormap jet
% end
% %     subplot(floor(sqrt(slice)),floor(sqrt(slice))+1,26)
% %     imagesc(cest_image(:,:,26),[0,0.2]),colormap jet
%  [point_x,point_y,button] = ginput(1);
% while(button==1)
%     figure;
%     plot(squeeze(cest_image(1:slice-1,floor(point_y),floor(point_x))))
%     figure(12345);
%     [point_x,point_y,button] = ginput(1);
% end