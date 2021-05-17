classdef TMD < recipHexLattice
    %TMDS
    properties (SetAccess = public, GetAccess = public)
        tm
        ch
        lambda_tmch
        name
        numLayer
    end
    
    methods        
        function obj = TMD(a)
            obj = obj@recipHexLattice(a);
        end
        
        
        function [pos, mag] = calculate(self)
            
            [~,hs,ks] = recip2DMeshGrid(self);            
            [pos, mag] = calculateHK(self,hs,ks);
            mag =  4*pi^2/self.area*mag;

        end  

        
        function [pos, mag] = calculateHK_1H(self,hs,ks)
            pos = hs*self.b1' + ks*self.b2';
            kz = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            
            mag = ones(length(pos),1);

            a0 = mag;
            b0 = mag.*exp(-2i*pi/3*(2*hs+ks));
            c0 = mag.*exp(-2i*pi/3*(hs+2*ks));            
            
            
            magTm = self.applyScat(pos,a0,self.tm);
            magCb = self.applyScat(pos,b0,self.ch);
            magCt = self.applyScat(pos,b0,self.ch);
            
            mag = magTm + exp(-1i*self.lambda_tmch*kz).*magCt...
                        + exp(+1i*self.lambda_tmch*kz).*magCb;
        end
        
        function [pos, mag] = calculateHK_2Ha(self,hs,ks)
            pos = hs*self.b1' + ks*self.b2';
            kz = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            
            mag = ones(length(pos),1);

            a0 = mag;
            b0 = mag.*exp(-2i*pi/3*(2*hs+ks));
            c0 = mag.*exp(-2i*pi/3*(hs+2*ks));   
            
            
            magTm = self.applyScat(pos,a0,self.tm);
            magCb = self.applyScat(pos,b0,self.ch);
            magCt = self.applyScat(pos,b0,self.ch);
            
            magA = magTm + exp(-1i*self.lambda_tmch*kz).*magCt...
                        + exp(+1i*self.lambda_tmch*kz).*magCb;
%                     
            magTm = self.applyScat(pos,a0,self.tm);
            magCb = self.applyScat(pos,c0,self.ch);
            magCt = self.applyScat(pos,c0,self.ch);
            
            magB = magTm + exp(-1i*self.lambda_tmch*kz).*magCt...
                        + exp(+1i*self.lambda_tmch*kz).*magCb;
%                     

            mag = magA.*exp(-1i*self.lambda*kz/2) + magB.*exp(1i*self.lambda*kz/2);
        end        
        
        function [pos, mag] = calculateHK_2Hb(self,hs,ks)
            pos = hs*self.b1' + ks*self.b2';
            kz = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            
            mag = ones(length(pos),1);

            a0 = mag;
            b0 = mag.*exp(-2i*pi/3*(2*hs+ks));
            c0 = mag.*exp(-2i*pi/3*(hs+2*ks));   
            
            
            magTm = self.applyScat(pos,c0,self.tm);
            magCb = self.applyScat(pos,b0,self.ch);
            magCt = self.applyScat(pos,b0,self.ch);
            
            magA = magTm + exp(-1i*self.lambda_tmch*kz).*magCt...
                        + exp(+1i*self.lambda_tmch*kz).*magCb;
%                     
            magTm = self.applyScat(pos,b0,self.tm);
            magCb = self.applyScat(pos,c0,self.ch);
            magCt = self.applyScat(pos,c0,self.ch);
            
            magB = magTm + exp(-1i*self.lambda_tmch*kz).*magCt...
                        + exp(+1i*self.lambda_tmch*kz).*magCb;
%                     

            mag = magA.*exp(-1i*self.lambda*kz/2) + magB.*exp(1i*self.lambda*kz/2);
        end      
        
        function [pos, mag] = calculateHK_2HbxN(self,hs,ks,N)
            [pos, mag_2Hx1] = calculateHK_2Hb(self,hs,ks);
            kz = pos(:,3);
            mag= zeros(size(mag_2Hx1));
            
            for n = 1:N
                mag = mag + ( mag_2Hx1.* exp(-1i*self.lambda*kz*n) );
            end
            
            mag= mag.* exp( 1i*self.lambda*kz*(N+1)/2 );            
        end              
        
        function [pos, mag] = calculateHK_1T(self,hs,ks)
            pos = hs*self.b1' + ks*self.b2';
            kz = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            
            mag = ones(length(pos),1);

            a0 = mag;
            b0 = mag.*exp(-2i*pi/3*(2*hs+ks));
            c0 = mag.*exp(-2i*pi/3*(hs+2*ks));                 
            
            
            magTm = self.applyScat(pos,a0,self.tm);
            magCb = self.applyScat(pos,b0,self.ch);
            magCt = self.applyScat(pos,c0,self.ch);
            
            mag = magTm + exp(-1i*self.lambda_tmch*kz).*magCt...
                        + exp(+1i*self.lambda_tmch*kz).*magCb;
      
        end  
        
        function [pos, mag] = calculateHK_2T(self,hs,ks)
            [pos, mag] = calculateHK_1T(self,hs,ks);
            kz = pos(:,3);
      
            mag = mag.*exp(-1i*self.lambda*kz/2) + mag.*exp(1i*self.lambda*kz/2);
        end
        
        
        function [pos, mag] = calculateHK(self,hs,ks)
           if strcmp(self.stacking, '1H')
               [pos, mag] = calculateHK_1H(self,hs,ks);
           elseif strcmp(self.stacking, '1T')
               [pos, mag] = calculateHK_1T(self,hs,ks);
           elseif strcmp(self.stacking, '2T')
               [pos, mag] = calculateHK_2T(self,hs,ks);
           elseif strcmp(self.stacking, '2Ha')
               [pos, mag] = calculateHK_2Ha(self,hs,ks);
           elseif strcmp(self.stacking, '2Hb')
               [pos, mag] = calculateHK_2Hb(self,hs,ks);
           elseif strcmp(self.stacking, '2HbxN')
               [pos, mag] = calculateHK_2HbxN(self,hs,ks,self.numLayer);
           end
        end
        
                
        function setStacking(self,val)
            %if strcmp(val,'1H') || strcmp(val,'1T') || strcmp(val,'2H')|| strcmp(val,'nH')
            self.stacking=val;
            if strcmp(val,'1H') || strcmp(val,'1T')
                self.setLambda(self.lambda_tmch*2)
            else
                self.setLambda(6.1475); %N.S. from arizona cryst. db %6.144); 
            end
            %else
            %    disp('Invalid Stacking, Setting to 1H')
            %    self.stacking = '1H';
            %end
        end
        
        
        % setters
        function setTm(self,val)
            self.tm.Z = val;
            self.tm.fparams = parseElements(val);
        end
        
        function setCh(self,val)
            self.ch.Z = val;
            self.ch.fparams = parseElements(val);
        end
        
        function setNumLayer(self,val)
            self.numLayer = val;
        end
        
        function setLambda_tmch(self, val)
            self.lambda_tmch = val;
        end
        
        function setName(self, val)
            self.name = val;
        end
        
    end
end

