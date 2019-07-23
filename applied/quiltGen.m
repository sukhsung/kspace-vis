g = MoS2;
f= figure;
g.draw3D(f);

ax = f.CurrentAxes;
ax.View(1) = 90;


camPos = ax.CameraPosition;
x0 = camPos(1); y0 = camPos(2); z0 = camPos(3);
r0  = sqrt(x0^2 + y0^2 + z0^2);
el0 = acos(z0/r0);
az0 = atan2(y0,x0);

th_max = deg2rad(20);
numIm = 45;


for th = linspace(-th_max,th_max,numIm)
    el = el0;
    az = az0+th;
    r  = r0/cos(az);
    
    x = r*sin(el)*cos(az);
    y = r*sin(el)*sin(az);
    z = r*cos(th);
    
    ax.CameraPosition = [x,y,z];
    drawnow
    title(rad2deg(az))
    pause
end

