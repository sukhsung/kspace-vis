% Test Suite
clear all
close all

%% Test CrSBr

m = CrSBr();
m.numLayer=2;

m.setTitle('');
m.setKzExtent( 4*pi/m.lambda )

m.setSpotcut(2);
% Test draw3D
drawRect = true;
m.draw3D(drawRect,figure);

%% Test Tilt Pattern
m.setkeV(200);
m.setKillZero(1);
m.setIntensityFactor(1);
t_max= 23;
m.setTiltStart(-t_max*pi/180);
m.setTiltEnd(t_max*pi/180);
m.setTiltN(1024);
m.setTiltAxis(deg2rad(0));

%displaymode = 'kz';
displaymode = 'angle';
displaypattern = true;
kzmode = 'ewald';
%kzmode = 'constant';
[tiltrange, I] = m.getTiltSeries(kzmode, displaymode, displaypattern, figure);

%%
% Test Side view
m.setKillZero(2);
hs = [-1 0 1]';
ks = [ 0 0 0]';
xpos = [-1 0 1]';

m.drawSideView(hs,ks,xpos,figure)
