function [dsigma_dkz,broad,strain] = extract_broadening (kz,resM,rad_per_ang_per_px)

    figure;
    %peaks = 1:16;
    %peaks(2) = [];
    
    peaks = 1:size(resM.sigmax,1);
    slices = 1:size(resM.sigmax,2);
    
    for peak = peaks
        subplot(4,4,peak);
        plot(kz(peak,slices),rad_per_ang_per_px*resM.sigmax(peak,slices));
        title(['sigmax' num2str(peak)]);
        hold on
    end
    figure;
    for peak = peaks
        subplot(4,4,peak);
        plot(kz(peak,slices),rad_per_ang_per_px*resM.sigmay(peak,slices));
        title(['sigmay' num2str(peak)]);
        hold on
    end
    full_length = length(slices);
    meas_length = [ceil(3/4*full_length), ceil(1/4*full_length)];
    zero_length = ceil(1/2*full_length);
    dsigma_dkz = rad_per_ang_per_px*(resM.sigmax(:,meas_length)-resM.sigmax(:,zero_length)) ./ (kz(:,meas_length)-kz(:,zero_length)) + rad_per_ang_per_px*(resM.sigmay(:,meas_length)-resM.sigmay(:,zero_length)) ./ (kz(:,meas_length)-kz(:,zero_length));
    dsigma_dkz = abs(dsigma_dkz);
    dsigma_dkz = mean(dsigma_dkz,2);
    center = median(dsigma_dkz);
    dev = std(dsigma_dkz);
    broad = center;%mean(dsigma_dkz(dsigma_dkz > center - dev & dsigma_dkz < center + dev));
    strain = 1/cos(atan(broad))-1;
    

end