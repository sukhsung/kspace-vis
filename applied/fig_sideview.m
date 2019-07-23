

hks =[-1, 1;...
      -1, 0;...
       0, 0;...
       1, 0;...
       1,-1];
xpos = linspace(-1.5,1.5,5)';
   
fig = figure;%('visible','off');
fig.Units='inches';
fig.Position=[0,0,10,4];

fname_base = 'MoS2_';
stack = '2Hb';
g = MoS2(stack);
%stack = 'ABCABC';
%g = graphene(stack);
%stack = repmat(['AC'],1,1);
%numLayer =50;
%g.setNumLayer(numLayer);
g.setKillZero(2);
g.drawSideView(hks(:,1),hks(:,2),xpos,fig);


ax = gca;
ax.XLim = [min(xpos),max(xpos)];
ax.YLim = [-g.kzExtent, g.kzExtent];
title(ax,'');
ax.XAxis.TickLabels = [];
ax.YAxis.TickLabels = [];
ax.ZAxis.TickLabels = [];
axis(ax,'off')
ti = ax.TightInset;
ax.Position=[ti(1)+0.03 ti(2)+0.1 0.94-ti(3)-ti(1) 0.80-ti(4)-ti(2)];


fname = [fname_base,stack,'_sideview'];
%fname = ['MoS2_1Hb_sideview'];
%fname = ['MoS2_2Hbx',num2str(numLayer),'_sideview'];
%fname = 'graphne_1layers_sideview';
print('-dtiffn',fname,'-r300')
