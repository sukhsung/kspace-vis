classdef CrSBr < recipRectLattice
    %TMDS
    properties (SetAccess = public, GetAccess = public)
        numLayer
        Cr
        S 
        Br
    end
    
    methods        
        function obj = CrSBr()
            obj = obj@recipRectLattice( [4.767; 3.506] );
            obj.setLambda(7.965);
            
            obj.setCr(24);
            obj.setS(16);
            obj.setBr(35);
            
        end
        
        
        function [pos, mag] = calculate(self)
            
            [~,hs,ks] = recip2DMeshGrid(self);            
            [pos, mag] = calculateHK(self,hs,ks);

        end  

        
        function [pos, mag] = calculateHK_1L(self,hs,ks)
            pos = hs*self.b1' + ks*self.b2';
            kz = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            
%             magCr = exp(-2i*pi*(0.25*hs  - 0.25*ks) + 1i*0.13*self.lambda*kz)...;
%                   + exp(-2i*pi*(-0.25*hs + 0.25*ks) - 1i*0.13*self.lambda*kz);
%             
%             magS = exp(-2i*pi*( 0.25*hs + 0.25*ks) - 1i*0.08*self.lambda*kz)...;
%                  + exp(-2i*pi*(-0.25*hs - 0.25*ks) + 1i*0.08*self.lambda*kz);
%             
%             magBr = exp(-2i*pi*( 0.25*hs + 0.25*ks) + 1i*0.35*self.lambda*kz)...;
%                   + exp(-2i*pi*(-0.25*hs - 0.25*ks) - 1i*0.35*self.lambda*kz);
%             magCr = exp( -1i* (pi/2*( hs - ks) + 0.13*self.lambda*kz) )...;
%                   + exp( -1i* (pi/2*(-hs + ks) - 0.13*self.lambda*kz) );
%             
%             magS = exp( -1i* (pi/2*( hs + ks) - 0.08*self.lambda*kz) )...;
%                  + exp( -1i* (pi/2*(-hs - ks) + 0.08*self.lambda*kz) );
%             
%             magBr = exp( -1i* (pi/2*( hs + ks) + 0.35*self.lambda*kz) )...;
%                   + exp( -1i* (pi/2*(-hs - ks) - 0.35*self.lambda*kz) );
              
            magCr = cos( (pi/2*( hs - ks) + 0.13*self.lambda*kz) );
            
            magS = cos( (pi/2*( hs + ks) - 0.08*self.lambda*kz) );
            
            magBr = cos( (pi/2*( hs + ks) + 0.35*self.lambda*kz) );

            
            magCr = self.applyScat(pos,magCr,self.Cr);
            magS = self.applyScat(pos,magS,self.S);
            magBr = self.applyScat(pos,magBr,self.Br);
            
            mag = magCr+magS+magBr;
            
      
        end  
        
        function [pos, mag] = calculateHK_NL(self,hs,ks)
            [pos, mag1L] = self.calculateHK_1L(hs,ks);
            kz = pos(:,3);
            mag = zeros(size(mag1L));
            for N = 1:self.numLayer
                mag = mag+mag1L.*exp(-1i*( kz*self.lambda*(N-1) ) );
            end
            
            mag = mag.*exp(1i*kz*self.lambda*(self.numLayer-1)/2);
        end
            
        
        function [pos, mag] = calculateHK(self,hs,ks)
           if self.numLayer == 1
               [pos, mag] = calculateHK_1L(self,hs,ks);
           else
               [pos, mag] = calculateHK_NL(self,hs,ks);
           end
        end
        
        
        function setNumLayer(self,val)
            self.numLayer = val;
        end
%         
        
        function setName(self, val)
            self.name = val;
        end
        % setters
        function setCr(self,val)
            self.Cr.Z = val;
            self.Cr.fparams = parseElements(val);
        end
        % setters
        function setS(self,val)
            self.S.Z = val;
            self.S.fparams = parseElements(val);
        end
        % setters
        function setBr(self,val)
            self.Br.Z = val;
            self.Br.fparams = parseElements(val);
        end
        
    end
end

