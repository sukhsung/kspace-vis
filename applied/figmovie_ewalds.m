close all
clear all
m = SLG;
m.setSpotcut(1)
m.setBW(true)
m.setBWColor(0.8275)
m.setKillZero(false)
m.draw3D;
hold on
ax = gca;
%ax.Projection = 'perspective';
ax.CameraViewAngleMode = 'manual';
ax.CameraPositionMode = 'manual';
ax.CameraTargetMode = 'manual';

b1 = m.b1;
b2 = m.b2;

plot([b1(1),b1(1)+b2(1),b2(1),-b1(1),-(b1(1)+b2(1)),-b2(1),b1(1)],[b1(2),b1(2)+b2(2),b2(2),-b1(2),-(b1(2)+b2(2)),-b2(2),b1(2)],'k--')

az = 152;
el = 10;

view([az el])

PHI = linspace(0,2*pi,100);
R= linspace(0,4,100);
[PHI,R] = meshgrid(PHI,R);

[X,Y] = pol2cart(PHI,R);

keV= 0.3;
k = eDiff_Wavenumber(keV);
theta = 0;

m.setkeV(keV)
m.setBWColor(0) 
m.setRotation(theta);
m.setKillZero(true)

lgt=lightangle(180,135);
t = erf(linspace(-2,2,130));
tp = (t+1)/2;
tn = -tp +1;

%phis = [tp*30-15, tn*30-15,tp*15-15];
phis = [-15:15,14:-1:-15,-15:0];
s=[];
mpl=[];

%v= VideoWriter('Ewald.avi','Uncompressed AVI');
%open(v);
for phi = deg2rad(phis)
    delete(s)
    delete(mpl)

    qzo = k*cos(phi);
    qxo = k*sin(phi)*cos(theta);
    qyo = k*sin(phi)*sin(theta);

    kZ = qzo - sqrt(k^2 - (X-qxo).^2 - (Y-qyo).^2);
    C(:,:,1) = zeros(size(X));
    C(:,:,2) = ones(size(X));
    C(:,:,3) = zeros(size(X));
    s= surf(X,Y,real(kZ),C);
    s.EdgeColor = 'none';
    s.FaceAlpha = 0.35;
    s.FaceLighting = 'Gouraud';

    m.setTiltVal(phi);
    mpl = m.drawEwald;

    axis([-4 4 -4 4 -2.5 2.5])

    axis off
    drawnow
  %  print('cur','-djpeg','-r150')
    
 %   writeVideo(v,imread('cur.jpg'));
end

keVs = [0.3:0.1:1];

for keV = keVs
    delete(s)
    delete(mpl)
    
    m.setkeV(keV)
    k = eDiff_Wavenumber(keV);
    qzo = k*cos(phi);
    qxo = k*sin(phi)*cos(theta);
    qyo = k*sin(phi)*sin(theta);


    kZ = qzo - sqrt(k^2 - (X-qxo).^2 - (Y-qyo).^2);
    C(:,:,1) = zeros(size(X));
    C(:,:,2) = ones(size(X));
    C(:,:,3) = zeros(size(X));
    s= surf(X,Y,real(kZ),C);
    s.EdgeColor = 'none';
    s.FaceAlpha = 0.35;
    s.FaceLighting = 'Gouraud';

    m.setTiltVal(phi);
    mpl = m.drawEwald;
    axis([-4 4 -4 4 -2.5 2.5])
    axis off

    drawnow
  %  print('cur','-djpeg','-r150')
    
 %   writeVideo(v,imread('cur.jpg'));
end

phis = [0:-1:-15,-15:15,15:-1:0];
keV= 1;
    m.setkeV(keV)
    k = eDiff_Wavenumber(keV);
for phi = deg2rad(phis)
    delete(s)
    delete(mpl)

    qzo = k*cos(phi);
    qxo = k*sin(phi)*cos(theta);
    qyo = k*sin(phi)*sin(theta);

    kZ = qzo - sqrt(k^2 - (X-qxo).^2 - (Y-qyo).^2);
    C(:,:,1) = zeros(size(X));
    C(:,:,2) = ones(size(X));
    C(:,:,3) = zeros(size(X));
    s= surf(X,Y,real(kZ),C);
    s.EdgeColor = 'none';
    s.FaceAlpha = 0.35;
    s.FaceLighting = 'Gouraud';

    m.setTiltVal(phi);
    mpl = m.drawEwald;

    axis([-4 4 -4 4 -2.5 2.5])

    axis off
    drawnow
   % print('cur','-djpeg','-r150')
    
 %   writeVideo(v,imread('cur.jpg'));
end

keVs = [1:-0.1:.3];

for keV = keVs
    delete(s)
    delete(mpl)
    
    m.setkeV(keV)
    k = eDiff_Wavenumber(keV);
    qzo = k*cos(phi);
    qxo = k*sin(phi)*cos(theta);
    qyo = k*sin(phi)*sin(theta);


    kZ = qzo - sqrt(k^2 - (X-qxo).^2 - (Y-qyo).^2);
    C(:,:,1) = zeros(size(X));
    C(:,:,2) = ones(size(X));
    C(:,:,3) = zeros(size(X));
    s= surf(X,Y,real(kZ),C);
    s.EdgeColor = 'none';
    s.FaceAlpha = 0.35;
    s.FaceLighting = 'Gouraud';

    m.setTiltVal(phi);
    mpl = m.drawEwald;
    axis([-4 4 -4 4 -2.5 2.5])
    axis off

    drawnow
  % print('cur','-djpeg','-r150')
    
 %   writeVideo(v,imread('cur.jpg'));
end
%close(v)