

close all

s = MoS2('1H');
s.setKillZero(30)
s.drawRod([-1,1;-1,0;0,0;1,0;1,-1])

axis([0, 6, -3,3])
pbaspect([2.5,1,1])