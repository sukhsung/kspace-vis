close all
clear all

x_m       = 1/2;
lambda_mo = 0;

x_tu      = 5/37;
x_tl      = 24/37;
x_bu      = 31/37;
x_bl      = 11/37;
lambda_long  = -1.5;
lambda_short  = -1.5;



a = 2.46;
%a1 = a*[1; 0 ];
%a2 = a*[cosd(60); sind(60)];
a1 = [5; 0];
a2 = [0; 3.161];
r1 =  (a1+a2);

[pos, m,n] = indexedMeshGrid(2,a1,a2);



posMo1 = [pos(:,1), pos(:,2), pos(:,3)];
posS1 =  [pos(:,1)+1/3*a1, pos(:,2)+1/3*a1, pos(:,3) ];



posMo1 = [pos(:,1), pos(:,2), pos(:,3) + lambda_mo];
posMo2 = [pos(:,1)+x_m*a1(1),pos(:,2)+0.5*a2(2),pos(:,3) - lambda_mo];

pos_tu = [pos(:,1)+x_tu*a1(1), pos(:,2)+0.5*a2(2), pos(:,3)+lambda_long];
pos_tl = [pos(:,1)+x_tl*a1(1), pos(:,2), pos(:,3)+lambda_short];
pos_bu = [pos(:,1)+x_bu*a1(1), pos(:,2)+0.5*a2(2), pos(:,3)-lambda_short];
pos_bl = [pos(:,1)+x_bl*a1(1), pos(:,2), pos(:,3)-lambda_long];


%posA = pos;
% pos1(:,1) = pos(:,1) + r1(1);
% pos1(:,2) = pos(:,2) + r1(2);
% pos1(:,3) = pos(:,3);
% posA = [posA; pos1];



%posAr2 = posA(:,1).^2 + posA(:,2).^2;
%posA(posAr2> (30*a)^2,:) = [];
% 0 164 204
clMo = ones(length(posMo1),1) * [255 196 49];
clS = ones(length(posMo2),1) * [0 164 204];


figure
hold on
scatter3(posMo1(:,1),posMo1(:,2),posMo1(:,3),200,clMo/255,'.');
scatter3(posMo2(:,1),posMo2(:,2),posMo2(:,3),200,clMo/255,'.');
scatter3(pos_tu(:,1),pos_tu(:,2),pos_tu(:,3),200,clS/255,'.');
scatter3(pos_tl(:,1),pos_tl(:,2),pos_tl(:,3),200,clS/255,'.');
scatter3(pos_bu(:,1),pos_bu(:,2),pos_bu(:,3),200,clS/255,'.');
scatter3(pos_bl(:,1),pos_bl(:,2),pos_bl(:,3),200,clS/255,'.');
axis equal

