%added 3rd center beam toggle . -> gray
%added return of the pos, mag from draw3D
%added intensity factor

m = MoS2('2H');

%% 3D View

%   m.setSpotcut(2);
%  m.setKillZero(2);
% m.setIntensityFactor(3);
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
% 
% view(190, 34)

%% Cross Sectional

m.setSpotcut(2);
m.setKillZero(2);
m.setIntensityFactor(4);
[pos, mag] = m.drawCrossSection();

%% Tilt Pattern

% 
% m.setSpotcut(2);
% m.setKillZero(1);
% m.setIntensityFactor(1);
% m.setTiltStart(-30*pi/180);
% m.setTiltEnd(30*pi/180);
% m.setRotation(150*pi/180);
% 
% m.getTiltSeries();


%figure; plot(multislice_tilts, mutlislice_intnorm, 'LineWidth' , 3)
%hold on
%plot(exp_tilts-2, exp_orig+.01, 'o')
