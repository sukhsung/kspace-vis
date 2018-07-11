close all
clear all
%s =BLG('AC');
s= SLG;
s.draw3D;

b1 = s.b1;
b2 = s.b2;
title(' ')
k = gca;
k.CameraViewAngleMode = 'manual';
axis off
plot([b1(1),b1(1)+b2(1),b2(1),-b1(1),-(b1(1)+b2(1)),-b2(1),b1(1)],[b1(2),b1(2)+b2(2),b2(2),-b1(2),-(b1(2)+b2(2)),-b2(2),b1(2)],'k--')

t = erf(linspace(-3,3,130));
tp = (t+1)/2;
tn = -tp +1;

v= VideoWriter('BLG_K.avi','Uncompressed AVI');
open(v);


for i = tp*90
    view([i 90])
    drawnow
%     print('cur','-djpeg','-r150')
%     
%     writeVideo(v,imread('cur.jpg'));
end


for i = tn*90
    view([90 i])
    drawnow
%     print('cur','-djpeg','-r150')
%     
%     writeVideo(v,imread('cur.jpg'));
end

close(v)
