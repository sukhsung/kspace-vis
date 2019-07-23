%%
load('mat_20180913_1TprimeMoS2_DiffTilt.mat');

%%
outliers = zeros(36,1475);
outliers(:,tilts(:,2)==2.7) = 1;
%outliers(,

peaks = [1:6,10,17];%[1:7,9:12,15,17,20];

plot_experimental(resM, tilts(:,2), peaks, 1:1475, 0, 1 , [1 1],[0 0], outliers);

%%
x = [];
y= [];
z= [];
figure;
for i = peaks
    
    %for j = 1:size(fits,1)
       posx = posxy(i,1);
       posy = posxy(i,2);
       range = resM.a(i,outliers(i,:)<1) > 1*resM.b(i,outliers(i,:)<1);
       %sum(range)
       x = [x, posx + resM.x0(i,outliers(i,range)<1) - resM.x0(2,outliers(2,range)<1)];
       y = [y, posy + resM.y0(i,outliers(i,range)<1) - resM.y0(2,outliers(2,range)<1)];
       z = [z; tilts(outliers(i,range)<1,2)];
       text(posx,posy,num2str(i),'FontSize',14);
       hold on;
    %end
end
scatter3(x,y,z*30,'.');
axis equal;
%%
[kx,ky,kz, rad_per_ang_per_px] = tilt_to_k(resM, posxy, 200, tilts(:,2), 300, [4,3,2,1,6,5], 3.161);

%%
figure;
plot(kz(:),resM.sigmax(:).*resM.sigmay(:),'.');

%%

resM_avg = struct('a',[],'b',[],'x0',[],'y0',[],'sigmax',[],'sigmay',[]);
curr_tilt = -1e5;
for i = 1:size(tilts,1)
    if tilts(i) == curr_tilt
        resM_avg.a(:,end) = resM_avg.a(:,end) + resM(:,i);
    else
        resM_avg.a(:,end) = resM_avg.a(:,end);
    end
    
end


[tilts_avg, ia, ic ]= unique(tilts(:,2));



figure;plot(tilts_avg,resM.a(:,ia),'.');
return;
%%
working_dir = '/Users/noah/Documents/hlab/data/20180911_1TprimeMoS2_NS_17/tilts';
dirs = dir(working_dir);

tilts = [];
fits = [];
posxy = [];
order = {};
count = 0;
posimg = bfopen(['/Users/noah/Documents/hlab/data/20180911_1TprimeMoS2_NS_17/tilts/1t_prime_MoS2_tilt__1/Hour_00/Minute_00/Second_00/1t_prime_MoS2_tilt__1_Hour_00_Minute_00_Second_00_Frame_0002.dm4' ]);
posxy = selectSpots(posimg{1}{1});


resM = struct('a',[],'b',[],'x0',[],'y0',[],'sigmax',[],'sigmay',[]);

for i = 3:length(dirs)
   name = dirs(i).name;
   if  name(1:20) == '1t_prime_MoS2_tilt__'
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
            %fits = [fits; results];
            
            resM.a = cat(2,resM.a,[results.a]');
            resM.b = cat(2,resM.b,[results.b]');
            resM.x0 = cat(2,resM.x0,[results.x0]');
            resM.y0 = cat(2,resM.y0,[results.y0]');
            resM.sigmax = cat(2,resM.sigmax,[results.sigmax]');
            resM.sigmay = cat(2,resM.sigmay,[results.sigmay]');
            
         end

      end
   end
end

save('fit_out.mat','tilts','resM','posxy');