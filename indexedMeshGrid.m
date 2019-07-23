function [varargout] = indexedMeshGrid(varargin)
    % Create meshgrid of integer multiples of lattice vectors (2D or 3D)
    % circular masking is performed to create radially symmetric grid
    % input: spotcut, a1, a2, (a3)
    % spotcut : determine radius of cutoff. radius = spotcut* |a1|
    % a1,a2,a3 : lattice vectors, a3 is optional
    % the lattice vectors are column vectors
    %
    % output: pos, h,k, (l)
    % pos: n*3 matrix of mesh positions
    % h,k,l: indices of pos
    
    if length(varargin) == 4
        a3 = varargin{4};
    elseif length(varargin) == 3
        a3 = [0;0;0];
    end
    
    spotcut = varargin{1};
    a1 = varargin{2};
    a2 = varargin{3};
    
    if length(a1) == 2
        a1 = [a1;0];
    end
    if length(a2) == 2
        a2 = [a2;0];
    end
    if length(a3) ==2
        a3 = [a3;0];
    end
    
    
    
    [h,k,l] = ndgrid(-spotcut:spotcut,-spotcut:spotcut,-spotcut:spotcut);
    cutoff = sqrt(dot(a1,a1))*spotcut*1.1;    %k space cutoff
    %cutoff = sqrt(dot(a1,a1))*sqrt(3)*1.1;    %k space cutoff

    h = reshape(h,[numel(h),1]);
    k = reshape(k,[numel(k),1]);
    l = reshape(l,[numel(l),1]);
    
    x = h*a1(1)+k*a2(1)+l*a3(1);
    y = h*a1(2)+k*a2(2)+l*a3(2);
    z = h*a1(3)+k*a2(3)+l*a3(3);
    r = sqrt(x.^2+y.^2+z.^2);
   
    h(r> cutoff) = [];
    k(r> cutoff) = [];
    l(r> cutoff) = [];

    x = h*a1(1)+k*a2(1)+l*a3(1);
    y = h*a1(2)+k*a2(2)+l*a3(2);
    z = h*a1(3)+k*a2(3)+l*a3(3);
    pos = [x,y,z];
    varargout{1} = pos;
    varargout{2} = h;
    varargout{3} = k;
    varargout{4} = l;
end