% Test Suite
clear all
close all

%% Test Graphene

m = graphene('uTBG');
m.rnd = 2;
m.setTheta(0)

m.setTitle('');


m.setSpotcut(1);
% Test draw3D
drawHexagon = true;
m.draw3D(drawHexagon,figure);
% Test Tilt Pattern
m.setkeV(200);
m.setKillZero(1);
m.setIntensityFactor(1);
t_max= 23;
m.setTiltStart(-t_max*pi/180);
m.setTiltEnd(t_max*pi/180);
m.setTiltN(1024);
m.setTiltAxis(30);

%displaymode = 'kz';
displaymode = 'angle';
displaypattern = true;
kzmode = 'ewald';
%kzmode = 'constant';
[tiltrange, I] = m.getTiltSeries(kzmode, displaymode, displaypattern, figure);

% Test Side view
m.setKillZero(2);
hs = [-1 0 1]';
ks = [ 0 0 0]';
xpos = [-1 0 1]';

m.drawSideView(hs,ks,xpos,figure)

%% Test MoS2
m = MoS2('2HbxN');
m.setNumLayer(2)
%m.
m.setTitle('');

m.setSpotcut(2);
% Test draw3D
drawHexagon = true;
m.draw3D(drawHexagon,figure);

% Test Tilt Pattern
m.setkeV(200);
m.setKillZero(1);
m.setIntensityFactor(1);
t_max= 23;
m.setTiltStart(-t_max*pi/180);
m.setTiltEnd(t_max*pi/180);
m.setTiltN(1024);
m.setTiltAxis(30);

%displaymode = 'kz';
displaymode = 'angle';
displaypattern = true;
kzmode = 'ewald';
%kzmode = 'constant';
[tiltrange, I] = m.getTiltSeries(kzmode, displaymode, displaypattern, figure);

% Test Side view
m.setKillZero(2);
hs = [-1 0 1]';
ks = [ 0 0 0]';
xpos = [-1 0 1]';

m.drawSideView(hs,ks,xpos,figure)