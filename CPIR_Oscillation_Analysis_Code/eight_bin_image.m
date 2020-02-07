function Binned_Image = eight_bin_image(Input_Image,Mask,Healthy_Mean,Healthy_STD)

 Binned_Image = zeros(size(Input_Image));
for ii = 1:size(Input_Image,3)
    for jj = 1:size(Input_Image,2)
        for kk = 1:size(Input_Image,1)
            if Mask(kk,jj,ii) == 0
                Binned_Image(kk,jj,ii) = 0; %0 - black
            elseif Input_Image(kk,jj,ii) <= Healthy_Mean - 2 * Healthy_STD
                Binned_Image(kk,jj,ii) = 1; %1 - red
            elseif Input_Image(kk,jj,ii) <= Healthy_Mean - 1 * Healthy_STD
                Binned_Image(kk,jj,ii) = 2; %2 - orange
            elseif Input_Image(kk,jj,ii) <= Healthy_Mean 
                Binned_Image(kk,jj,ii) = 3; %3 - green 1
            elseif Input_Image(kk,jj,ii) <= Healthy_Mean + 1 * Healthy_STD
                Binned_Image(kk,jj,ii) = 4; %4 - green 2
            elseif Input_Image(kk,jj,ii) <= Healthy_Mean + 2 * Healthy_STD
                Binned_Image(kk,jj,ii) = 5; %5 - blue 1
            elseif Input_Image(kk,jj,ii) <= Healthy_Mean + 3 * Healthy_STD
                Binned_Image(kk,jj,ii) = 6; %5 - blue 1
            elseif Input_Image(kk,jj,ii) <= Healthy_Mean + 4 * Healthy_STD
                Binned_Image(kk,jj,ii) = 7; %5 - blue 1
            elseif Input_Image(kk,jj,ii) > Healthy_Mean + 4 * Healthy_STD
                Binned_Image(kk,jj,ii) = 8; %6 - blue 2
            end
        end
    end
end