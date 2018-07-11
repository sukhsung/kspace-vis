classdef SLG < graphene        
    methods
        function setDraw(obj,val)
            obj.draw = val;
        end
        function [pos,mag,h,k] = calculate(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = self.fg_hk(h,k);
            mag = mag.*exp(-2i*pi*(h+k)/3);
            if self.includeScat
                mag = self.applyScat(pos,mag,6);
            end
            self.setTitle('SLG')
        end
    end
end