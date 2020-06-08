close all
clc
clear 
K2_min =0;
K2_max =7;
K3_min =-10;%-5~+5
K3_max =1;%-5~+5
cest = zeros(1001,1001);
imagesc(cest);colormap jet;hold on
for K2 = 1:0.2:1000
    for K3 = 1:0.2:600
        K2 = unifrnd(K2_min,K2_max);
        loc_row = floor((K2-K2_min)/((K2_max-K2_min)/1000))+1;
        K3 = unifrnd(K3_min,K3_max);
        loc_col = floor((K3-K3_min)/((K3_max-K3_min)/1000))+1;
        x = -6:0.5:6;
        K(1)=1;K(2) =K2;K(3) =K3;K(4) =0;
        Lof=Lofun(K,x);
        if (min(Lof)<0.1)&&(min(Lof)>0)
            plot(loc_col,loc_row,'r.')
            break;
        elseif (min(Lof)<0.3)&&(min(Lof)>0)
            plot(loc_col,loc_row,'y.')
            break;
        elseif (min(Lof)<0.7)&&(min(Lof)>0)
            plot(loc_col,loc_row,'b.')
            break;
        elseif (min(Lof)<0.9)&&(min(Lof)>0)
            plot(loc_col,loc_row,'c.')
            break;
        end
    end
end
xlabel('K3')
ylabel('K2')
loc_col = 773;
loc_row = 171;
K3 = (loc_col-1)*(K3_max-K3_min)/1000+K3_min;
K2 = (loc_row-1)*(K2_max-K2_min)/1000+K2_min;
        x = -6:0.5:6;
        K(1)=1;K(4) =0;
        Lof=Lofun(K,x);
        figure;
        plot(Lof)