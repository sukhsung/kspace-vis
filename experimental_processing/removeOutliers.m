function [outlier] = removeOutliers( resM, Tposx, Tposy, Tsigmax, Tsigmay );
%Find Outliers and remove them
%Tolerance is the number of standard deviations that is permitted
    
    outlier = zeros(size(resM.a));

    %Remove outliers based on position
    for i = 1:size(resM.a,1)
        for j = 1:size(resM.a,2)
            if     ( resM.x0(i,j) > mean(resM.x0(i,:))+Tposx*std(resM.x0(i,:)) ) || ( resM.x0(i,j) < mean(resM.x0(i,:))-Tposx*std(resM.x0(i,:)) )
                outlier(i,j) = 1;
            elseif ( resM.x0(i,j) > mean(resM.y0(i,:))+Tposy*std(resM.y0(i,:)) ) || ( resM.y0(i,j) < mean(resM.y0(i,:))-Tposy*std(resM.y0(i,:)) )
                outlier(i,j) = 2;
            elseif ( resM.sigmax(i,j) > mean(resM.sigmax(i,:))+Tsigmax*std(resM.sigmax(i,:)) ) || ( resM.sigmax(i,j) < mean(resM.sigmax(i,:))-Tsigmax*std(resM.sigmax(i,:)) )
                outlier(i,j) = 3;
            elseif resM.sigmay(i,j) > mean(resM.sigmay(i,:))+Tsigmay*std(resM.sigmay(i,:)) || resM.sigmay(i,j) < mean(resM.sigmay(i,:))-Tsigmay*std(resM.sigmay(i,:))
                outlier(i,j) = 4;
            end
        end
    end

end