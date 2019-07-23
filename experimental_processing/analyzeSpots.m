function [results resM data_im fit_im] = analyzeSpots( posxy, img_stack, window_size )
%Analyze the diffraction spots in an image stack.
%posxy is the approximate diffraction spot position in the stack
%img_stack is the diffraction pattern image stack
%window_size is the pixel dimension of the box used around a spot
%By Robert Hovden

    %Get min and max values of dataset for displaying images
    immin = min(min(img_stack(:,:,1)));
    immax = max(max(img_stack(:,:,1)));
    
    w = window_size;
    d = 2*w+1;
    scrsz = get(0,'ScreenSize'); %Grab monitor dimensions
    data_im = zeros( d*ceil(sqrt(size(img_stack,3))), d*ceil(sqrt(size(img_stack,3))),size(posxy,1) );
    fit_im  = zeros( d*ceil(sqrt(size(img_stack,3))), d*ceil(sqrt(size(img_stack,3))),size(posxy,1) );
    for i = 1:size(posxy,1) %Loop through each spot
        %h1 = figure('Name', ['Data: ' num2str(i)], 'Position', [scrsz(3)/2 20 scrsz(3)*2/3 scrsz(3)/2]);
        %h2 = figure('Name', ['Fit: '  num2str(i)], 'Position', [scrsz(3)/2 20 scrsz(3)*2/3 scrsz(3)/2]);
        for j = 1:size(img_stack,3) %Loop through all tilts
            spot = double( img_stack( posxy(i,2)-w:posxy(i,2)+w, posxy(i,1)-w:posxy(i,1)+w ,j) );
            [xi,yi] = meshgrid(1:size(spot,2),1:size(spot,1));
            results(i,j) = autoGaussianSurf(xi,yi,spot);
            
            r = floor( (j-1) / ceil(sqrt(size(img_stack,3))) )*d+1;
            c = mod( j-1, ceil(sqrt(size(img_stack,3)))   )*d+1;
            data_im(r:r+d-1,c:c+d-1, i) = spot;
            fit_im(r:r+d-1,c:c+d-1, i)  = plot2Dgaussian(xi,yi,results(i,j));
            %figure(h1); subplot(7,9,j);
            %imshow( spot, [immin immax] );
            %figure(h2); subplot(7,9,j);
            %imshow( plot2Dgaussian(xi,yi,results(i,j)), [immin immax] );
        end
    end
    
    for i = 1:size(results,1)
        for j = 1:size(results,2)
            resM.a(i,j) = results(i,j).a;
            resM.b(i,j) = results(i,j).b;
            resM.sigmax(i,j) = results(i,j).sigmax;
            resM.sigmay(i,j) = results(i,j).sigmay;
            resM.x0(i,j) = results(i,j).x0;
            resM.y0(i,j) = results(i,j).y0;
            resM.sum(i,j)= results(i,j).sum;
        end
    end
    
end