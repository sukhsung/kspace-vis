classdef recipHexLattice < recip_2Dlattice        
    
    properties (SetAccess = public, GetAccess = public)
        a
        b
    end
    methods
        function obj = recipHexLattice( a )
            obj.a = a;
            obj.b = 4*pi/(sqrt(3)*a);
            
            obj.as = a * [1, 1];
            obj.bs = obj.b*[1, 1];
            
            obj.a1 = obj.a * [cosd(0) ; sind(0)];
            obj.a2 = obj.a * [cosd(120); sind(120)];
            
            obj.b1 = obj.b * [cosd(30); sind(30)];
            obj.b2 = obj.b * [cosd(90); sind(90)];
            
            obj.area = (sqrt(3)*obj.a^2/2);   
            
        end
        
        function [x, y] = unitCellOutline(self)
            ang = linspace(30, 390,7);
            x   = self.b* cosd(ang); y = self.b*sind(ang);
        end
    end
end