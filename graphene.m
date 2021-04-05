classdef graphene < recipHexLattice

    properties (SetAccess = private, GetAccess = public)
        theta = deg2rad(5);
    end
    
    
    methods
        % constructor for graphene
        % vargin takes stacking config for graphene
        % stacking should be string comprised of 'A', 'B' or 'C' 
        % or 'uTBG' (unrelaxed TBG) with second argument for twist angle
        function obj = graphene(stacking)
            
            obj = obj@recipHexLattice( 2.467 );
            obj.setLambda(3.346);
            obj.setKzExtent(2*pi/obj.lambda);
            if nargin == 0
                obj.setStacking('C')
            elseif nargin == 1
                obj.setStacking(stacking);              
            end
        end
        
        
        function setStacking(self,val)
            self.stacking=val;

            if isequal(val,'uTBG')
                fprintf('twist angle = %f deg\n',rad2deg(self.theta))
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
            
            if strcmp(self.stacking,'uTBG')
                
                pos_t = self.rotPos(pos,-self.theta/2);
                pos_b = self.rotPos(pos,self.theta/2);
                mag_t = b0.*exp(-1i*kz*self.lambda/2);
                mag_b = b0.*exp(1i*kz*self.lambda/2);

                pos = [pos_t;pos_b];
                mag = [mag_t;mag_b];
                
                % TODO add overlapping rods in phase
            else
                for ind = 1:length(self.stacking)
                   layer = self.stacking(ind);
                   zfactor = exp(-1i.*self.lambda.*kz.*ind);
                   if layer == 'A'
                       mag = mag + a0.*zfactor;
                   elseif layer=='B'
                       mag = mag+ b0.*zfactor;
                   elseif layer == 'C'
                       mag = mag + c0.*zfactor;
                   else
                       display(['error at index' num2str(ind)]);
                   end
                end
                mag = mag.*exp(1i.*self.lambda.*kz.*(1+length(self.stacking))./2);
            end
            if self.includeScat
                mag = self.applyScat(pos,mag,6);
            end    
            
        end
        
        function fg = fg_hk(self,h,k)
            fg = 8*pi^2/self.area*exp(-1i*pi/3*(h+k)).*cos(pi/3*(h+k));
        end
        
        function [pos,mag] = calculate(self)
            [~,h,k] = recip2DMeshGrid(self);
            [pos, mag] = self.calculateHK(h,k);
        end
        
    end
end