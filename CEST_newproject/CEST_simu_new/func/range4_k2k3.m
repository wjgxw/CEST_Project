%get the range of K2,K3
%cest 
%input WJG_cest_sta_main.m
%2018.8.16
% created by Angus, wjtcw@hotmail.com
function K2K3_range = range4_k2k3(distribution_para,K2_min,K2_max,K3_min,K3_max)

e = imfreehand;
BW = createMask(e);
figure; imagesc(BW)
K2K3_range.BW = BW;
K2K3_range.K2_min = K2_min;
K2K3_range.K2_max = K2_max;
K2K3_range.K3_min = K3_min;
K2K3_range.K3_max = K3_max;

    
    


