
% run single layer Graphene
s = SLG;
s.draw;

% run bilayer graphene
b = BLG; %Stacking is AB by default
b.draw;

% change to AA stacking
b.setStacking('AA')
b.draw;

% run 1H MoS2
m = MoS2; %1H Stacking by default
m.draw3D;

%  change to 1T
m.setStacking('1T')
m.draw3D;