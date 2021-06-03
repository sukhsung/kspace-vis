classdef RuCl3_buckled < TmHl3
    %https://materials.springer.com/isp/crystallographic/docs/sd_1300000
    properties (SetAccess = public, GetAccess = public)
        dRu =  [0.174, -0.137];
        dClt = [0.1, -0.062, 0.106];
        dClb = [0.126, 0.136, 0.153];
    end
    
    methods        
        function obj = RuCl3_buckled()
            obj = obj@TmHl3(5.97900);
            obj.setLambda(5.86);
            obj.setLambda_tmhl(2.657/2);
            obj.lambda = 5.7233;
            obj.setTm(44);
            obj.setHl(17);
            obj.numLayer = 1;
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

            magRu = exp(-1i*kz*self.dRu(1) ) +  ...
                     exp(-2i*pi/3*(hs+2*ks)).*exp(-1i*kz.*self.dRu(2) );

            magCl = exp(-2i*pi*hs/3).* exp(- 1i*kz.*(self.lambda_tmhl+self.dClt(1)) ) + ...
                    exp(-2i*pi*ks/3).* exp(- 1i*kz.*(self.lambda_tmhl+self.dClt(2)) ) + ...
                    exp(-4i*pi*(hs+ks)/3).*exp( - 1i*kz.*(self.lambda_tmhl+self.dClt(3)) ) + ...
                    exp(-4i*pi*hs/3).* exp(- 1i*kz.*(-self.lambda_tmhl+self.dClb(1)) ) + ...
                    exp(-4i*pi*ks/3).* exp(- 1i*kz.*(-self.lambda_tmhl+self.dClb(2)) ) + ...
                    exp(-2i*pi*(hs+ks)/3).*exp( - 1i*kz.*(-self.lambda_tmhl+self.dClb(3)) );
                
            mag = self.applyScat(pos,magRu,self.tm) + ...
                  self.applyScat(pos,magCl,self.hl);

        end
        
        
        function [pos, mag] = calculateHK_nL(self,hs,ks)
            
            [pos,mag1L] = self.calculateHK_1L(hs,ks);
            
            
            
            mag = zeros(size( mag1L ));
            
            kz = pos(:,3);
            
            for indLayer = 1:self.numLayer
                
                if rem(indLayer,3) == 1
                    mag = mag+mag1L.*exp(-1i*kz*self.lambda*indLayer);
                elseif rem(indLayer,3) == 2
                    mag = mag+...
                        mag1L.*exp(-1i*(2*pi/3*(2*hs+ks)+kz*self.lambda*indLayer));
                elseif rem(indLayer,3) == 0
                    mag = mag+...
                        mag1L.*exp(-1i*(2*pi/3*(hs+2*ks)+kz*self.lambda*indLayer));
                end
            
            end
            
            mag = mag.*exp(1i*kz*self.lambda*(self.numLayer+1)/2);
            
                    
        end
        
        
        function [pos, mag] = calculateHK(self,hs,ks)
               [pos, mag] = calculateHK_nL(self,hs,ks);
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

