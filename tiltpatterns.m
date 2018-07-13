
stackings = {'A','AB', 'BA', 'AA','ABC','ABABABA','ABCABC'};
%stackings = {'AB'};
numStacking = length(stackings);

Rots = [30, 60] *pi/180;
numRot = length(Rots);
close all
fig = figure;%('visible','off');
fig.Units='inches';
fig.Position=[0,0,10,3.5];

m = BLG;
fname_base = 'Graphene_';

m.setkeV(300);
m.setSpotcut(1);
m.setKillZero(1);
m.setIntensityFactor(1);
m.setTiltStart(-25*pi/180);
m.setTiltEnd(25*pi/180);




for indstack = 1:numStacking
    stack = stackings{indstack};
    m.setStacking(stackings{indstack})
    
    for indRot = 1:numRot
        Rot = Rots(indRot);
        m.setRotation(Rots(indRot));
        [tiltrange, I] = m.getTiltSeries('ewald','angle',false,[],fig);
        title('')
        ax = gca;
        ax.XMinorTick = 'on';
        ax.YMinorTick = 'on';
        ax.XLim = [-25,25];
        ax.YLim = [0,1];
        ax.TickLength = [0.02 0.035];
        ax.XAxis.TickValues =-20:10:20;
        ax.XAxis.MinorTickValues = -20:5:20;
        ax.YAxis.TickValues = 0:0.5:1;
        ax.YAxis.MinorTickValues = 0:.25:1;
        ax.XAxis.TickLabels = [];
        ax.YAxis.TickLabels = [];
        ti = ax.TightInset;
        ax.Position=[ti(1) ti(2) 0.999-ti(3)-ti(1) 1-ti(4)-ti(2)];

        fname = [fname_base, stack,'_Rot_',num2str(rad2deg(Rot))];
        %print(fname,'-dtiffn','-r150')
        drawnow
        pause(0.1)
        cla
    end
end