%%
%[stack_mos220180115, tilts_mos220180115, res_mos220180115, resM_mos220180115, d_im_mos220180115, f_im_mos220180115, posxy_mos220180115] = loadMoS2TiltSeries();
%%
load('/Users/noah/Documents/hlab/data/20180117_2D_reciprocal_space/20180115_MoS2_Diffraction_Tilt_80keV/mat_20180115_MoS2_DiffTilt.mat');

%%
m = MoS2('1H');
m.setkeV(80);
m.setSpotcut(2);
m.setKillZero(1);
m.setIntensityFactor(1);
m.setTiltStart(-30*pi/180);
m.setTiltEnd(30*pi/180);
m.setTiltAxis(30*pi/180);
[tiltrange, I] = m.getTiltSeries('ewald','angle',0,figure);

peak_range= [1 8 15];%[7,13];
tilt_range= 1:58;
normalize= 1;
new_fig= 1;
stretchs = [1, .9];
translations= [0,0];

outlier = removeOutliers(resM_mos220180115, 2,2,2,2);
a = gca;
plot_experimental(resM_mos220180115, tilts_mos220180115,peak_range , tilt_range,normalize,new_fig,stretchs,translations, outlier, [a.ColorOrder; a.ColorOrder; a.ColorOrder]);


% 0 = 105
[kx,ky,kz, rad_per_ang_per_px] = tilt_to_k(resM_mos220180115, posxy_mos220180115, 80, tilts_mos220180115, 105, [1,2,3,4,6], 3.161 );
%[splined, kz_stack] = buildKzStack (resM_mos220180115, kx, ky, kz, 'MoS2_out_5.tif', .01, 10, .01 , rad_per_ang_per_px );
%[dsigma_dkz, broad, strain] = extract_broadening (kz,resM_mos220180115, rad_per_ang_per_px)

%singleFrameBroad(27,stack_mos220180115);

%% main text figure remake
%#include kspace-vis_nah_branch
m = MoS2('1H');
m.setkeV(80);
m.setSpotcut(2);
m.setKillZero(1);
m.setIntensityFactor(1);
m.setTiltStart(-30*pi/180);
m.setTiltEnd(30*pi/180);
m.setTiltAxis(30*pi/180);
[tiltrange, I] = m.getTiltSeries('ewald','angle',0,figure);
peak_range= [4 7 8 9];%[1 8 15];%[7,13];
tilt_range= 1:58;
normalize= 1;
new_fig= 0;
stretchs = [1, .9];
translations= [0,0];
c_blue = [0 114 189]/255;
c_cyan = [110 190 195]/255;
c_purple = [134 91 165]/255;
c_orange = [242 100 33]/255;
outlier = removeOutliers(resM_mos220180115, 2,2,2,2);
a = gca;
plot_experimental(resM_mos220180115, tilts_mos220180115,peak_range , tilt_range,normalize,new_fig,stretchs,translations, outlier, [c_purple; c_cyan;c_blue ; c_orange]);
lines = a.Children;
keep = [1:4,6:7,9,11];
throw = setdiff(1:length(lines),keep);
delete(lines(throw));
lines(keep(5)).Color = c_cyan;
lines(keep(6)).Color = c_blue;
lines(keep(7)).Color = c_purple;
lines(keep(8)).Color = c_orange;
lines(1).Marker = 'diamond';
lines(2).Marker = 'diamond';
lines(3).Marker = 'diamond';
lines(1).MarkerSize = 8;
lines(2).MarkerSize = 8;
lines(3).MarkerSize = 8;
lines(4).MarkerSize = 8;
lines(keep(5)).LineWidth = 4;
lines(keep(6)).LineWidth = 4;
lines(keep(7)).LineWidth = 4;
lines(keep(8)).LineWidth = 4;
ylim([0.001 1]);


%% kz figure
for it = 280
    %[kx,ky,kz, rad_per_ang_per_px] = tilt_to_k(resM_mos220180115, posxy_mos220180115, 80, tilts_mos220180115, it, [1,2,3,4,6], 3.161 );
    %center_pt = (posxy_mos220180115(1,:)+posxy_mos220180115(4,:))/2;
    [kx,ky,kz, rad_per_ang_per_px] = tilt_to_k_v2(resM_mos220180115, posxy_mos220180115, 80, tilts_mos220180115', it, [1,2,3,4,6], 3.161,0 );
    kz= kz;
    m = MoS2('1H');
    m.setkeV(80);
    m.setSpotcut(2);
    m.setKillZero(1);
    m.setIntensityFactor(1);
    m.setTiltStart(-25*pi/180);
    m.setTiltEnd(25*pi/180);
    m.setRotation(27*pi/180);% (105,30);
    [tiltrange, I] = m.getTiltSeries('ewald','kz',0);

    peak_range= [4 7 8 9];%*******************************
    tilt_range= 1:58;
    normalize= 1;
    new_fig= 0;
    stretchs = [1.1, 1];
    translations= [0,-.02];
    c_blue = [0 114 189]/255;
    c_cyan = [110 190 195]/255;
    c_purple = [134 91 165]/255;
    c_orange = [242 100 33]/255;
    outlier = removeOutliers(resM_mos220180115, 2,2,2,2);
    a = gca;
    plot_experimental_kz(resM_mos220180115, kz,peak_range , tilt_range,normalize,new_fig,stretchs,translations, outlier, [c_purple; c_cyan;c_blue ; c_orange]);


    lines = a.Children;
    keep = [1:4,6:7,9,11];
    throw = setdiff(1:length(lines),keep);
    delete(lines(throw));
    lines(keep(5)).Color = c_cyan;
    lines(keep(6)).Color = c_blue;
    lines(keep(7)).Color = c_purple;
    lines(keep(8)).Color = c_orange;
    lines(1).Marker = 'diamond';
    lines(2).Marker = 'diamond';
    lines(3).Marker = 'diamond';
    lines(1).MarkerSize = 8;
    lines(2).MarkerSize = 8;
    lines(3).MarkerSize = 8;
    lines(4).MarkerSize = 8;
    lines(keep(5)).LineWidth = 4;
    lines(keep(6)).LineWidth = 4;
    lines(keep(7)).LineWidth = 4;
    lines(keep(8)).LineWidth = 4;
    title(num2str(it));
    
    ylim([.001 1]);
    title('');
    xlim([-1.5 1.5]);
set(gca,'FontSize',20);
set(gcf,'Position',[0 0 1000 1000]);
set(gca,'Position',[.1 .1 .8 .4]);


end
%%
function [stack_mos220180115, tilts_mos220180115, res_mos220180115, resM_mos220180115, d_im_mos220180115, f_im_mos220180115, posxy_mos220180115] = loadMoS2TiltSeries()
    workingDir = '/Users/noah/Documents/hlab/data/20180117_2D_reciprocal_space/20180115_MoS2_Diffraction_Tilt_80keV/tiff_images/tilt_only';
    imDim = 2048;
    
    
    Files=dir([workingDir '/' '*.*']);
    
    stack_mos220180115 = zeros(imDim,imDim,length(Files)-2);
    tilts_mos220180115 = zeros(length(Files)-2,1);
    
    pre = '0_4s_';  %....0_4s_[tiltA]_[tiltB](_/.)...
    
    
    for i = 3:length(Files)
        fname = Files(i).name;
        stack_mos220180115(:,:,i-2) = imread([workingDir '/' fname]);
        pref = strfind(fname,pre)+5;
        sub1 = fname(pref:length(fname-1));
        alphaEnd = strfind(sub1,'_');
        alpha =str2double(sub1(1:alphaEnd-1));
        
        sub2 = sub1(alphaEnd+1:length(sub1-1));
        betaEnd = strfind(sub2,'_');
        if(length(betaEnd)==0)
           betaEnd = strfind(sub2,'.'); 
        end
        
        beta = str2double(sub2(1:4));
        
        tilts_mos220180115(i-2) = alpha;
        
    end
    
    
    
    [tilts_mos220180115, sort_indices] = sort(tilts_mos220180115);
    stack_mos220180115 = stack_mos220180115(:,:,sort_indices);
    
    [posxy_mos220180115] = selectSpots( stack_mos220180115 );
    [res_mos220180115, resM_mos220180115, d_im_mos220180115, f_im_mos220180115] = analyzeSpots(posxy_mos220180115, stack_mos220180115, 32); %positions, dataset, window size
    save('mat_20180115_MoS2_DiffTilt.mat', 'stack_mos220180115', 'tilts_mos220180115', 'res_mos220180115', 'resM_mos220180115', 'd_im_mos220180115', 'f_im_mos220180115','posxy_mos220180115');

end
