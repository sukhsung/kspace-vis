

%[stack, tilts, res, resM, d_im, f_im, posxy] = load_20180402_Graphene_DiffTilt();
%plotting_20180402_Graphene_DiffTilt(resM_gr20180402, tilts_gr20180402);
%plotting_20180402_Graphene_DiffTilt(avg_results, tilts);
%writeToTiffStack(stack);
%surface_roughness(resM, tilts, posxy);
%[tilts,avg_results , posxy] = load_each_20180402_Graphene_DiffTilt();
%m = BLG('ABABAB');
%m.setRotation(50*pi/180);
%function [kz] = convertTokz_exact_peaks(posxy)
%[stack_gr20180402, tilts_gr20180402, res_gr20180402, resM_gr20180402, d_im_gr20180402, f_im_gr20180402, posxy_gr20180402] = load_20180402_Graphene_DiffTilt();
%[splined, kz_stack] = buildKzStack (resM_gr20180402, posxy_gr20180402, 200, tilts_gr20180402, 'out_5.tif',120,[1:6],2.47, .01,10,.01);


%%
load('mat_20180402_Graphene_DiffTilt.mat')
%% tilt
m = BLG('ABABAB');
m.setkeV(200);
m.setSpotcut(1);
m.setKillZero(1);
m.setIntensityFactor(1);
m.setTiltStart(-15*pi/180);
m.setTiltEnd(15*pi/180);
m.setRotation(-47*pi/180);
[tiltrange, I] = m.getTiltSeries('ewald','angle',0);

peak_range= [2:4];
tilt_range= 1:57;
normalize= 1;
new_fig= 0;
stretchs = [.9 .9];%[.9 .4];
translations= [-2 0];%[-2,0];
a = gca;
c_blue = [0 114 189]/255;
c_cyan = [110 190 195]/255;
c_purple = [134 91 165]/255;
colors = [c_cyan;c_blue ; c_purple];
outliers = zeros(size(res_gr20180402));
plot_experimental(resM_gr20180402, tilts_gr20180402,peak_range , tilt_range,normalize,new_fig,stretchs,translations, outliers,colors );

lines = a.Children;
keep = [1:3,7:9];
throw = setdiff(1:length(lines),keep);
delete(lines(throw));
%lines(keep(4)).Color = c_cyan;
%lines(keep(5)).Color = c_purple;
%lines(keep(6)).Color = c_blue;
lines(1).MarkerSize = 8;
lines(2).MarkerSize = 8;
lines(3).MarkerSize = 8;
lines(keep(4)).LineWidth = 4;
lines(keep(5)).LineWidth = 4;
lines(keep(6)).LineWidth = 4;
ylim([0.01 1]);



%% kz
tilt_angle = 120; %120; -47
[kx,ky,kz, rad_per_ang_per_px] = tilt_to_k_v2 (resM_gr20180402, posxy_gr20180402, 200, tilts_gr20180402'-2.7, tilt_angle, [1,2,3,4,5,6], 2.47,0);
m = BLG('ABABAB');
m.setkeV(200);
m.setSpotcut(1);
m.setKillZero(1);
m.setIntensityFactor(1);
m.setTiltStart(-30*pi/180);
m.setTiltEnd(30*pi/180);
m.setRotation(130*pi/180);
[tiltrange, I] = m.getTiltSeries('ewald','kz',0);

peak_range= [2 6 1]%[ 2 6 1]; %cyan, blue,purple %5,3,4
tilt_range= 10:57;
normalize= 1;
new_fig= 0;
stretchs = [1.02 .4];%[.9 .4];
translations= [.00 0];%[-2,0];
a = gca;
c_blue = [0 114 189]/255;
c_cyan = [110 190 195]/255;
c_purple = [134 91 165]/255;
colors = [c_cyan;c_blue ; c_purple];
outliers = removeOutliers(resM_gr20180402, 5,5,5,5);
plot_experimental_kz(resM_gr20180402, kz,peak_range , tilt_range,normalize,new_fig,stretchs,translations, outliers,colors );

lines = a.Children;
keep = [1:3,6 8 9];
throw = setdiff(1:length(lines),keep);
delete(lines(throw));
lines(keep(4)).Color = c_cyan;
%lines(keep(5)).Color = c_purple;
%lines(keep(6)).Color = c_blue;
lines(1).MarkerSize = 8;
lines(2).MarkerSize = 8;
lines(3).MarkerSize = 8;
lines(keep(4)).LineWidth = 4;
lines(keep(5)).LineWidth = 4;
lines(keep(6)).LineWidth = 4;
%ylim([0.01 1]);
title('');
set(gca,'FontSize',20);


set(gca,'FontSize',20);
    xlim([-1.4 1.4]);
    ylim([.001 1]);
set(gca,'FontSize',20);
set(gcf,'Position',[0 0 1000 1000]);
set(gca,'Position',[.05 .1 .9 .3]);


%% kz yikes
tilt_angle = 120; %120; -47
[kx,ky,kz, rad_per_ang_per_px] = tilt_to_k_v2 (resM_gr20180402, posxy_gr20180402, 200, tilts_gr20180402', tilt_angle, [1,2,3,4,5,6], 2.47,0);
m = BLG('ABABAB');
m.setkeV(200);
m.setSpotcut(1);
m.setKillZero(1);
m.setIntensityFactor(1);
m.setTiltStart(-12*pi/180);
m.setTiltEnd(11*pi/180);
m.setRotation(130*pi/180);
[tiltrange, I] = m.getTiltSeries('ewald','kz',0);

peak_range= [4 6 5]%[ 2 6 1]; %cyan, blue,purple %5,3,4
tilt_range= 10:57;
normalize= 1;
new_fig= 0;
stretchs = [1 1];%[.9 .4];
translations= [.05 0];%[-2,0];
a = gca;
c_blue = [0 114 189]/255;
c_cyan = [110 190 195]/255;
c_purple = [134 91 165]/255;
colors = [c_cyan;c_blue ; c_purple;c_cyan;c_blue ; c_purple;c_cyan;c_blue ; c_purple];
outliers = removeOutliers(resM_gr20180402, 5,5,5,5);
plot_experimental_kz(resM_gr20180402, kz,peak_range , tilt_range,normalize,new_fig,stretchs,translations, outliers,colors );

lines = a.Children;
keep = [1:3,6 8 9];
throw = setdiff(1:length(lines),keep);
delete(lines(throw));
lines(keep(4)).Color = c_cyan;
%lines(keep(5)).Color = c_purple;
%lines(keep(6)).Color = c_blue;
lines(1).MarkerSize = 8;
lines(2).MarkerSize = 8;
lines(3).MarkerSize = 8;
lines(keep(4)).LineWidth = 4;
lines(keep(5)).LineWidth = 4;
lines(keep(6)).LineWidth = 4;
%ylim([0.01 1]);
title('');
xlabel('k_z (Rads./Ang.)');
ylabel('Intensity (arbs. units)');
set(gca,'FontSize',20);


%%
%[kx,ky,kz, rad_per_ang_per_px] = tilt_to_k (resM_gr20180402, posxy_gr20180402, 200, tilts_gr20180402, 120, [1,2,3,4,5,6], 2.47 );
%[splined, kz_stack] = buildKzStack (resM_gr20180402, kx, ky, kz, 'gr_out_1.tif', .01, 10, .01 , rad_per_ang_per_px );
%[dsigma_dkz, broad, strain] = extract_broadening (kz,resM_gr20180402, rad_per_ang_per_px)

% old
function [kz] = convertTokz(posxy)
    pairs = [1,4;2,5;3,6];
    p1 = posxy(pairs(:,1),:);
    p2 = posxy(pairs(:,2),:);
    b1 = mean(1/2*(p1-p2));
    center_pos = mean(p2 + 1/2*( p1-p2 ));
    rad_per_ang_per_px = 2*pi/2.47 / sqrt((posxy(1,1)-center_pos(1)).^2 + (posxy(1,2)-center_pos(2)).^2);
    kx = rad_per_ang_per_px*(posxy(:,1) - center_pos(1));
    ky = rad_per_ang_per_px*(posxy(:,2) - center_pos(2));
    kev = 200;
    wav = 12.3986./sqrt((2*511.0+kev).*kev);
    k = 2*pi / wav ;
    kz = zeros(size(res));
    
    phi = tilts;
    theta = 50;
    qzo = k*cosd(phi);
    qxo = k*sind(phi)*cosd(theta);
    qyo = k*sind(phi)*sind(theta);
    for peak = 1:6
        kz(peak,:) = qzo - sqrt(k^2 - (kx(peak)-qxo).^2 - (ky(peak)-qyo).^2);
    end
    %outlier = removeOutliers(resM, 4,4,4,4);

    %int = abs(resM.a.*(outlier==0) .* resM.sigmax.*(outlier==0) .* resM.sigmay.*(outlier==0));
    %intnorm = int - min(int(:));
    %intnorm = intnorm ./ max(intnorm(:));

    global_kzmin = min(kz(:));
    global_kzmax = max(kz(:));
    kz_grid = [global_kzmin:.01:global_kzmax];
    splined.a = zeros(length(1:6),length(kz_grid));
    splined.b = zeros(length(1:6),length(kz_grid));
    splined.sigmax = zeros(length(1:6),length(kz_grid));
    splined.sigmay = zeros(length(1:6),length(kz_grid));
    splined.x0 = zeros(length(1:6),length(kz_grid));
    splined.y0 = zeros(length(1:6),length(kz_grid));
    splined.sum = zeros(length(1:6),length(kz_grid));
    for peak = 1:6
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
        
        splined.a( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        splined.b( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        splined.sigmax( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        splined.sigmay( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        splined.x0( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        splined.y0( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  
        splined.sum( peak, kz_grid < kzmin | kz_grid > kzmax) = 0;  

    end
    outlier = removeOutliers(splined, 100,100,100,100);

    int = abs(splined.a.*(outlier==0) .* splined.sigmax.*(outlier==0) .* splined.sigmay.*(outlier==0));
    intnorm = int - min(int(:));
    intnorm = intnorm ./ max(intnorm(:));
    splined.intnorm = intnorm;
    %figure;
    %plot(kz_grid,intnorm(:,:));
    
    
    %-> Tiff stack
    [mesh_x, mesh_y] = meshgrid(-10:.01:10,-10:.01:10);
    img = zeros(size(mesh_x,1), size(mesh_x,2), length(kz_grid));
    
    for level = 1:length(kz_grid)
        level
        for peak = 1:6
            x = [splined.a(peak,level), splined.b(peak,level)];
            sx = rad_per_ang_per_px*splined.sigmax(peak,level);
            sy = rad_per_ang_per_px*splined.sigmay(peak,level);
            xi = mesh_x;%posxy(peak,1);
            yi = mesh_y;%posxy(peak,2);
            %x0 = rad_per_ang_per_px*splined.x0(peak,level)+kx(peak);
            %y0 = rad_per_ang_per_px*splined.y0(peak,level)+ky(peak);
            x0 = kx(peak);
            y0 = ky(peak);
            img(:,:,level) = img(:,:,level)+  x(1)./(1+((xi-x0)/sx).^2+((yi-y0)/sy).^2)+x(2);
            
        end
        
    end
    writeToTiffStack(img,'output_without_pos_deviations.tif');
    
    %figure;
    %colormap gray;
    %imagesc(img);

end

% bugged
function [tilts,avg_results , posxy] = load_each_20180402_Graphene_DiffTilt()
    workingDirBN = '/Users/noah/Documents/hlab/data/20180117_2D_reciprocal_space/20180402_Graphene_DiffTilt';
    imDim = 2048;
    
    dirs = dir(workingDirBN);
    count = 0;
    posxy = [];
    short_stack = [];
    for i = 3:length(dirs)
       name = dirs(i).name;
       if length(name) >= 13 && name(1) == 'G' && length(name) < 16 && name(10)=='T' 
          %name 
          %count = count + 1;
          path = [workingDirBN '/' name '/Hour_00/Minute_00' ];
          subdirs = dir(path);
          count = count + 1;

          for j = 3:length(subdirs)
             subdir_name = subdirs(j).name;

             files =  dir([path  '/' subdir_name]);
             
             for k = 3: length(files)
                 %selecting peak positions
                 if j==3 && k== 3 && mod(i,5) == 0
                     fname = files(k).name;

                     img = bfopen([ path  '/' subdir_name '/' fname  ]);
                     short_stack = cat(3,short_stack,img{1}{1});
                 end
             end
          end
       end
    end
    posxy = selectSpots(short_stack);

    %stack = zeros(imDim,imDim,200); %arbitrary bound for preallocation.
    tilts = zeros(count,1);

    tilt_count = 0;
    
    for i = 3:length(dirs)
       name = dirs(i).name;
       if length(name) >= 13 && name(1) == 'G' && length(name) < 16 && name(10)=='T'
          path = [workingDirBN '/' name '/Hour_00/Minute_00' ];
          subdirs = dir(path);
          frame_count = 0;
          tilt_count = tilt_count + 1;
          stack = [];
          for j = 3:length(subdirs)
             subdir_name = subdirs(j).name;

             files =  dir([path  '/' subdir_name]);
             
             for k = 3: length(files)
                frame_count = frame_count + 1;
                fname = files(k).name;
                [Tx] = ReadDMFile([ path  '/' subdir_name '/' fname  ], 'log.txt');
                A = fopen('log.txt');
                a = textscan(A, '%s');
                list = strfind(a{1}, 'Alpha');
                ind = find(not(cellfun('isempty', list)))+1;
                alpha = str2double(a{1}(ind));
                

                list = strfind(a{1}, 'Beta');
                ind = find(not(cellfun('isempty', list)))+1;
                beta = str2double(a{1}(ind));
                tilts(tilt_count)= beta;%[tilts, beta];
                fclose(A);
                img = bfopen([ path  '/' subdir_name '/' fname  ]);
                %stack(:,:,frame_count) =  img{1}{1};
                stack  = cat(3,stack,img{1}{1});  
             end
             
          end
          %fitting across frames and averaging
              [~, resM, ~, ~] = analyzeSpots(posxy(2:length(posxy),:), stack, 64);
              avg_results.a(tilt_count,:) = mean(resM.a,2);
              avg_results.b(tilt_count,:) = mean(resM.b,2);
              avg_results.sigmax(tilt_count,:) = mean(resM.sigmax,2);
              avg_results.sigmay(tilt_count,:) = mean(resM.sigmay,2);
              avg_results.x0(tilt_count,:) = mean(resM.x0,2);
              avg_results.y0(tilt_count,:) = mean(resM.y0,2);
              avg_results.sum(tilt_count,:) = mean(resM.sum,2);
          
       end
    end
    
    [tilts, sort_indices] = sort(tilts);
    avg_results.a = avg_results.a(sort_indices,:);
    avg_results.b = avg_results.b(sort_indices,:);
    avg_results.sigmax = avg_results.sigmax(sort_indices,:);
    avg_results.sigmay = avg_results.sigmay(sort_indices,:);
    avg_results.x0 = avg_results.x0(sort_indices,:);
    avg_results.y0 = avg_results.y0(sort_indices,:);
    avg_results.sum = avg_results.sum(sort_indices,:);    
    
    save('mat_20180402_Graphene_DiffTilt_n.mat',  'tilts', 'avg_results', 'posxy');


end


% old
function surface_roughness(resM, tilts, posxy)
    %getting size of peak from standard deviation
    magnitude = sqrt(resM.sigmax.^2 + resM.sigmay.^2);
    num_peaks = size(posxy,1);
    %coercing positions in k space, using hard coded scale factor
    kx = posxy(2:num_peaks,1)-posxy(1,1);
    ky = posxy(2:num_peaks,2)-posxy(1,1);
    scale_factor = 547/2.544; %px / Å^-1 (from 2*pi/.247)
    kx = kx /scale_factor; %A^-1
    ky = ky / scale_factor;% Å^-1
    %calculating kz given HT, kx and ky, sample rotation and sample tilt
    kev = 200;
    wav = 12.3986./sqrt((2*511.0+kev).*kev);
    k = 2*pi / wav ;
    kz = zeros([num_peaks-1, size(tilts,1)]);
    for i = 1:size(num_peaks)-1
        phi = tilts;
        theta = 50;
        qzo = k*cosd(phi);
        qxo = k*sind(phi)*cosd(theta);
        qyo = k*sind(phi)*sind(theta);
        kz(:,i) = qzo - sqrt(k^2 - (kx(i)-qxo).^2 - (ky(i)-qyo).^2);
    end
    
    %plotting kz vs peak size 
    % selecting peaks of interest
    indices = [1:6];
    figure
    hold on
    angles = [];
    for i = 1:length(indices)
        %range of tilts/kz of interest
        ROI = 1:57;%kz(i,:) > 0.05;
        %plotting kz vs. peak size
        x = kz(indices(i),ROI);
        y = magnitude(indices(i),ROI);
        plot(x,y,'o-');
        %linear fit
        fit = polyfit(x,y,1);
        slope = fit(1);
        %extracting angle vs. normal
        angle = atan(slope)*180/pi;
        angles(count) = angle;
    end
    strain = 1./cosd(angles)-1;
    %plotting actual gaussian shapes
    figure;
    peak = 3;
    for i = 1:20:size(tilts,1) %arbitrary spacing
        x = -.4:.01:.4; 
        y = normpdf(x,0,magnitude(peak,i))*3   +    i;
        magnitude(peak,i)
        plot(x,y);
        hold on;
    end


end
% old
function plotting_20180402_Graphene_DiffTilt(resM, tilts)


    outlier = removeOutliers(resM, 4,4,4,4);
%     for i = 1:size(resM.x0,1)
%         figure('Color','w'); hold on; box on;
%         scatter(resM.y0(i,outlier(i,:)>0),  resM.x0(i,outlier(i,:)>0),'r');
%         scatter(resM.y0(i,outlier(i,:)==0), resM.x0(i,outlier(i,:)==0),'b');
%         c = polyfit(resM.y0(i,outlier(i,:)==0),resM.x0(i,outlier(i,:)==0),1);
%         x = min(resM.y0(i,:)):.1:max(resM.y0(i,:));
%         plot( x, c(2)+c(1)*x );
%     end

    int = abs(resM.a.*(outlier==0) .* resM.sigmax.*(outlier==0) .* resM.sigmay.*(outlier==0));
    intnorm = int - min(int(:));
    intnorm = intnorm ./ max(intnorm(:));
    %figure;
    hold on
    plot(tilts-2, intnorm(1:6,:)*2.6, 'LineWidth',4);
    xlabel('Tilt Angle (degrees)');
    ylabel('Intensity (a.u.)');

end
% good
function [stack_gr20180402, tilts_gr20180402, res_gr20180402, resM_gr20180402, d_im_gr20180402, f_im_gr20180402, posxy_gr20180402] = load_20180402_Graphene_DiffTilt()
    workingDirBN = '/Users/noah/Documents/hlab/data/20180117_2D_reciprocal_space/20180402_Graphene_DiffTilt';
    imDim = 2048;
    
    dirs = dir(workingDirBN);
    count = 0;
    tilts_gr20180402 = [];
    stack_gr20180402 = [];
    
    for i = 3:length(dirs)
       name = dirs(i).name;
       if length(name) >= 13 && name(1) == 'G' && length(name) < 16 && name(10)=='T' 
        count = count+1;
       end
    end
    stack_gr20180402 = zeros(imDim,imDim,count);
    tilts_gr20180402 = zeros(count,1);
    %nameszz = {}%zeros(count,1);

    count = 0;

    for i = 3:length(dirs)
       name = dirs(i).name;
       if length(name) >= 13 && name(1) == 'G' && length(name) < 16 && name(10)=='T' 
          %name 
          %count = count + 1;
          path = [workingDirBN '/' name '/Hour_00/Minute_00' ];
          subdirs = dir(path);
          avg_count = 0;
          count = count + 1;

          for j = 3:3
             subdir_name = subdirs(j).name;
             if( length(subdir_name) == 9 ) %fixing dstor pickup
                 subdir_name = subdirs(j+1).name;
             end
             files =  dir([path  '/' subdir_name]);
             
             for k = 3: 3
                fname = files(k).name;
                %reader = bfGetReader([ path  '/' subdir_name '/' fname  ]);
                [Tx] = ReadDMFile([ path  '/' subdir_name '/' fname  ], 'log.txt');
                A = fopen('log.txt');
                a = textscan(A, '%s');
                list = strfind(a{1}, 'Alpha');
                ind = find(not(cellfun('isempty', list)))+1;
                alpha = str2double(a{1}(ind));%a{1}(not(cellfun('isempty', list))+1)
                %alpha = a(ind);
                

                list = strfind(a{1}, 'Beta');
                ind = find(not(cellfun('isempty', list)))+1;
                beta = str2double(a{1}(ind));%a{1}(not(cellfun('isempty', list))+1)   
                tilts_gr20180402(count)= beta;%[tilts, beta];
                %nameszz{end+1} = i;
                fclose(A);
                img = bfopen([ path  '/' subdir_name '/' fname  ]);
                stack_gr20180402(:,:,count) = img{1}{1};
                
                %{1}:{imdata}, {path}
                %{2}:{tags} (original metadata)
                %{3}:??? 0x0
                %{4}: OME metadata
                
             end
             
          end
          %stack(:,:,count) = stack(:,:,count)./ avg_count;
       end
    end
    
    
    [tilts_gr20180402, sort_indices] = sort(tilts_gr20180402);
    stack_gr20180402 = stack_gr20180402(:,:,sort_indices);
    
    
    
    [posxy_gr20180402] = selectSpots( stack_gr20180402 );
    [res_gr20180402, resM_gr20180402, d_im_gr20180402, f_im_gr20180402] = analyzeSpots(posxy_gr20180402, stack_gr20180402, 32); %positions, dataset, window size
    save('mat_20180402_Graphene_DiffTilt.mat', 'stack_gr20180402', 'tilts_gr20180402', 'res_gr20180402', 'resM_gr20180402', 'd_im_gr20180402', 'f_im_gr20180402','posxy_gr20180402');


end

