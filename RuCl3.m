classdef RuCl3 < TmHl3
    %https://materials.springer.com/isp/crystallographic/docs/sd_1300000
    properties (SetAccess = public, GetAccess = public)
    end
    
    methods        
        function obj = RuCl3()
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
            magRu = (1+exp(-2i*pi/3*(2*hs+ks)));
%             
            magCl = exp(-1i*pi*hs).*( 2*cos(pi*hs/3-kz*self.lambda_tmhl)) + ...
                    exp(-1i*pi*ks).*( 2*cos(pi*ks/3-kz*self.lambda_tmhl)) + ...
                    exp(-1i*pi*(hs+ks)).*( 2*cos(pi*(hs+ks)/3+kz*self.lambda_tmhl));
                    
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

