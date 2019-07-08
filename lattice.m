clear; close all;
%defining basis vectors
theta = -30*pi/180;
b1 = [cos(theta) -sin(theta); sin(theta) cos(theta)]*[1;0];
b2 = [0;1];

%building grid of lattice points
grid = linspace(-2,2,5);
[h, k] = meshgrid(grid,grid);
h = h(:);
k = k(:);

%%

figure;scatter((b1(1)+b2(1))*h,b1(2)+b2(2)*k);

%%

% selecting second orders
x_less_y = abs(h - k);
x_each_y = abs(h) + abs(k);


% % grid_x = grid_x(xy < 3);
% % grid_y = grid_y(xy < 3);

%calculating lattice positions
pos_x = b1*h';
pos_y = b2*k';
pos = pos_x+pos_y;

dist = sqrt(pos(1,:).^2 + pos(2,:).^2);
%selector = dist > 0 & dist < 2.01;
selector_1 = dist > 0 & dist < 1.01; %1st circle
selector_2 = dist > 1 & dist < 2.01; %2nd circle
 %x_each_y > 0 & x_less_y < 3 ;
C_1 = 200/255 .* ones(sum(selector_1),3);
C_2 = 200/255 .* ones(sum(selector_2),3);
sz = 5000; %2500
figure; scatter(pos(1,selector_1), pos(2,selector_1),sz,C_1,'filled');
hold on;
scatter(pos(1,selector_2), pos(2,selector_2),sz, C_2,'filled','diamond');

%%
scatter(pos(1,13),pos(2,13),2*sz, 200/255*[1 1 1], 'filled');
scatter(pos(1,7),pos(2,7),sz, 1/255*[0 134 192], 'filled');
scatter(pos(1,12),pos(2,12),sz, 1/255*[0 201 169], 'filled');
scatter(pos(1,8),pos(2,8),sz, 1/255*[119 108 193], 'filled');
lim =1.1;
xlim([-lim lim]);
ylim([-lim lim]);
axis  off;
axis equal;

%%
idxs = [8 18 14 12 17 9];
%         colors(6,:) = [0 134 192]/255;
%         colors(14,:) = [0 201 169]/255;
%         colors(11,:) = [99 129 39]/255;
%         colors(9,:) = [174 101 44]/255;
%         colors(13,:) = [119 108 193]/255;
%         colors(7,:) = [255 109 174]/255;
% 
colors = [0 134 192; 0 201 169; 99 129 39; 174 101 44; 119 108 193; 255 109 174]/255;
shape = {'o','o','o','o','diamond','diamond'};

scatter(pos(1,13),pos(2,13),2*sz, 200/255*[1 1 1], 'filled');

for it = 1:length(idxs)
    idx = idxs(it);
    color = colors(it,:);
    scatter(pos(1,idx), pos(2,idx),sz,color,'filled',shape{it});
end
axis equal off;

%% MoS2

idxs = [23 17 24 12 ];
%         colors(6,:) = [0 134 192]/255;
%         colors(14,:) = [0 201 169]/255;
%         colors(11,:) = [99 129 39]/255;
%         colors(9,:) = [174 101 44]/255;
%         colors(13,:) = [119 108 193]/255;
%         colors(7,:) = [255 109 174]/255;
% 
%225m 114m 52
colors = [0 134 192; 0 201 169;  242.2500  109.6500   33.1500; 119 108 193]/255; %0.8500    0.3250    0.0980
shape = {'diamond','diamond','diamond','o'};

%scatter(pos(1,13),pos(2,13),2*sz, 200/255*[1 1 1], 'filled');

for it = 1:length(idxs)
    idx = idxs(it);
    color = colors(it,:);
    scatter(pos(1,idx), pos(2,idx),sz,color,'filled',shape{it});
end
% % lim =2.5;
% % xlim([-lim lim]);
% % ylim([-lim lim]);


axis equal off;
