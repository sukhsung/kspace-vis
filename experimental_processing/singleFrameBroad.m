function singleFrameBroad(index,stack)
    
    posxy = selectSpots(stack);
    [res, resM, d_im, f_im] = analyzeSpots(posxy, stack, 32);
    pts = abs(resM.sigmay(:,index).*resM.sigmax(:,index));
    
    figure;
    plot(pts);
    
    
end