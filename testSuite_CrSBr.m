% Test Suite
clear all
close all

%% Test CrSBr
m = CrSBr();
m.numLayer=1;

m.setTitle('');
m.setKzExtent( 3.9*pi/m.lambda )

m.setSpotcut(3);
%% Test draw3D
drawRect = true;
hs = [0   0 -1 -1 -1 -1  1  1  1  1  2 -2]';
ks = [-1 -2 -2 -1  1  2 -2 -1  1  2 -2 -2]';
m.draw3DHK(hs,ks,drawRect,figure);
view([47, 48])

m.setkeV(200);
m.setKillZero(1);
m.setIntensityFactor(1);
%% Test Tilt Pattern
m.setkeV(200);
m.setKillZero(1);
m.setIntensityFactor(1);
t_max= 30;
m.setTiltStart(-t_max*pi/180);
m.setTiltEnd(t_max*pi/180);
m.setTiltN(1024);
m.setTiltAxis(deg2rad(90));

displaymode = 'kz';
%displaymode = 'angle';
displaypattern = true;
kzmode = 'ewald';
%kzmode = 'constant';
hks = [
       1, 2; 1, -2; -1, 2; -1, -2; ...
       1, 1; 1, -1; -1, 1; -1, -1];
[tiltrange, I] = m.getTiltSeriesHK(hks(:,1),hks(:,2), kzmode,displaymode, displaypattern, figure);

hold on
%plot(tilts,ydata*1.5,'o');

%%
% Test Side view
m.setKillZero(2);
hs = [-4 -3 -2 -1 0 1 2 3 4]';
ks = [2 2 2 2 2 2 2 2 2]';
xpos = [1:9]';

m.drawSideView(hs,ks,xpos,figure)
