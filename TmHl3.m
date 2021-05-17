classdef TmHl3 < recipHexLattice
    %https://materials.springer.com/isp/crystallographic/docs/sd_1300000
    properties (SetAccess = public, GetAccess = public)
        lambda_tmhl = 2.657/2;
        name
        numLayer = 1;
        tm
        hl
    end
    
    methods        
        function obj = TmHl3(a)
            obj = obj@recipHexLattice(a);
            obj.lambda = 5.678;
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
            
%             mag = ones(length(pos),1);
%             
%             magRu = mag.*(1+exp(-2i*pi/3*(2*hs+ks)));
%             magClt = mag.*(...
%                 exp(-2i*pi/3*hs) +...
%                 exp(-2i*pi/3*ks) +...
%                 exp(-4i*pi/3*(hs+ks) ) );
%             magClb = mag.*(...
%                 exp(-4i*pi/3*hs) +...
%                 exp(-4i*pi/3*ks) +...
%                 exp(-2i*pi/3*(hs+ks) ) );
%             
%             
%             
%             magRu = self.applyScat(pos,magRu,self.tm);
%             magClt = self.applyScat(pos,magClt,self.hl);
%             magClb = self.applyScat(pos,magClb,self.hl);
%             
%             mag = magRu + exp(-1i*self.lambda_tmhl*kz).*magClt...
%                         + exp(+1i*self.lambda_tmhl*kz).*magClb;
%                     
            %Ver Simplified
            magTm = (1+exp(-2i*pi/3*(2*hs+ks)));
%             
            magHl = exp(-1i*pi*hs).*( 2*cos(pi*hs/3-kz*self.lambda_tmhl)) + ...
                    exp(-1i*pi*ks).*( 2*cos(pi*ks/3-kz*self.lambda_tmhl)) + ...
                    exp(-1i*pi*(hs+ks)).*( 2*cos(pi*(hs+ks)/3+kz*self.lambda_tmhl));
                    
            mag = self.applyScat(pos,magTm,self.tm) + ...
                self.applyScat(pos,magHl,self.tm);
                    
        end
        
        
        function [pos, mag] = calculateHK(self,hs,ks)
           if self.numLayer == 1
               [pos, mag] = calculateHK_1L(self,hs,ks);
           end
        end
        
                
        
        % setters
        function setTm(self,val)
            self.tm.Z = val;
            self.tm.fparams = parseElements(val);
        end
        
        function setHl(self,val)
            self.hl.Z = val;
            self.hl.fparams = parseElements(val);
        end
        
        function setNumLayer(self,val)
            self.numLayer = val;
        end
%         
        function setLambda_tmhl(self, val)
            self.lambda_tmhl = val;
        end
        
        function setName(self, val)
            self.name = val;
        end
        
    end
end

