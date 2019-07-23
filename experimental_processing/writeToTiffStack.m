function writeToTiffStack(im, fname)
    im = double(im);
    im = im-min(im(:));
    im = im/max(im(:));
    im = im*65535;
    im_out = im;

    int_stack = uint16(im_out);
    for i = 1:size(im,3)
        imwrite(((int_stack(:,:,i))),fname,'WriteMode','append')
    end
    

end