

hks =[-1, 1;...
      -1, 0;...
       0, 0;...
       1, 0;...
       1,-1];
xpos = linspace(-1.5,1.5,5)';
   
fig = figure;%('visible','off');
fig.Units='inches';
<<<<<<< HEAD
fig.Position=[0,0,10,3.5];

g = graphene('ACAC');
%g = MoS2('2H');
=======
fig.Position=[0,0,8,3.3];

g = graphene('AC');
%g = MoS2('1H');
>>>>>>> a2a39cc88883145a247ce0683102c084fbec31a6
g.setKillZero(2);
g.drawSideView(hks(:,1),hks(:,2),xpos,fig);


ax = gca;
ax.XLim = [min(xpos),max(xpos)];
title(ax,'');
ax.XAxis.TickLabels = [];
ax.YAxis.TickLabels = [];
ax.ZAxis.TickLabels = [];
axis(ax,'off')
ti = ax.TightInset;
ax.Position=[ti(1)+0.03 ti(2)+0.05 0.94-ti(3)-ti(1) 0.90-ti(4)-ti(2)];