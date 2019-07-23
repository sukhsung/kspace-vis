function [xy] = selectSpots( img )
%This function will open diffraction image (tiff) and allow the
%user to identify the local maxima in the image.
%
%
%   This code is part of the DiffSpot Analysis package
%   by Robert Hovden

    if ischar(img)
        img = imread(img,'tif');
    end
    
    %Get min and max values of dataset for displaying images
    immin = min(min(img(:,:,1)));
    immax = max(max(img(:,:,1)));
    
    %Display image
    scrsz = get(0,'ScreenSize'); %Grab monitor dimensions
    h = figure('Name', 'Diffraction Image', 'Position', [scrsz(3)/2 20 scrsz(3)*2/3 scrsz(3)/2]);
      %imshow( img( :,:,round(size(img,3)/2) ), [immin immax] );
      %imshow( sum(img,3)./size(img,3), [immin immax] );
      
      imagesc( (sum(img,3)./size(img,3)));
      
    %Select DiffSpots
    title 'Select Position(s) of diffraction spots - Right click on final spot'
    hold on
    % Initially, the list of points is empty.
    xy = [];
    n = 0;
    % Loop, picking up the points.
    disp('Left mouse button picks points.')
    disp('Right mouse button picks last point.')
    but = 1;
    while but == 1
        [xi,yi,but] = ginput(1);
        plot(xi,yi,'ro')
        n = n+1;
        xy(n,:) = [xi;yi];
    end

end