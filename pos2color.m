function rgb = pos2color(pos)
% Convert polar position to rgb triplet
% Color chosen to have chroma centered on 60 in Lab space
% theta : n x 1 phase angle in radians
% rgb   : n x 3 RGB triplet
% Written by Noah Schnitzer
% 7 March 2018

        dist = pos(:,1).^2 + pos(:,2).^2;
        norm_dist = dist- min(dist);
        norm_dist = norm_dist./max(norm_dist);


        L = norm_dist.*20+50;
        nangle = atan2(pos(:,1), pos(:,2));
        a = cos(nangle).*L;
        bb = sin(nangle).*L;
            Lab = [L, a, bb];
        rgb = lab2rgb(Lab,'outputtype','uint8');
        rgb = double(rgb)/255;
end