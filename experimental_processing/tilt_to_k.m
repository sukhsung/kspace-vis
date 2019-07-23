function [kx,ky,kz, rad_per_ang_per_px] = tilt_to_k (resM, posxy, kev, tilts, tilt_angle, first_orders, lattice_param )
    if length(first_orders) ==5
        pairs = [1,4;3,5];
    elseif length(first_orders)==6
        pairs = [1,4;2,5;3,6];
    end
    peaks = 1:length(posxy);
    tilts_angles = 1:length(tilts);

    p1 = zeros(size(pairs,1), size(pairs,2), size(resM.x0,2));
    x0y0 = zeros(size(resM.x0,1),size(resM.x0,2),2);
    x0y0(:,:,1) = resM.x0;
    x0y0(:,:,2) = resM.y0;
    for pair = pairs
       for dim = [1,2]
           for tilt = tilts_angles
               p1(pair,dim,tilt) = posxy(pair,dim)+ x0y0(pair,tilt,dim);
           end
       end
    end
    
    %p1 = posxy(pairs(:,1),:) + [(resM.x0(pairs(:,1),:)), (resM.y0(pairs(:,1),:))];
    %p2 = posxy(pairs(:,2),:) + [(resM.x0(pairs(:,2),:)), (resM.y0(pairs(:,2),:))];
    %b1 = mean(1/2*(p1-p2));
    
    center_pos = squeeze(mean(p1(pairs(:,2),:,:) + 1/2*(p1(pairs(:,1),:,:)-p1(pairs(:,2),:,:)),1));
    
    %center_pos = ones(2,length(tilts)).*center_pos(:,1);
    %center_pos = mean(p2 + 1/2*( p1-p2 ));
    
    
    
    rad_per_ang_per_px = 2*pi/lattice_param / sqrt((posxy(1,1)-center_pos(1,1,1)).^2 + (posxy(1,2)-center_pos(1,2,1)).^2);
    wav = 12.3986./sqrt((2*511.0+kev).*kev);
    k = 2*pi / wav ;
    kz = zeros(size(resM.a));
    
    
    phi = tilts;
    theta = tilt_angle;
    qzo = k*cosd(phi);
    qxo = k*sind(phi)*cosd(theta);
    qyo = k*sind(phi)*sind(theta);

    for peak = peaks
        %for tilt = 1:length(tilts)
            kx(peak,:) = rad_per_ang_per_px*(posxy(peak,1) - center_pos(1,:)) + rad_per_ang_per_px* resM.x0(peak,:) ;
            ky(peak,:) = rad_per_ang_per_px*(posxy(peak,2) - center_pos(2,:)) + rad_per_ang_per_px* resM.y0(peak,:) ;

            kz(peak,:) = qzo' - sqrt(k^2 - (kx(peak,:)-qxo').^2 - (ky(peak,:)-qyo').^2);
        %end
    end
    figure;
    scatter3(kx(:),ky(:),kz(:),'r.');
    hold on;
    domain = -5:.1:5;
    
    plot3(cosd(90+tilt_angle)*domain,sind(90+tilt_angle)*domain,zeros(length(domain)));
    
    for peak = peaks
        text(kx(peak,1),ky(peak,1),kz(peak,1), num2str(peak),'FontSize',14);
    end
    title(num2str(tilt_angle));
    xlabel('k_x');
    ylabel('k_y');
    zlabel('k_z');
    

end
