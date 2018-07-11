close all
clear all

% t = erf(linspace(-3,3,130));
% tp = (t+1)/2;
% tn = -tp +1;
% %realspace
% v= VideoWriter('BLG_R.avi','Uncompressed AVI');
% open(v);
a = 2.46;
a1 = a*[1; 0 ];
a2 = a*[cosd(60); sind(60)];
r1 = 1/3 * (a1+a2);
lamb = 3.07/2;

[pos, m,n] = indexedMeshGrid(30,a1,a2);

posA = pos;
pos1(:,1) = pos(:,1);
pos1(:,2) = pos(:,2);
pos1(:,3) = pos(:,3);
posA = [posA; pos1];



posB(:,1) = posA(:,1) +r1(1);
posB(:,2) = posA(:,2) +r1(2);
posB(:,3) = posA(:,3) +lamb;

posC(:,1) = posA(:,1) +2*r1(1);
posC(:,2) = posA(:,2) +2*r1(2);
posC(:,3) = posA(:,3) -lamb;

posAr2 = posA(:,1).^2 + posA(:,2).^2;
posBr2 = posB(:,1).^2 + posB(:,2).^2;
posCr2 = posC(:,1).^2 + posC(:,2).^2;

posA(posAr2> (6*a)^2,:) = [];
posB(posBr2> (6*a)^2,:) = [];
posC(posCr2> (6*a)^2,:) = [];

%[119,2,178]; [15,170,204];
%clA = ones(length(posA),1) * [119,2,178];
%clB = ones(length(posB),1) * [255 187 54];
clA = ones(length(posA),1) * [232 0 100];
clB = ones(length(posB),1) * [232 0 100];

figure
%set(gcf,'Position',[0 0 2000 2000])
hold on
scatter3(posA(:,1),posA(:,2),posA(:,3),150,clA/255,'.');
scatter3(posB(:,1),posB(:,2),posB(:,3),150,clB/255,'.');
%scatter3(posC(:,1),posC(:,2),posC(:,3),150,clB/255,'.');

axis equal
view([0 0])
return


axis equal off
k = gca;
k.CameraViewAngleMode = 'manual';

for i = tp*90
    view([i 90])
    drawnow
    print('cur','-djpeg','-r150')
    
    writeVideo(v,imread('cur.jpg'));
end


for i = tn*90
    view([90 i])
    drawnow
    print('cur','-djpeg','-r150')
    
    writeVideo(v,imread('cur.jpg'));
end

close(v)
