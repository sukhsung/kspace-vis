%test = load_20180402_HBN_DiffTilt();

%[stack_hbn20180402, tilts_hbn20180402, res_hbn20180402, resM_hbn20180402, d_im_hbn20180402, f_im_hbn20180402, posxy_hbn20180402] = load_20180402_HBN_DiffTilt();

%load('mat_20180402_HBN_DiffTilt.mat');
[kx,ky,kz, rad_per_ang_per_px] = tilt_to_k (resM_hbn20180402, posxy_hbn20180402, 200, tilts_hbn20180402, 117, [1,2,3,4,5,6], 2.5 );
%[splined, kz_stack] = buildKzStack (resM_gr20180402, kx, ky, kz, 'gr_out_1.tif', .01, 10, .01 , rad_per_ang_per_px );
%extract_broadening (kz,resM_hbn20180402);



%plotting_20180402_HBN_DiffTilt(resM, tilts);

function plotting_20180402_HBN_DiffTilt(resM, tilts)
    int = abs(resM.a .* resM.sigmax .* resM.sigmay);
    intnorm = int - min(int(:));
    intnorm = intnorm ./ max(int(:));
    figure;
    indices = [15];
    plot(tilts(:), intnorm(indices,:), 'LineWidth',3);



end


function [stack_hbn20180402, tilts_hbn20180402, res_hbn20180402, resM_hbn20180402, d_im_hbn20180402, f_im_hbn20180402, posxy_hbn20180402] = load_20180402_HBN_DiffTilt()
    workingDirBN = '/Users/noah/Documents/hlab/data/20180117_2D_reciprocal_space/20180402_HBN_DiffTilt';
    imDim = 2048;
    
    dirs = dir(workingDirBN);
    count = 0;
    tilts_hbn20180402 = [];
    stack_hbn20180402 = [];
    
    for i = 3:length(dirs)
       name = dirs(i).name;
       if length(name) >= 7 && name(1) == 'B' && length(name) < 12 
        count = count+1;
       end
    end
    stack_hbn20180402 = zeros(imDim,imDim,count);
    tilts_hbn20180402 = zeros(count,1);
    %nameszz = {}%zeros(count,1);

    count = 0;

    for i = 3:length(dirs)
       name = dirs(i).name;
       if length(name) >= 7 && name(1) == 'B' && length(name) < 12 
          %name 
          %count = count + 1;
          path = [workingDirBN '/' name '/Hour_00/Minute_00' ];
          subdirs = dir(path);
          for j = 3:3%length(subdirs)
             subdir_name = subdirs(j).name;

             files =  dir([path  '/' subdir_name]);
             
             for k = 3: 3%length(files)
                 count = count + 1;
                fname = files(k).name;
                %reader = bfGetReader([ path  '/' subdir_name '/' fname  ]);
                [Tx] = ReadDMFile([ path  '/' subdir_name '/' fname  ], 'log.txt');
                A = fopen('log.txt');
                a = textscan(A, '%s');
                list = strfind(a{1}, 'Alpha');
                ind = find(not(cellfun('isempty', list)))+1;
                alpha = str2double(a{1}(ind));%a{1}(not(cellfun('isempty', list))+1)
                %alpha = a(ind);
                

                list = strfind(a{1}, 'Beta');
                ind = find(not(cellfun('isempty', list)))+1;
                beta = str2double(a{1}(ind));%a{1}(not(cellfun('isempty', list))+1)   
                tilts_hbn20180402(count)= beta;%[tilts, beta];
                %nameszz{end+1} = i;
                fclose(A);
                img = bfopen([ path  '/' subdir_name '/' fname  ]);
                stack_hbn20180402(:,:,count) = img{1}{1};
                
                %{1}:{imdata}, {path}
                %{2}:{tags} (original metadata)
                %{3}:??? 0x0
                %{4}: OME metadata
                
             end
             
          end
       end
    end
    
    
    [tilts_hbn20180402, sort_indices] = sort(tilts_hbn20180402);
    stack_hbn20180402 = stack_hbn20180402(:,:,sort_indices);
    
    
    
    [posxy_hbn20180402] = selectSpots( stack_hbn20180402 );
    [res_hbn20180402, resM_hbn20180402, d_im_hbn20180402, f_im_hbn20180402] = analyzeSpots(posxy_hbn20180402, stack_hbn20180402, 32); %positions, dataset, window size
    save('mat_20180402_HBN_DiffTilt.mat', 'stack_hbn20180402', 'tilts_hbn20180402', 'res_hbn20180402', 'resM_hbn20180402', 'd_im_hbn20180402', 'f_im_hbn20180402', 'posxy_hbn20180402');
end

