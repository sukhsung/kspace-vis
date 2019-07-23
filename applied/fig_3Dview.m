
fig = figure;%('visible','off');
fig.Units='inches';
%fig.Position=[0,0,10,3.5];

fname_base = 'TaS2';
stack = '1T';
g = TaS2(stack);
%g=graphene(stack);
%stack = repmat(['AC'],1,1);
%numLayer =50;
%g.setNumLayer(numLayer);
g.setKillZero(2);
g.draw3D(true,fig);


ax = gca;
%ax.XLim = [min(xpos),max(xpos)];
%ax.YLim = [-g.kzExtent, g.kzExtent];
%title(ax,'');
%ax.XAxis.TickLabels = [];
%ax.YAxis.TickLabels = [];
%ax.ZAxis.TickLabels = [];
axis(ax,'off')
%ti = ax.TightInset;
%ax.Position=[ti(1)+0.03 ti(2)+0.1 0.94-ti(3)-ti(1) 0.80-ti(4)-ti(2)];


fname = ['3drd\',fname_base,stack,'_3D'];
%fname = ['MoS2_1Hb_sideview'];
%fname = ['MoS2_2Hbx',num2str(numLayer),'_sideview'];
%fname = 'graphne_1layers_sideview';
print('-r300','-dtiffn',fname)
