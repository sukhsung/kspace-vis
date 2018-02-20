%using:
%sim_tilts
%sim_ints

%exp_tilts
%exp_ints 

%tiltrange
%I

%kin_tilts = tiltrange;
%kin_ints = I;

%lower_kin_tilts = tiltrange;
%lower_kin_ints = I;

%upper_kin_tilts = tiltrange;
%upper_kin_ints = I;

%sim  |  exp |  kin
%10,16| 3,(6)|  2               great
%8,18 |  9   |  7   left shift  great
%12,14|  4   |  4   right shift great
%2,6  |(2),5 |  5,6             ok
%5,3  |  8   |                  nada
%4    |  7   |  9,10            good
%1    |  1   |  9,10            bad

phase = [0,40,180]';%[0,40,180]';
radius = 70;                  % chroma
l      = 70;
a = radius * cos(phase);
b = radius * sin(phase);
L = l*ones(length(phase),1); % lightness
Lab = [L, a, b];
rgb = lab2rgb(Lab,'outputtype','uint8');
rgb = double(rgb)/255;

%colors = [rg      ];
colors = rgb;


eXScale = 1;
eYScale = 1;
eXShift = 0;
eYShift = 0;

kXScale = 1*180./pi;
kYScale = 1.69;
kcos_correct = 1. ./ cos(tiltrange(1,:));
kXShift = -1.9;
kYShift = 0;

lower_kXScale = 1*180./pi;
lower_kYScale = 1.3;
lower_kcos_correct = 1. ./ cos(tiltrange(1,:));
lower_kXShift = -1.9;
lower_kYShift = 0;

upper_kXScale = 1*180./pi;
upper_kYScale = 2.068;
upper_kcos_correct = 1. ./ cos(tiltrange(1,:));
upper_kXShift = -1.9;
upper_kYShift = 0;



simXScale = 1;
simYScale = .9;
simcos_correct = 1. ./ cosd(sim_tilts(1,:));
simXShift = -1.9;
simYShift = 0;



e_domain = [3,9,7];

k_domain = [4,2,6];

s_domain = [10,8,4];

adj_eTilt = round(exp_tilts.*eXScale+eXShift,1);
adj_eInt  = exp_ints.*eYScale + eYShift;

adj_kTilt = round(kin_tilts.*kXScale+kXShift,1);
adj_kInt  = kin_ints.*kYScale.*kcos_correct + kYShift;



low_adj_kTilt = round(lower_kin_tilts.*kXScale+kXShift,1);
low_adj_kInt  = lower_kin_ints.*kYScale.*kcos_correct + kYShift;

up_adj_kTilt = round(upper_kin_tilts.*kXScale+kXShift,1);
up_adj_kInt  = upper_kin_ints.*kYScale.*kcos_correct + kYShift;

min_val_on = min(adj_kInt(k_domain(1),:));
min_bel = min(low_adj_kInt(k_domain(1),:));
min_ab = min(up_adj_kInt(k_domain(1),:));

low_adj_kInt  = low_adj_kInt .* min_val_on ./ min_bel;

up_adj_kInt  = up_adj_kInt .* min_val_on ./ min_ab;


adj_sTilt = sim_tilts.*simXScale+simXShift;
adj_sInt = sim_ints.*simYScale.*simcos_correct + simYShift;




figure;
hold on;
%plot(sim_tilts(1,:), sim_ints(sim_range,:).*sim_scale,'--', 'LineWidth',1, 'Color', color);
for i = 1:3
   G1 = plot(adj_eTilt(1,:), adj_eInt(e_domain(i),:),'o', 'Color',colors(:,i));
   G2 = plot(adj_kTilt,adj_kInt(k_domain(i),:),'LineWidth',3,'Color',colors(:,i));
   %G3 = plot(adj_sTilt(1,:), adj_sInt(s_domain(i),:),'--','Color',colors(:,i));
   G4 = plot(low_adj_kTilt,low_adj_kInt(k_domain(i),:),':','LineWidth',1,'Color',colors(:,i));
   G5 = plot(up_adj_kTilt,up_adj_kInt(k_domain(i),:),':','LineWidth',1,'Color',colors(:,i));
end

legend([G1,G2],'Experimental Data','Kinematic Model')
set(findall(gcf,'-property','FontSize'),'FontSize',18)
xlabel('Tilt Angle (degrees)');
ylabel('Normalized Intensity (a.u.)');