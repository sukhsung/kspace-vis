x = [];
y = [];
figure;

sig = [];
a = [];
b = [];
px = [];
py = [];

peaks = [8,14 ];

for i = peaks
    for j = 1:size(fits,1)
        sig(j,i) =  fits(j,i).sigmax .* fits(j,i).sigmay;
        sigy(j,i) = fits(j,i).sigmay;
        sigx(j,i) = fits(j,i).sigmax;
        a(j,i) = fits(j,i).a;
        b(j,i) = fits(j,i).b;
        px(j,i) = fits(j,i).x0;
        py(j,i) = fits(j,i).y0;

    end
end
rel_tilt = tilts(:,2);
outliers = a.*sig > 2e5 | b.*sig > 1e3 | b.*sig < -50;
outliers = sum(outliers,2);
plot(outliers,'.')

for i = peaks
    plot(rel_tilt(outliers<1)-1.5,a(outliers < 1,i).*sig(outliers < 1,i),'.');
    hold on;
end
x = [];
y= [];
z= [];
figure;
for i = peaks
    
    %for j = 1:size(fits,1)
       posx = posxy(i,1);
       posy = posxy(i,2);
       x = [x; posx + px(outliers<1,i)];
       y = [y; posy + py(outliers<1,i)];
       z = [z; rel_tilt(outliers<1)];
       text(posx,posy,num2str(i));
       hold on;
    %end
end
scatter3(x,y,z,'.');

resM.sigmax = sigx(outliers<1,:)';
resM.sigmay = sigy(outliers<1,:)';
resM.x0 = px(outliers < 1,:)';
resM.y0 = py(outliers < 1,:)';
resM.a = px(outliers<1,:)';
resM.b = px(outliers<1,:)';

[kx,ky,kz, rad_per_ang_per_px] = tilt_to_k (resM, posxy, 200, rel_tilt(outliers<1), 110, [1:6], 3.161 );
return;
for i = 1:size(fits,2)
    y = [];
    for j = 1:size(fits,1)
            y = [y, fits(j,i).b .* fits(j,i).sigmax .* fits(j,i).sigmay]; 
    end
    plot(tilts(:,2),y,'.');
    hold on;
end




x = [];
y= [];
figure;
for i = 1:size(fits,2)
    for j = 1:size(fits,1)
       posx = posxy(i,1);
       posy = posxy(i,2);
       x = [x, posx + fits(j,i).x0];
       y = [y, posy + fits(j,i).y0];
    end
end
scatter(x,y,'.');
return;

working_dir = '/Volumes/Noah/20180726_MoS2_Diffraction_Tilt/';
dirs = dir(working_dir);

tilts = [];
fits = [];
posxy = [];
order = {};
count = 0;
posimg = bfopen([ '/Volumes/Noah/20180726_MoS2_Diffraction_Tilt/beta_tilt_396/Hour_00/Minute_00/Second_01/beta_tilt_396_Hour_00_Minute_00_Second_01_Frame_0001.dm4' ]);
posxy = selectSpots(posimg{1}{1});

for i = 3:length(dirs)
   name = dirs(i).name;
   if  name(1:5) == 'beta_'
      order{end+1} = name;
      path = [working_dir '/' name '/Hour_00/Minute_00' ];
      subdirs = dir(path);
      for j = 3:length(subdirs)
         subdir_name = subdirs(j).name;

         files =  dir([path  '/' subdir_name]);

         for k = 3: length(files)
            fname = files(k).name;
            [Tx] = ReadDMFile([ path  '/' subdir_name '/' fname  ], 'log.txt');
            A = fopen('log.txt');
            a = textscan(A, '%s');
            list = strfind(a{1}, 'Alpha');
            ind = find(not(cellfun('isempty', list)))+1;
            alpha = str2double(a{1}(ind));%a{1}(not(cellfun('isempty', list))+1)
            list = strfind(a{1}, 'Beta');
            ind = find(not(cellfun('isempty', list)))+1;
            beta = str2double(a{1}(ind));%a{1}(not(cellfun('isempty', list))+1)   
            tilts = [tilts; alpha beta];
            fclose(A);
            count = count + 1
            img = bfopen([ path  '/' subdir_name '/' fname  ]);
            img = img{1}{1};
            
            if size(posxy)== [0 0]
               posxy = selectSpots(img); 
            end
            [results, data_im, fit_im] = analyzePattern( posxy, img, 128 );
            fits = [fits; results];
         end

      end
   end
end

%save('fit_out.mat','tilts','fits','posxy');