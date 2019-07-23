function [zo] = plot2Dgaussian(xi,yi,params)
    a      = params.a;
    b      = params.b;
    x0     = params.x0;
    y0     = params.y0;
    sigmax = params.sigmax;
    sigmay = params.sigmay;

    zo = a*exp(-((xi-x0).^2/2/sigmax^2 + (yi-y0).^2/2/sigmay^2)) + b;
    
end