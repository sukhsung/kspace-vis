% Test Suite
clear all
close all

%% Test CrSBr
m = RuCl3();
m.numLayer=1;

m.setTitle('');
m.setKzExtent( 3.9*pi/m.lambda )
m.lambda_Ru = 0;%.5;
m.setSpotcut(2);
%% Test draw3D
drawRect = true;
m.setkeV(80);
m.setKillZero(1);
m.setIntensityFactor(1);
m.draw3D(true,figure);
%%
hs = [0   0 -1 -1 -1 -1  1  1  1  1  2 -2]';
ks = [-1 -2 -2 -1  1  2 -2 -1  1  2 -2 -2]';
m.draw3DHK(hs,ks,drawRect,figure);
view([47, 48])


return
%% Test Tilt Pattern
m.setkeV(200);
m.setKillZero(1);
m.setIntensityFactor(1);
t_max= 40;
m.setTiltStart(-t_max*pi/180);
m.setTiltEnd(t_max*pi/180);
m.setTiltN(1024);
m.setTiltAxis(deg2rad(-30));

%displaymode = 'kz';
displaymode = 'angle';
displaypattern = true;
kzmode = 'ewald';

%kzmode = 'constant';
hks = [0, 1; 1,  0; 1, -1; 0, -1; -1, 0];% 
      % 0, 3; 3,  0; 3, -3; 0, -3; -3, 0; -3, 3];
[tiltrange, I] = m.getTiltSeriesHK(hks(:,1),hks(:,2), kzmode,displaymode, displaypattern, figure);

figure
hold on
axis equal
plot(tiltrange,I,'-');

%%
% Test Side view
m.setKillZero(2);
hs = [1 1 3 ]';
ks = [0 1 0 ]';
xpos = [1:3]';

m.drawSideView(hs,ks,xpos,figure)
