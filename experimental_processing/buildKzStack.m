function [splined, kz_stack] = buildKzStack (resM, kx, ky, kz, out_file_name, kz_spacing, mesh_size, mesh_spacing, rad_per_ang_per_px )

    
    peaks = 1:size(kx,1);

    %title(num2str(phi));
    %for peak = peaks
    %    kx = rad_per_ang_per_px*(posxy(:,1) - center_pos(1)) + rad_per_ang_per_px* resM.x0(peak,:) ;
    %    ky = rad_per_ang_per_px*(posxy(:,2) - center_pos(2)) + rad_per_ang_per_px* resM.y0(peak,:) ;
    %    
    %    kz(peak,:) = qzo' - sqrt(k^2 - (kx(peak,:)-qxo').^2 - (ky(peak,:)-qyo').^2);
    %end
    %outlier = removeOutliers(resM, 4,4,4,4);

    %int = abs(resM.a.*(outlier==0) .* resM.sigmax.*(outlier==0) .* resM.sigmay.*(outlier==0));
    %intnorm = int - min(int(:));
    %intnorm = intnorm ./ max(intnorm(:));

    global_kzmin = min(kz(:));
    global_kzmax = max(kz(:));
    kz_grid = [global_kzmin:kz_spacing:global_kzmax];
    splined.a = zeros(length(peaks),length(kz_grid));
    splined.b = zeros(length(peaks),length(kz_grid));
    splined.sigmax = zeros(length(peaks),length(kz_grid));
    splined.sigmay = zeros(length(peaks),length(kz_grid));
    splined.x0 = zeros(length(peaks),length(kz_grid));
    splined.y0 = zeros(length(peaks),length(kz_grid));
    splined.sum = zeros(length(peaks),length(kz_grid));
    
    splined.kx = zeros(length(peaks),length(kz_grid));
    splined.ky = zeros(length(peaks),length(kz_grid));
    splined.kz = zeros(length(peaks),length(kz_grid));

    for peak = peaks
        kzmax = max(kz(peak,:));
        kzmin = min(kz(peak,:));
        %splined.intensity(peak,:) = spline(kz(peak,:),intnorm(peak,:),kz_grid);
        %splined.intensity( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
       
        splined.a(peak,:) = spline(kz(peak,:), resM.a(peak,:), kz_grid);
        splined.b(peak,:) = spline(kz(peak,:), resM.b(peak,:), kz_grid);
        splined.sigmax(peak,:) = spline(kz(peak,:), resM.sigmax(peak,:), kz_grid);
        splined.sigmay(peak,:) = spline(kz(peak,:), resM.sigmay(peak,:), kz_grid);
        splined.x0(peak,:) = spline(kz(peak,:), resM.x0(peak,:), kz_grid);
        splined.y0(peak,:) = spline(kz(peak,:), resM.y0(peak,:), kz_grid);
        splined.sum(peak,:) = spline(kz(peak,:), resM.sum(peak,:), kz_grid);
        
        splined.kx(peak,:) = spline(kz(peak,:), kx(peak,:), kz_grid);
        splined.ky(peak,:) = spline(kz(peak,:), ky(peak,:), kz_grid);

        splined.a( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        splined.b( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        splined.sigmax( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        splined.sigmay( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        splined.x0( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        splined.y0( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        splined.sum( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        
        splined.kx( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        splined.ky( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        
        
        splined.kz(peak,:) = kz_grid;
    end
    outlier = removeOutliers(splined, 100,100,100,100);

    int = abs(splined.a.*(outlier==0) .* splined.sigmax.*(outlier==0) .* splined.sigmay.*(outlier==0));
    intnorm = int - min(int(:));
    intnorm = intnorm ./ max(intnorm(:));
    splined.intnorm = intnorm;
    %figure;
    %plot(kz_grid,intnorm(:,:));
    
    
    %-> Tiff stack
    [mesh_x, mesh_y] = meshgrid(-mesh_size:mesh_spacing:mesh_size,-mesh_size:mesh_spacing:mesh_size);
    kz_stack = zeros(size(mesh_x,1), size(mesh_x,2), length(kz_grid));
    
    for level = 1:length(kz_grid)
        level
        for peak = peaks
            x = [splined.a(peak,level), splined.b(peak,level)];
            sx = rad_per_ang_per_px*splined.sigmax(peak,level);
            sy = rad_per_ang_per_px*splined.sigmay(peak,level);
            xi = mesh_x;%posxy(peak,1);
            yi = mesh_y;%posxy(peak,2);
            %x0 = rad_per_ang_per_px*splined.x0(peak,level)+kx(peak);
            %y0 = rad_per_ang_per_px*splined.y0(peak,level)+ky(peak);
            x0 = splined.kx(peak,level);
            y0 = splined.ky(peak,level);
            quant = x(1).*exp(- ( ((xi-x0)/sx).^2 + ((yi-y0)/sy).^2)/2);
         %   quant =  x(1)./(1+((xi-x0)/sx).^2+((yi-y0)/sy).^2);
            if ~isnan(quant)
                kz_stack(:,:,level) = kz_stack(:,:,level)+ quant;
            end
            
        end
        
    end
    writeToTiffStack(kz_stack,out_file_name);
    img2d = squeeze(sum(kz_stack,2)); figure; imagesc(img2d); colormap gray;
    %figure;
    %colormap gray;
    %imagesc(img);

end
