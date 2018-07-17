


b = 2.9409;

theta = linspace(0,30,100);

kz = sqrt(3)*b*tand(theta);

lambda = 3.346;
N = 4;

num = 1-cos(2*kz*lambda*N);
den = 1-cos(2*kz*lambda);

y = num./den ;

yInt = y.* (cos(kz*lambda/2).^2);


figure
subplot(1,4,1)
plot(theta,num);
subplot(1,4,2)
plot(theta,den);
subplot(1,4,3)
plot(theta,y);
subplot(1,4,4)
plot(theta,yInt);