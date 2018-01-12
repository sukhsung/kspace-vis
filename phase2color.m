function rgb = phase2color(phase)
% Convert angle data to rgb triplet
% Color chosen to have constant chroma in lab space
% theta : n x 1 phase angle in radians
% rgb   : n x 3 RGB triplet
% Written by Suk Hyun Sung, sukhsung@umich.edu
% Jan. 05 2018
    
    radius = 70;                  % chroma
    l      = 70;
    a = radius * cos(phase);
    b = radius * sin(phase);
    L = l*ones(length(phase),1); % lightness
    Lab = [L, a, b];
    rgb = lab2rgb(Lab,'outputtype','uint8');
    rgb = double(rgb)/255;
end