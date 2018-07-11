%function [x] =  lambda_fitting

%% gr20180402 (6 layer)
xdata = tilts_gr20180402;
ydata = abs(resM_gr20180402.sigmax.*resM_gr20180402.sigmay.*resM_gr20180402.a);
ydata = ydata([1,2,6],:);

% lambda, yscale, ytrans, xscale, xtrans, rotation
x0 = [3.346, 3.5e4,0,1,0,-50];
lb = [2, 0, -inf,1, -5,-60];
ub = [5,inf,inf,1,5,0];
tol = 1e-12;

%% gr xxx


%% calc

opts = optimset('Display','Iter','TolFun',tol,'TolX',tol);
[x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@varylambda,x0, xdata, ydata,lb,ub,opts);
ci = nlparci(x,residual,'jacobian',jacobian)

figure;
plot(xdata,ydata);
hold on;
plot(xdata,varylambda(x,xdata));
x(1)
x(2)
x(3)
x(4)
x(5)
%% fn

function [mag] = varylambda(x0,tilt)

    %% gr20180402 (6 layer)
    peak = [5,3,6];
    m = BLG('ABABAB');
    %% gr xxx
    m.setkeV(200);
    m.setSpotcut(1);
    m.setKillZero(1);
    m.setIntensityFactor(1);
    m.setRotation(x0(6)*pi/180);
    m.setKzMode('tilted_ewald');
    m.setLambda(x0(1));
    %[~,mag] = m.calculate;
    %mag = mag(peak).*conj(mag(peak));
    [tiltrange, I] = m.getTiltSeries('ewald','none',0, (tilt'*x0(4)+x0(5))*pi/180);
    %mag = I(1,:);
    %tiltrange = tiltrange *180/pi;
    yscale =x0(2);
    ytrans = x0(3);
    mag = I(peak,:)*yscale;
    mag = mag + ytrans;
end
