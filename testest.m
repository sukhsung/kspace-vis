

hks =[-1, 1;...
      -1, 0;...
       0, 0;...
       1, 0;...
       1,-1];
xpos = (-2:2)';

f = figure;
g= graphene('AC');
for i = 0:0.1:1
    g.x = i;
    g.draw3D(f)
    view([15,30])
    drawnow
    pause
    clf
end