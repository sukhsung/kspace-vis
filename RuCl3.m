classdef RuCl3 < recipHexLattice
    %https://materials.springer.com/isp/crystallographic/docs/sd_1300000
    properties (SetAccess = public, GetAccess = public)
        Z_Ru = 44
        Z_Cl = 17
        lambda_RuCl = 17.17000*0.088
        
        name
        numLayer = 1;
    end
    
    methods        
        function obj = RuCl3()
            obj = obj@recipHexLattice(5.97900);
        end
        
        
        function [pos, mag] = calculate(self)
            
            [~,hs,ks] = recip2DMeshGrid(self);            
            [pos, mag] = calculateHK(self,hs,ks);
            mag =  4*pi^2/self.area*mag;
            self.lambda = 17.17000/3;

        end  

        
        function [pos, mag] = calculateHK_1L(self,hs,ks)
            pos = hs*self.b1' + ks*self.b2';
            kz = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            
            mag = ones(length(pos),1);
            
            magRu = mag.*(1+exp(-4i*pi/3*(hs+ks)));
            magClt = mag.*(...
                exp(-2i*pi/3*hs) +...
                exp(-4i*pi/3*ks) +...
                exp(-2i*pi/3*(2*hs+ks) ) );
            magClb = mag.*(...
                exp(-4i*pi/3*hs) +...
                exp(-2i*pi/3*ks) +...
                exp(-2i*pi/3*(hs+2*ks) ) );
            
            
            
            magRu = self.applyScat(pos,magRu,self.Z_Ru);
            magClt = self.applyScat(pos,magClt,self.Z_Cl);
            magClb = self.applyScat(pos,magClb,self.Z_Cl);
            
            mag = magRu + exp(-1i*self.lambda_RuCl*kz).*magClt...
                        + exp(+1i*self.lambda_RuCl*kz).*magClb;
        end
        
        
        function [pos, mag] = calculateHK(self,hs,ks)
           if self.numLayer == 1
               [pos, mag] = calculateHK_1L(self,hs,ks);
           end
        end
        
                
        
        % setters
        function setTm(self,val)
            self.tm = val;
        end
        
        function setCh(self,val)
            self.ch = val;
        end
        
        function setNumLayer(self,val)
            self.numLayer = val;
        end
        
%         function setA(self,val)
%             self.a = val;
%             self.area = sqrt(3)*val^2/2;        
%         end
%         
        function setLambda_tmch(self, val)
            self.lambda_tmch = val;
        end
        
        function setName(self, val)
            self.name = val;
        end
        
    end
end

