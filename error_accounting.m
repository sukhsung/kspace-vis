function [MSE,kXScale,kYScale,kXShift, kYShift, k_domain] = error_accounting(eTilt,eInt,kTilt,kInt)

%adjusting params
eXScale = 1;
eYScale = 1;
eXShift = 0;
eYShift = 0;

kXScale = 1*180./pi;
kYScale = 2.068;
cos_correct = 1. ./ cos(kTilt(1,:));
kXShift = -1.9;
kYShift = 0;



e_domain = [3,9,7];

k_domain = [4,2,6];

adj_eTilt = round(eTilt.*eXScale+eXShift,1);
adj_eInt  = eInt.*eYScale + eYShift;

adj_kTilt = round(kTilt.*kXScale+kXShift,1);
adj_kInt  = kInt.*kYScale.*cos_correct + kYShift;
MSE = 0;

for i = 1:length(adj_eTilt)
    %for each spot, add square of difference to MSE
    for j = 1:3
        e_spot = e_domain(j);
        k_spot = k_domain(j);
        point_val = ( adj_eInt(e_spot,i)-adj_kInt(k_spot,adj_kTilt == adj_eTilt(1,i)) ).^2;
        %if (point_val ~= [])
        if(sum(adj_kTilt == adj_eTilt(1,i)) > 0)
            MSE = MSE + sum(point_val);
        end
        %end
    end
    %current_tilt
    %adj_kTilt(kin_index)
   
end

figure;
plot(adj_eTilt(1,:), adj_eInt(e_domain,:),'o');
hold on;
plot(adj_kTilt,adj_kInt(k_domain,:));



end
