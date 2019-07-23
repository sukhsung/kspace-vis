%stack = loadImageSeries('02_DS_SA1_01_', 'deg.tif', 0:.5:15);
%[stack,tilts] = loadTiltSeries();
%for tiltangle = -100:10:100
%[stack, tilts] = loadTemsimSeries();
%posxy = selectSpots(stack);



%[res resM d_im f_im] = analyzeSpots(posxy, stack, 32);


outlier = removeOutliers(resM, 1,2,1,1);
for i = 1:size(resM.x0,1)
    figure('Color','w'); hold on; box on;
    scatter(resM.y0(i,outlier(i,:)>0),  resM.x0(i,outlier(i,:)>0),'r');
    scatter(resM.y0(i,outlier(i,:)==0), resM.x0(i,outlier(i,:)==0),'b');
    c = polyfit(resM.y0(i,outlier(i,:)==0),resM.x0(i,outlier(i,:)==0),1);
    x = min(resM.y0(i,:)):.1:max(resM.y0(i,:));
    plot( x, c(2)+c(1)*x );
end

imwrite(uint16(d_im(:,:,1)), 'd_im.tif', 'tif');
imwrite(uint16(f_im(:,:,1)), 'f_im.tif', 'tif');

% figure;
% plot(1:58,(abs(resM.a.*(outlier==0))+abs(resM.b.*(outlier==0)))');
% figure;
% plot(1:58,(abs(resM.a.*(outlier==0)))');
% figure;
% plot(1:58,(abs(resM.b.*(outlier==0)))');

len = size(tilts,2);

int = abs(resM.a .* resM.sigmax .* resM.sigmay);
% intnorm = int;
% int1 = int(1,:);
% for i = 1:4
%     intnorm(i,:) = intnorm(i,:)./int1;
% end
%avg across whole spot grid
%int = abs(resM.sum);
%int = abs(resM.a);
%normalizing
intnorm = int - min(int(:));
intnorm = intnorm ./ max(int(:));


% intnorm = int;
% mean1 = mean(int(1,:));
% for i = 1:size(int,1)
%    intnorm(i,:) = intnorm(i,:)./mean1;%./mean(intnorm(i,:));
% end

% intnorm = int;
% for i = 1:size(intnorm,1)
%    intnorm(i,:) = intnorm(i,:) - min(intnorm(i,:));
%    intnorm(i,:) = intnorm(i,:)/ max(intnorm(i,:));
% end



%exp
%figure
%plot(tilts(1,8:50),           intnorm(:,8:50));
% figure
% plot(tilts(1,:),           intnorm(:,:).*(cos(deg2rad(tilts(1,:)))));

%figure
%plot(tilts(1,:),intnorm);

% sim
% figure
% plot(tilts(1,:)*180/(1000*pi), intnorm(:,:), 'LineWidth',3);
% title(num2str(tiltangle));

%new sim
% figure
% plot(tilts(1,:),intnorm(:,:).*cosd(tilts(1,:)),'LineWidth',3);

% 
%end