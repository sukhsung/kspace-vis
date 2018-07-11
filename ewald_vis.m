
m = SLG;
m.setSpotcut(1)
m.setBW(true)
m.setBWColor(0.8275)
m.setKillZero(false)
m.draw3D;
hold on
b1 = m.b1;
b2 = m.b2;
keV =0.3;
k = eDiff_Wavenumber(keV);

plot([b1(1),b1(1)+b2(1),b2(1),-b1(1),-(b1(1)+b2(1)),-b2(1),b1(1)],[b1(2),b1(2)+b2(2),b2(2),-b1(2),-(b1(2)+b2(2)),-b2(2),b1(2)],'k--')

az = 152;
el = 10;

view([az el])

PHI = linspace(0,2*pi,100);
R= linspace(0,4,100);
[PHI,R] = meshgrid(PHI,R);

[X,Y] = pol2cart(PHI,R);


C(:,:,1) = zeros(size(X));
C(:,:,2) = ones(size(X));
C(:,:,3) = zeros(size(X));

Z = -sqrt(k^2 - (X.^2+Y.^2))+k;
s= surf(X,Y,real(Z),C);
s.EdgeColor = 'none';
s.FaceAlpha = 0.35;

s.FaceLighting = 'Gouraud';
axis equal off

phi = deg2rad(15);
%phi = 0;
k = eDiff_Wavenumber(keV);
theta = 0;
qzo = k*cos(phi);
qxo = k*sin(phi)*cos(theta);
qyo = k*sin(phi)*sin(theta);
kZ = qzo - sqrt(k^2 - (X-qxo).^2 - (Y-qyo).^2);
C(:,:,1) = ones(size(X));
C(:,:,2) = zeros(size(X));
C(:,:,3) = zeros(size(X));
s= surf(X,Y,real(kZ),C);
s.EdgeColor = 'none';
s.FaceAlpha = 0.35;
s.FaceLighting = 'Gouraud';

m.setkeV(keV)
m.setBWColor(0)
m.setTiltVal(0);
m.setRotation(0);
m.setKillZero(true)
m.drawEwald;

m.setTiltVal(phi);
%m.drawEwald;

ax = gca;
ax.Projection = 'perspective';

lgt=lightangle(180,135);
%camlight('headlight')
%camlight(180,70)
axis off;