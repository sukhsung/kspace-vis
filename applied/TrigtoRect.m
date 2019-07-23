%close all
%clear all
% Visualizing transition from hexagonal to rectangular lattice symmetry


t = erf(linspace(-3,3,130));
tp = (t+1)/2;
tn = -tp +1;
%realspace
%v= VideoWriter('BLG_R.avi','Uncompressed AVI');
%open(v);
a = 1;
a1 = a*[2*pi/sqrt(3); 0 ];
a2 = a*[0; 2*pi/1];
x = 0.1;
r1 = x*a1 + 0.5*a2;

[pos, m,n] = indexedMeshGrid(5,a1,a2);

posA = pos;
pos1(:,1) = pos(:,1);
pos1(:,2) = pos(:,2);
%posA = [posA; pos1];

posB(:,1) = posA(:,1) +r1(1);
posB(:,2) = posA(:,2) +r1(2);

posC(:,1) = posA(:,1) +2*r1(1);
posC(:,2) = posA(:,2) +2*r1(2);

posAr2 = posA(:,1).^2 + posA(:,2).^2;
posBr2 = posB(:,1).^2 + posB(:,2).^2;



mag = 1+exp(-2i*pi*(x*m + 0.5*n));
int = mag.*conj(mag);


%posA(posAr2> (12*a)^2,:) = [];
%posB(posBr2> (12*a)^2,:) = [];

%[119,2,178]; [15,170,204];
clA = ones(length(posA),1) * [119,2,178];
clB = ones(length(posB),1) * [119,2,178];

figure
%set(gcf,'Position',[0 0 2000 2000])
hold on
%scatter(posA(:,1),posA(:,2),150,clA/255,'.');
scatter(posA(:,1),posA(:,2),150*int,clA/255,'.');
%scatter(posB(:,1),posB(:,2),150,clB/255,'.');

axis equal off


