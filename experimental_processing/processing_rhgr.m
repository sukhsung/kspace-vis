%[stack_rhgr_rhs, tilts_rhgr_rhs, res_rhgr_rhs, resM_rhgr_rhs, d_im_rhgr_rhs, f_im_rhgr_rhs, posxy_rhgr_rhs] = loadRHGRRHS();
%[stack_rhgr, tilts_rhgr, res_rhgr, resM_rhgr, d_im_rhgr, f_im_rhgr, posxy_rhgr] = loadRHGR();

%load('mat_rhgr.mat');
%[kx,ky,kz, rad_per_ang_per_px] = tilt_to_k (resM_rhgr, posxy_rhgr, 80, tilts_rhgr, 90, [1,2,3,4,5,6], 2.47 );
%[splined, kz_stack] = buildKzStack (resM_mos220180115, kx, ky, kz, 'MoS2_out_5.tif', .01, 10, .01 , rad_per_ang_per_px );
%[dsigma_dkz, broad, strain] = extract_broadening (kz,resM_rhgr, rad_per_ang_per_px)
%%
load('mat_rhgr.mat');
outliers = removeOutliers( resM_rhgr,  5, 2, 2, 5 ); % 5 2 2 5 %.5, .5, .5, .5
%8,10 (7,9)second order non-orth
%1,4 first order orth
%3,6 (2,5)first order non orth
%myRun
m = BLG(['BA']);
m.setkeV(80);
m.setSpotcut(2);
m.setKillZero(1);
m.setIntensityFactor(1);
m.setTiltStart(-15*pi/180);
m.setTiltEnd(15*pi/180);
m.setRotation(90*pi/180);
%ewald or constant, kz or angle
[tiltrange, I] = m.getTiltSeries('ewald','angle',1);
close all;
figure('rend','painters','pos',[10 10 600 200],'DefaultAxesFontSize',20);
sim_range = [10 9 5 6 4 7]; %4 5 6 7 9 10 12 13 14 15
%parabolas:4 7 12 15
%swooshs: 5 6 13 14
%sinusoidals: 9 10
colors = [0 134 192; 0 201 169;174 101  44; 99 129  39;119 108 193; 255 109 174;0 0 0]/255;
for it = 1:length(sim_range)
   sim_it = sim_range(it);
   plot(tiltrange.*180/pi, I(sim_it,:),'--','LineWidth',2,'Color',colors(it,:));
   hold on;
end


plot_experimental(resM_rhgr, tilts_rhgr, [1,4,3,6,8,10], 1:61, 1, 0 , [0.95 1.15],[-0.75 0], outliers,colors);
xlim([-15 15]);
ylim([0.01 1.1]);

%set(gca,
%%
clear; close all; clc;
load('mat_rhgr.mat');

%% kz
outliers = removeOutliers( resM_rhgr,  5, 2, 2, 5 ); % 5 2 2 5 %.5, .5, .5, .5
%8,10 (7,9)second order non-orth
%1,4 first order orth
%3,6 (2,5)first order non orth
%myRun

tilt_angle =100; %120; -47
[kx,ky,kz, rad_per_ang_per_px] = tilt_to_k_v2 (resM_rhgr, posxy_rhgr, 200, tilts_rhgr'-.75, tilt_angle, [1,2,3,4,5,6], 2.47,1);


m = BLG(['BA']);
m.setkeV(80);
m.setSpotcut(2);
m.setKillZero(1);
m.setIntensityFactor(1);
m.setTiltStart(-15*pi/180);
m.setTiltEnd(15*pi/180);
m.setRotation(90*pi/180);
%ewald or constant, kz or angle
[tiltrange, I] = m.getTiltSeries('ewald','kz',0);

plot_experimental_kz(resM_rhgr, kz, [1,4,3,6,8,10], 1:61, 1, 0 , [2 1.1],[-.08 0], outliers,colors);

sim_range = [10 9 5 6 4 7];
a = gca;
lines = a.Children;
keep = [1:6 6+sim_range];
throw = setdiff(1:length(lines),keep);
delete(lines(throw));
colors = [0 134 192; 0 201 169;174 101  44; 99 129  39;119 108 193; 255 109 174;0 0 0]/255;

for it = 1:6
   lines(keep(6+it)).Color = colors(it,:); 
   lines(keep(6+it)).LineWidth = 4;
   lines(keep(it)).LineWidth = 2;
   lines(keep(it)).MarkerSize = 10;
end

lines(keep(1)).Marker = 'diamond';
lines(keep(2)).Marker = 'diamond';


    xlim([-1.4 1.4]);
    ylim([.001 1]);
    title('');
    set(gca,'FontSize',20);
    set(gca,'Position',[.05 .05 .9 .3]);
    
set(gcf,'Position',[10 10 1000 1000]);

%%
%close all;
figure('rend','painters','pos',[10 10 600 200],'DefaultAxesFontSize',20);
sim_range = [10 9 5 6 4 7]; %4 5 6 7 9 10 12 13 14 15
%parabolas:4 7 12 15
%swooshs: 5 6 13 14
%sinusoidals: 9 10
colors = [0 134 192; 0 201 169;174 101  44; 99 129  39;119 108 193; 255 109 174;0 0 0]/255;
for it = 1:length(sim_range)
   sim_it = sim_range(it);
   plot(tiltrange.*180/pi, I(sim_it,:),'--','LineWidth',2,'Color',colors(it,:));
   hold on;
end


plot_experimental(resM_rhgr, tilts_rhgr, [1,4,3,6,8,10], 1:61, 1, 0 , [0.95 1.15],[-0.75 0], outliers,colors);
xlim([-15 15]);
ylim([0.01 1.1]);




%%
function [stack_rhgr_rhs, tilts_rhgr_rhs, res_rhgr_rhs, resM_rhgr_rhs, d_im_rhgr_rhs, f_im_rhgr_rhs, posxy_rhgr_rhs] = loadRHGRRHS()
    workingDir = '/Users/noah/Documents/hlab/data/20180117_2D_reciprocal_space/BilayerGraphene/Right Side/tiltonly_2s';
    imDimY = 1376;
    imDimX = 1032;
    %imDim = 2048;
    
    Files=dir([workingDir '/' '*.*']);
    
    
    stack_rhgr_rhs = zeros(imDimX,imDimY,length(Files)-2);
    tilts_rhgr_rhs = zeros(length(Files)-2,1);
    pre = '0_4s_';  %....0_4s_[tiltA]_[tiltB](_/.)...
    
    
    for i = 3:length(Files)
        fname = Files(i).name;
        stack_rhgr_rhs(:,:,i-2) = imread([workingDir '/' fname]);
        sign = fname(8);
        sub = fname(8:length(fname));
        sub = sub(1:strfind(sub,'_')-4);
        if sign ~= 'm'
            tilts_rhgr_rhs(i-2) = str2double(sub);
        else
            tilts_rhgr_rhs(i-2) = -str2double(sub(2:length(sub)));
        end
        
        
        
        %pref = strfind(fname,pre)+5;
        %sub1 = fname(pref:length(fname-1));
        %alphaEnd = strfind(sub1,'_');
        %alpha =str2double(sub1(1:alphaEnd-1));
        
        %sub2 = sub1(alphaEnd+1:length(sub1-1));
        %betaEnd = strfind(sub2,'_');
        %if(length(betaEnd)==0)
        %   betaEnd = strfind(sub2,'.'); 
        %end
        
        %beta = str2double(sub2(1:4));
        
        %tilts_rhgr(i-2) = alpha;
        
    end
    
    
    
    [tilts_rhgr_rhs, sort_indices] = sort(tilts_rhgr_rhs);
    stack_rhgr_rhs = stack_rhgr_rhs(:,:,sort_indices);
    
    [posxy_rhgr_rhs] = selectSpots( stack_rhgr_rhs );
    [res_rhgr_rhs, resM_rhgr_rhs, d_im_rhgr_rhs, f_im_rhgr_rhs] = analyzeSpots(posxy_rhgr_rhs, stack_rhgr_rhs, 32); %positions, dataset, window size
    save('mat_rhgr_rhs.mat', 'stack_rhgr_rhs', 'tilts_rhgr_rhs', 'res_rhgr_rhs', 'resM_rhgr_rhs', 'd_im_rhgr_rhs', 'f_im_rhgr_rhs','posxy_rhgr_rhs');

end


function [stack_rhgr, tilts_rhgr, res_rhgr, resM_rhgr, d_im_rhgr, f_im_rhgr, posxy_rhgr] = loadRHGRLHS()
    workingDir = '/Users/noah/Documents/hlab/data/20180117_2D_reciprocal_space/BilayerGraphene/Left Side/tiltonly_2s';
    imDimY = 1376;
    imDimX = 1032;
    %imDim = 2048;
    
    Files=dir([workingDir '/' '*.*']);
    
    stack_rhgr = zeros(imDimX,imDimY,length(Files)-2);
    tilts_rhgr = zeros(length(Files)-2,1);
    pre = '0_4s_';  %....0_4s_[tiltA]_[tiltB](_/.)...
    
    
    for i = 3:length(Files)
        fname = Files(i).name;
        stack_rhgr(:,:,i-2) = imread([workingDir '/' fname]);
        sign = fname(8);
        sub = fname(8:length(fname));
        sub = sub(1:strfind(sub,'_')-4);
        
        if sign ~= 'm'
            tilts_rhgr(i-2) = str2double(sub);
        else
            tilts_rhgr(i-2) = -str2double(sub(2:length(sub)));
        end
        
        
        
        %pref = strfind(fname,pre)+5;
        %sub1 = fname(pref:length(fname-1));
        %alphaEnd = strfind(sub1,'_');
        %alpha =str2double(sub1(1:alphaEnd-1));
        
        %sub2 = sub1(alphaEnd+1:length(sub1-1));
        %betaEnd = strfind(sub2,'_');
        %if(length(betaEnd)==0)
        %   betaEnd = strfind(sub2,'.'); 
        %end
        
        %beta = str2double(sub2(1:4));
        
        %tilts_rhgr(i-2) = alpha;
        
    end
    
    
    
    [tilts_rhgr, sort_indices] = sort(tilts_rhgr);
    stack_rhgr = stack_rhgr(:,:,sort_indices);
    
    [posxy_rhgr] = selectSpots( stack_rhgr );
    [res_rhgr, resM_rhgr, d_im_rhgr, f_im_rhgr] = analyzeSpots(posxy_rhgr, stack_rhgr, 32); %positions, dataset, window size
    save('mat_rhgr.mat', 'stack_rhgr', 'tilts_rhgr', 'res_rhgr', 'resM_rhgr', 'd_im_rhgr', 'f_im_rhgr','posxy_rhgr');

end
