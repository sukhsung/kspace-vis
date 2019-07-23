function [results, data_im, fit_im] = analyzePattern( posxy, img, window_size )
%Analyze the diffraction spots in a single image of a diffraction pattern.
%posxy is the approximate diffraction spot position in the image
%img is the diffraction pattern image
%window_size is the pixel dimension of the box used around a spot
%By Adapted by Noah Schnitzer from Robert Hovden's analyzeSpots
%2018-07-29 adapted analyzeSpots to fit for a single image

    w = window_size;
    d = 2*w+1;
    
    data_im = zeros(d,d,size(posxy,1));
    fit_im = data_im;
    
    %data_im = zeros( d*ceil(sqrt(size(img_stack,3))), d*ceil(sqrt(size(img_stack,3))),size(posxy,1) );
    %fit_im  = zeros( d*ceil(sqrt(size(img_stack,3))), d*ceil(sqrt(size(img_stack,3))),size(posxy,1) );
    
    for i = 1:size(posxy,1) %Loop through each spot
        %for j = 1:size(img_stack,3) %Loop through all tilts
            spot = double( img( posxy(i,2)-w:posxy(i,2)+w, posxy(i,1)-w:posxy(i,1)+w) );
            [xi,yi] = meshgrid(1:size(spot,2),1:size(spot,1));
            results(i) = autoGaussianSurf(xi,yi,spot);
            
            %r = floor( (j-1) / ceil(sqrt(size(img_stack,3))) )*d+1;
            %c = mod( j-1, ceil(sqrt(size(img_stack,3)))   )*d+1;
            data_im(:,:, i) = spot;
            fit_im(:,:, i)  = plot2Dgaussian(xi,yi,results(i));
        %end
    end

end