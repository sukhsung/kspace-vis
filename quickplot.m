kTilt = tiltrange;
kInt = I;

figure;
for i = 1:25
    subplot(5,5,i);
    plot(kTilt,kInt(i,:));
end