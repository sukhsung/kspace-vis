classdef graphene < recip_2Dlattice

    properties (SetAccess = private, GetAccess = public)
        theta
        stacking
    end
    
    methods
        function obj = graphene(varargin)
            obj.setLambda(3.346);
            obj.setA(2.467);
            obj.setB1(2 * pi/(sqrt(3)*obj.a) * [sqrt(3); -1]);
            obj.setB2(4 * pi/(sqrt(3)*obj.a) * [0; 1]);
            obj.setB(sqrt(dot(obj.b1,obj.b1)));              %in rad/Ang
            obj.setArea(sqrt(3)*obj.a^2/2);   
            obj.setIntensityFactor(10);
            
            if isempty(varargin)
                obj.setStacking('C')
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
        
        
        function [pos, mag] = calculateHK(self,hs,ks)
            
            pos = hs*self.b1' + ks*self.b2';
            kz = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            
            mag = zeros(length(pos),1);

            a0 = self.fg_hk(hs,ks);
            b0 = self.fg_hk(hs,ks).*exp(-2i*pi/3*(hs+ks));
            c0 = self.fg_hk(hs,ks).*exp(-4i*pi/3*(hs+ks));            
            
            for i = 1:length(self.stacking)
               layer = self.stacking(i);
               zfactor = exp(-1i.*self.lambda.*kz.*i);
               if layer == 'A'
                   mag = mag + a0.*zfactor;
               elseif layer=='B'
                   mag = mag+ b0.*zfactor;
               elseif layer == 'C'
                   mag = mag + c0.*zfactor;
               else
                   display(['error at index' num2str(i)]);
               end
            end
            
            mag = mag.*exp(1i.*self.lambda.*kz.*(1+length(self.stacking))./2);
            
            if self.includeScat
                mag = self.applyScat(pos,mag,6);
            end 
            
        end
        
        function [pos, mag] = calculateABC(self)
            
            [~,hs,ks] = recip2DMeshGrid(self);            
            [pos, mag] = calculateHK(self,hs,ks);

        end        
        
        function fg = fg_hk(self,h,k)
            fg = 8*pi^2/self.area*exp(-1i*pi/3*(h+k)).*cos(pi/3*(h+k));
        end
        
        function [pos,mag] = calculate(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = self.fg_hk(h,k);
            
            if strcmp(self.stacking, 'uTBG')
                pos_t = self.rotPos(pos,-self.theta/2);
                pos_b = self.rotPos(pos,self.theta/2);
                mag_t = mag.*exp(-1i*kz*self.lambda/2);
                mag_b = mag.*exp(1i*kz*self.lambda/2);

                pos = [pos_t;pos_b];
                mag = [mag_t;mag_b];
            else         
                [pos,mag] = calculateABC(self);
            end
         
            if self.includeScat
                mag = self.applyScat(pos,mag,6);
            end                
        end
        
        function [pos,mag] = calculateReal(self)
            
            
        end
    end
end