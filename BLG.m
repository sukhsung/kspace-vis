classdef BLG < graphene        
    properties (SetAccess = private, GetAccess = public)
        stacking
        theta
    end
    methods
        function obj = BLG(varargin)
            if isempty(varargin)
                obj.setStacking('AB')
            else
                obj.setStacking(varargin{1});
                if isequal(obj.stacking,'uTBG')
                    if length(varargin)>1
                        obj.setTheta(deg2rad(varargin{2}));
                    else
                        obj.setTheta(deg2rad(5));
                        disp('default twist angle = 5 deg')
                    end
                end
            end
        end
        
        
        function setStacking(self,val)
            self.stacking=val;
            if isequal(val,'uTBG') && isempty(self.theta)
                self.setTheta(deg2rad(5));
                disp('default twist angle = 5 deg')
            end
            self.setTitle(self.stacking)
                
        end 
        function setTheta(self,val)
            self.theta=val;
        end 
        
        function [pos,mag] = calculate(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = self.fg_hk(h,k);
            switch self.stacking
                case 'AA'
                    mag = 2*cos(kz*self.lambda/2).*mag;
                case 'AB'
                    mag = 2*exp(-1i*pi*(h+k)/3).*cos(kz*self.lambda/2+pi/3*(h+k)).*mag;
                case 'BA'                    
                    mag = 2*exp(-1i*pi*(h+k)/3).*cos(kz*self.lambda/2-pi/3*(h+k)).*mag;
                case 'uTBG'
                    pos_t = self.rotPos(pos,-self.theta/2);
                    pos_b = self.rotPos(pos,self.theta/2);
                    mag_t = mag.*exp(-1i*kz*self.lambda/2);
                    mag_b = mag.*exp(1i*kz*self.lambda/2);
                    
                    pos = [pos_t;pos_b];
                    mag = [mag_t;mag_b];
            end
            if self.includeScat
                mag = self.applyScat(pos,mag,6);
            end
        end
    end
end