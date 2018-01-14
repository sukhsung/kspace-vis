classdef graphene < recip_2Dlattice
    %GRAPHENE Summary of this class goes here
    %   Detailed explanation goes here
    properties (Constant)
        a = 2.467;             
        area = sqrt(3)*graphene.a^2/2;              %Area of a unit cell
    end
    
    methods        
        function obj = graphene()
            obj = obj@recip_2Dlattice;
            obj.setB1(2 * pi/(sqrt(3)*obj.a) * [sqrt(3); -1]);
            obj.setB2(4 * pi/(sqrt(3)*obj.a) * [0; 1]);
            obj.setB(sqrt(dot(obj.b1,obj.b1)));              %in rad/Ang
            obj.setLambda(3.346);
        end
        
        function fg = fg_hk(self,h,k)
            fg = 8*pi^2/self.area*exp(-1i*pi/3*(h+k)).*cos(pi/3*(h+k));
        end
        
    end
end

