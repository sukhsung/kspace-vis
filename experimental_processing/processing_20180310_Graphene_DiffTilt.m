%%
load('mat_20180310_Graphene_DiffTilt.mat');

%% exp peak pos
figure; scatter(posxy_gr20180310(:,1),posxy_gr20180310(:,2));
for it = 1:length(posxy_gr20180310)
    text(posxy_gr20180310(it,1),posxy_gr20180310(it,2),num2str(it),'FontSize',20);
    
end

%% tilt redone
m = BLG('CBACBACBACBA');
m.setkeV(80);
m.setSpotcut(1);
m.setKillZero(1);
m.setIntensityFactor(1);
m.setTiltStart(-25*pi/180);
m.setTiltEnd(25*pi/180);
m.setRotation(-17*pi/180);
[tiltrange, I] = m.getTiltSeries('ewald','angle',0);

peak_range= [1 5 6];%[1:6];
tilt_range= 1:101;
normalize= 1;
new_fig= 0;
stretchs = [1.0 1.0];
translations= [0,0];
outlier = removeOutliers(resM_gr20180310, 5,5,5,5);
    c_blue = [0 114 189]/255;
    c_cyan = [110 190 195]/255;
    c_purple = [134 91 165]/255;
    c_orange = [242 100 33]/255;
colors = [c_cyan;c_blue;c_purple]; %a.ColorOrder;
plot_experimental(resM_gr20180310, tilts_gr20180310,peak_range , tilt_range,normalize,new_fig,stretchs,translations,outlier,colors );
a = gca;

lines = a.Children;
keep = [1:3,6,8,4];
throw = setdiff(1:length(lines),keep);
delete(lines(throw));
lines(keep(4)).Color = c_cyan;
lines(keep(5)).Color = c_purple;
lines(keep(6)).Color = c_blue;
lines(1).MarkerSize = 8;
lines(2).MarkerSize = 8;
lines(3).MarkerSize = 8;
lines(keep(4)).LineWidth = 4;
lines(keep(5)).LineWidth = 4;
lines(keep(6)).LineWidth = 4;
ylim([0.01 1]);



%% kz
[kx,ky,kz, rad_per_ang_per_px] = tilt_to_k_v2(resM_gr20180310, posxy_gr20180310, 80, tilts_gr20180310, 5, [1,2,3,4,5,6], 2.46,1 );

m = BLG('CBACBACBACBA');
m.setkeV(80);
m.setSpotcut(1);
m.setKillZero(1);
m.setIntensityFactor(1);
m.setTiltStart(-25*pi/180);
m.setTiltEnd(25*pi/180);
m.setRotation(-17*pi/180);
[tiltrange, I] = m.getTiltSeries('ewald','kz',0);

peak_range= [1 2 6];%%%%%%%%%%%%%%%%%
tilt_range= 1:101;
normalize= 1;
new_fig= 0;
stretchs = [1.05 1.0];
translations= [-.015,0];
outlier = removeOutliers(resM_gr20180310, 5,5,5,5);
    c_blue = [0 114 189]/255;
    c_cyan = [110 190 195]/255;
    c_purple = [134 91 165]/255;
    c_orange = [242 100 33]/255;
colors = [c_cyan;c_blue;c_purple]; %a.ColorOrder;
plot_experimental_kz(resM_gr20180310, kz,peak_range , tilt_range,normalize,new_fig,stretchs,translations,outlier,colors );
a = gca;

lines = a.Children;
keep = [1:3,6,8,4];
throw = setdiff(1:length(lines),keep);
delete(lines(throw));
lines(keep(4)).Color = c_cyan;
lines(keep(5)).Color = c_purple;
lines(keep(6)).Color = c_blue;
lines(1).MarkerSize = 8;
lines(2).MarkerSize = 8;
lines(3).MarkerSize = 8;
lines(keep(4)).LineWidth = 4;
lines(keep(5)).LineWidth = 4;
lines(keep(6)).LineWidth = 4;
ylim([0.0 1]);

title('');
set(gca,'FontSize',20);
    xlim([-1.4 1.4]);
    ylim([.001 1]);
set(gca,'FontSize',20);
set(gcf,'Position',[0 0 1000 1000]);
set(gca,'Position',[.05 .1 .9 .3]);


%%
%[stack_gr20180310, tilts_gr20180310, res_gr20180310, resM_gr20180310, d_im_gr20180310, f_im_gr20180310, posxy_gr20180310] = load_20180310_Graphene_DiffTilt();


function [stack_gr20180310, tilts_gr20180310, res_gr20180310, resM_gr20180310, d_im_gr20180310, f_im_gr20180310, posxy_gr20180310] = load_20180310_Graphene_DiffTilt()



%function [stack, tilts] = loadBLGTiltSeries()
    workingDir = '/Users/noah/Documents/hlab/data/20180117_2D_reciprocal_space/20180310_Graphene_Diffraction_Tilt_80keV/tiff_images';
    %workingDir = '';
    imDim = 2048;
    
    
    Files=dir([workingDir '/' '*.*']);
    count = 0;
    stack_gr20180310 = zeros(imDim,imDim,length(Files)-2);
    tilts_gr20180310 = zeros(2,length(Files)-2);
    
    %pre = '0_4s_';  %....0_4s_[tiltA]_[tiltB](_/.)...
    
    
    for i = 3:length(Files)
       fname= Files(i).name;
       %time_kV_mag_bright_spot_alpha_$alpha$_beta_$beta$_$diffraction/overview$_...
       %substring from alpha->
       
       sub1 = fname(strfind(fname, 'alpha')+6:length(fname));
       alpha_end = strfind(sub1,'_');
       alpha = str2double(sub1(1:alpha_end-1));
       
       sub2 = sub1(strfind(sub1,'beta')+5: length(sub1) );
       beta_end = strfind(sub2,'_');
       beta = str2double(sub2(1:beta_end-1));
       
       sub3 = sub2(beta_end+1:length(sub2));
       if(length(sub3)>0)
            if(sub3(1)=='d')
                count = count+1;
                stack_gr20180310(:,:,count) = imread([workingDir '/' fname]);
                tilts_gr20180310(:,count)=[alpha,beta];
                    display(fname)
    display(alpha)
    display(beta)
    display('    ')
            end

       end
       

    end
    stack_gr20180310 = stack_gr20180310(:,:,1:count);
    tilts_gr20180310 = tilts_gr20180310(2,1:count);
    
    
    [posxy_gr20180310] = selectSpots( stack_gr20180310 );
    [res_gr20180310, resM_gr20180310, d_im_gr20180310, f_im_gr20180310] = analyzeSpots(posxy_gr20180310, stack_gr20180310, 32); %positions, dataset, window size
    save('mat_20180310_Graphene_DiffTilt.mat', 'stack_gr20180310', 'tilts_gr20180310', 'res_gr20180310', 'resM_gr20180310', 'd_im_gr20180310', 'f_im_gr20180310','posxy_gr20180310');


end
