

hks =[-1, 1;...
      -1, 0;...
       0, 0;...
       1, 0;...
       1,-1];
xpos = (-2:2)';
   
fig = figure;%('visible','off');
fig.Units='inches';
%fig.Position=[0,0,10,3.5];

%g = graphene('B');
g = MoS2('2H');
g.setKillZero(2);
g.drawSideView(hks(:,1),hks(:,2),xpos,fig);


ax = gca;
ax.XLim = [min(xpos),max(xpos)];
title(ax,'');
% ax.XAxis.TickLabels = [];
% ax.YAxis.TickLabels = [];
% ax.ZAxis.TickLabels = [];
axis(ax,'off')
ti = ax.TightInset;
%ax.Position=[ti(1) ti(2) 0.97-ti(3)-ti(1) 0.95-ti(4)-ti(2)];