classdef recipRectLattice < recip_2Dlattice        
    
    properties (SetAccess = public, GetAccess = public)
    end
    methods
        function obj = recipRectLattice( as )
            obj.as = as;
            obj.bs = 2*pi./as;
                        
            obj.a1 = obj.as(1) * [1; 0];
            obj.a2 = obj.as(2) * [0; 1];
            
            obj.b1 = obj.bs(1) * [1; 0];
            obj.b2 = obj.bs(2) * [0; 1];
            
            obj.area = obj.as(1)*obj.as(2);
            
        end
        
        function [x,y] = unitCellOutline( self )
            b1 = self.bs(1); b2 = self.bs(2);
            x = [b1, -b1, -b1,  b1, b1];
            y = [b2,  b2, -b2, -b2, b2];
        end
    end
end