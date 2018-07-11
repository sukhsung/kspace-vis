function relin = f2f1(stacking)
    kev= 80;
    [ K ] = eDiff_Wavenumber( kev );
    b = 2.9409;
    
    kz1 = K-sqrt(K^2 -b^2);
    kz2 = K-sqrt(K^2 -(sqrt(3)*b)^2);
    lambda = 3.346;
    
    f1 = 0;
    f2 = 0;
    for n = 1:numel(stacking)
        cur_stack = stacking(n);
        f1 = f1 + fg_hk(1,0,cur_stack).*exp(-1i*kz1*lambda*(n));
        f2 = f2 + fg_hk(1,2,cur_stack).*exp(-1i*kz2*lambda*(n));
    end
    f1 = f1* eDiff_ScatteringFactor(6, b/(2*pi));
    f2 = f2 *eDiff_ScatteringFactor(6, sqrt(3)*b/(2*pi));
    in1 = f1.*conj(f1);
    in2 = f2.*conj(f2);
    
    
    relin = in2/in1;
    
    
    
end

function fg = fg_hk(h,k,stack)
    fg = 1+exp(-2i*pi/3*(h+k));
    if strcmp(stack,'A')
        fg = fg;
    elseif strcmp(stack,'B')
        fg = fg.*exp(-2i*pi/3*(h+k));
    elseif strcmp(stack,'C')
        fg = fg.*exp(2i*pi/3*(h+k));
    end
end