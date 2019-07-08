%added 3rd center beam toggle . -> gray
%added return of the pos, mag from draw3D
%added intensity factor

%stackingseq = repmat('A',1,5);
nA = @(n) repmat('A',1,n);
nB = @(n) repmat('B',1,n);
nc = @(n) repmat('C',1,n);
%BACBA
%ABABABABAB
%BACBACBACB
%ACBACBACBA
%ACBACBACBA
%BABACBACBA
%ACBACBACBACB
%ABABABABABAB


%bnbb
m = BLG(['BA']);%TprimeMoS2();%BLG(['ABABABABABABABA']);%MoS2('5H');%BLG(['AAAAAAAAAA']);%BLG(['ACBACBACBACB']);%TaSe2('2H'); %BN('AB');%TaSe2('1H');

%% 3D View

%   m.setSpotcut(2);
%  m.setKillZero(2);
% m.setIntensityFactor(7);%3);
% m.setIntcut(.0001);
% [pos, mag] = m.draw3D;
% 
% 
% %drawing hexagon around first order peaks
% colormap(gray)
% bound = 3;
% %xlim([-bound bound])
% %ylim([-bound bound])
% %drawing hexagon at kz = 0
% kz0 = pos(pos(:,3)==0 & pos(:,2) < bound & pos(:,2) > -bound & pos(:,1) < bound & pos(:,1) > -bound & ~( pos(:,1) ==0 & pos(:,2)==0  ),:);
% phase = atan2(kz0(:,2),kz0(:,1))*180/pi;
% kz0 = [kz0,phase];
% kz0 = sortrows(kz0,4);
% kz0 = [kz0; kz0(1,:)]; %completing hexagon (wrap back to first point)
% if(1)
%     plot3(kz0(:,1),kz0(:,2),kz0(:,3));
% end
% set(gca,'YTickLabel',[])
% set(gca,'XTickLabel',[])
% set(gca,'ZTickLabel',[])
% set(gca,'YTick',[])
% set(gca,'XTick',[])
% set(gca,'ZTick',[])
% 
% view(-165, 34)

%% Cross Sectional
% 
% m.setSpotcut(2);
% m.setKillZero(2);
% m.setIntensityFactor(6);%4);
% m.setIntcut(.0001);
% angle = 30;
% [pos, mag] = m.drawCrossSection(angle);
% 
% set(gca,'XTick',[])
% set(gca,'YTick',[])
% set(gca,'ZTick',[])
% 
% view(angle,0)

%% Tilt Pattern
 %Duplicates?????

m.setkeV(200);
m.setSpotcut(2);
m.setKillZero(1);
m.setIntensityFactor(1);
m.setTiltStart(-15*pi/180);
m.setTiltEnd(15*pi/180);
m.setRotation(90*pi/180);
%ewald or constant, kz or angle
[tiltrange, I] = m.getTiltSeries('ewald','angle',0);



%close all;
%[MSE,kXScale,kYScale,kXShift, kYShift, k_domain] = error_accounting(exp_tilts, exp_ints, tiltrange, I);
%MSE
%struct = [struct; tmch, MSE, kXScale, kYScale, kXShift, kYShift, {k_domain}];
%quickplot;