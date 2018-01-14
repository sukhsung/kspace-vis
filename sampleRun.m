
% run single layer Graphene
s = SLG;
s.draw;

% run bilayer graphene
b = BLG; %Stacking is AB by default
b.draw;

% change to AA stacking
b.setStacking('AA')
b.draw;