function plot_experimental_kz(resM, kzs, peak_range, kz_range, normalize, new_fig , stretches,translations, outliers,colors)

    if new_fig
       figure; 
       hold on;
    else
        hold on;
    end

    intensity = abs(resM.sigmax.*(outliers==0).*resM.sigmay.*resM.a);
    intensity = intensity(peak_range,kz_range);
    kzs = kzs(:,kz_range);
    kzs = kzs(peak_range,:);
    if normalize
       
        intensity = intensity - min(intensity(:));
        intensity = intensity ./ max(intensity(:));
        
    end
    intensity = intensity .* stretches(2);
    kzs = kzs .* stretches(1);
    intensity = intensity + translations(2);
    kzs = kzs+translations(1);
    
    for it = 1:length(peak_range)
       %peak_it = peak_range(it);
       plot(kzs(it,:), intensity(it,:),'o','MarkerSize',7,'Color', colors(it,:));
    end
    
    
    
    %legend(sprintfc('%d',peak_range)); % https://www.mathworks.com/matlabcentral/answers/286544-how-i-could-convert-matrix-double-to-cell-array-of-string

end