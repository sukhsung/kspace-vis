m = graphene('AC');
m.setKzMode('constant');
m.setSpotcut(1);

xmax= 2*m.b;
[XX,YY] = meshgrid(linspace(-xmax,xmax,256),linspace(-xmax,xmax,256));

sigma = 0.1;

numZ = 256;
intGrid = zeros([size(XX),numZ]);
kz = linspace(-pi/m.lambda, pi/m.lambda, numZ);
z = 1;
for cur_kz = kz

    m.setKzVal(cur_kz);
    [pos,mag] = m.calculate;
    int = mag.*conj(mag);

    int(pos(:,1) == 0 & pos(:,2) == 0) = int(pos(:,1) == 0 & pos(:,2) == 0)*0.05;
    %pos(pos(:,1) == 0 & pos(:,2) == 0,:) = [];
    numPk = length(int);


    for i = 1:numPk
        cur_pk = pos(i,:);
        cur_g  = exp(- ( (XX-cur_pk(1)).^2 + (YY-cur_pk(2)).^2)/(2*sigma^2));
        intGrid(:,:,z) = intGrid(:,:,z) + cur_g * int(i);
    end
    z = z+1;
   
end

numRots =100;
intGridAve = intGrid;
for n = 1: numRots
    Rot = normrnd(0,2);
    intGridRot = imrotate3(intGrid,Rot,[1 0 0],'linear','crop');
    intGridAve = intGridAve + intGridRot;
    disp(n)
end
intGridAve = intGridAve/numRots;




