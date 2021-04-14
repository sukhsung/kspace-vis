% Test Suite
clear all
close all

%% Test CrSBr

m = CrSBr();
m.numLayer=1;

m.setTitle('');
m.setKzExtent( 4*pi/m.lambda )

m.setSpotcut(3);
%% Test draw3D
drawRect = true;
m.draw3D(drawRect,figure);
view([25, 32])

%% Test Tilt Pattern
m.setkeV(200);
m.setKillZero(1);
m.setIntensityFactor(1);
t_max= 30;
m.setTiltStart(-t_max*pi/180);
m.setTiltEnd(t_max*pi/180);
m.setTiltN(1024);
m.setTiltAxis(deg2rad(90));

%displaymode = 'kz';
displaymode = 'angle';
displaypattern = true;
kzmode = 'ewald';
%kzmode = 'constant';
hs = [2  2 0 -2 -2 2 -2]';
ks = [2 -2 0  2 -2 0  0]';
[tiltrange, I] = m.getTiltSeriesHK(hs,ks, kzmode,displaymode, displaypattern, figure);

%%
% Test Side view
m.setKillZero(2);
hs = [2 1 0 0 0 1]';
ks = [0 0 0 1 2 1]';
xpos = [-2 -1 0 1 2 3 ]';

m.drawSideView(hs,ks,xpos,figure)
