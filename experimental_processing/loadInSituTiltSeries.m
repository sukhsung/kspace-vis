function [stack, tilts] = loadInSituTiltSeries()
    %workingDir = '/Users/noah/Documents/hlab/data/20180117_2D_reciprocal_space/20180310_Graphene_Diffraction_Tilt_80keV/tiff_images';
    workingDirBN = '/Users/noah/Documents/hlab/data/20180117_2D_reciprocal_space/20180402_HBN_DiffTilt';
    workingDirGr = '/Users/noah/Documents/hlab/data/20180117_2D_reciprocal_space/20180402_Graphene_DiffTilt';
    workingDir = workingDirBN;
    imDim = 2048;
    
    
    Files=dir([workingDir '/' '*.*']);
    count = 0;
    stack = zeros(imDim,imDim,length(Files)-2);
    tilts = zeros(2,length(Files)-2);
    
    %pre = '0_4s_';  %....0_4s_[tiltA]_[tiltB](_/.)...
    
    
    for i = 3:length(Files)
       fname= Files(i).name;
       %time_kV_mag_bright_spot_alpha_$alpha$_beta_$beta$_$diffraction/overview$_...
       %substring from alpha->
       
       sub1 = fname(strfind(fname, 'alpha')+6:length(fname));
       alpha_end = strfind(sub1,'_');
       alpha = str2double(sub1(1:alpha_end-1));
       
       sub2 = sub1(strfind(sub1,'beta')+5: length(sub1) );
       beta_end = strfind(sub2,'_');
       beta = str2double(sub2(1:beta_end-1));
       
       sub3 = sub2(beta_end+1:length(sub2));
       if(length(sub3)>0)
            if(sub3(1)=='d')
                count = count+1;
                stack(:,:,count) = imread([workingDir '/' fname]);
                tilts(:,count)=[alpha,beta];
                    display(fname)
    display(alpha)
    display(beta)
    display('    ')
            end

       end
       

    end
    stack = stack(:,:,1:count);
    tilts = tilts(:,1:count);

end
