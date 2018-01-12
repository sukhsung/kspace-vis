classdef SLG < graphene        
    methods
        function setDraw(obj,val)
            obj.draw = val;
        end
        function [pos,mag] = calculate(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = self.fg_hk(h,k);
            if self.includeScat
                mag = self.applyScat(pos,mag);
            end
        end
    end
end