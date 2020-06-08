for i=1:26
    subplot(5,6,i)
    imagesc(cest_image_out(:,:,i));colormap jet;
end
Z=zeros(1,25);
for j=1:25
    Z=cest_image_out(58,37,:);
    Z=squeeze(Z(1:25));
end
figure;
plot(Z);